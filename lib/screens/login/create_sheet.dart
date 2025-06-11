import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/database/library_database.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/screens/home/home.dart';
import 'package:library_app/shared/flashing_logo.dart';
import 'package:library_app/shared/gradient_button.dart';

class CreateSheet extends ConsumerStatefulWidget {
  const CreateSheet({super.key});

  @override
  ConsumerState<CreateSheet> createState() => _CreateSheetState();
}

class _CreateSheetState extends ConsumerState<CreateSheet> {
  final PageController _pageController = PageController();
  final TextEditingController _libraryNameController = TextEditingController();
  final TextEditingController _folderNameController = TextEditingController();
  final TextEditingController _sheetNameController = TextEditingController();

  String? _folderId;
  String? _sheetId;
  String? _folderName;
  String? _sheetName;
  String? _libraryName;
  bool _validInput = true;
  bool _isCreating = false;

  @override
  void dispose() {
    _pageController.dispose();
    _libraryNameController.dispose();
    _folderNameController.dispose();
    _sheetNameController.dispose();
    super.dispose();
  }

  void _goToNextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _goToPreviousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _createFolder({
    required GoogleSignIn signIn,
    required Map<String, String> authHeaders,
  }) async {
    final folderResponse = await http.post(
      Uri.parse('https://www.googleapis.com/drive/v3/files'),
      headers: authHeaders,
      body: jsonEncode({
        'name': _folderName,
        'mimeType': 'application/vnd.google-apps.folder',
      }),
    );

    if (folderResponse.statusCode != 200) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to create folder.")));
      return;
    }

    _folderId = jsonDecode(folderResponse.body)['id'];
  }

  Future<void> _createSheet({
    required GoogleSignIn signIn,
    required Map<String, String> authHeaders,
  }) async {
    final sheetResponse = await http.post(
      Uri.parse('https://sheets.googleapis.com/v4/spreadsheets'),
      headers: authHeaders,
      body: jsonEncode({
        'properties': {'title': _sheetName},
      }),
    );

    if (sheetResponse.statusCode != 200) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to create sheet.")));
      return;
    }

    _sheetId = jsonDecode(sheetResponse.body)['spreadsheetId'];

    await http.patch(
      Uri.parse(
        'https://www.googleapis.com/drive/v3/files/$_sheetId?addParents=$_folderId&removeParents=root&fields=id,parents',
      ),
      headers: authHeaders,
    );
  }

  Future<void> _createInitialHeaders({
    required GoogleSignIn signIn,
    required Map<String, String> authHeaders,
  }) async {
    const initialHeaders = [
      'Catalog Number',
      'Title',
      'Composer',
      'Arranger',
      'Notes',
      'Category',
      'SubCategories',
      'Status',
      'Link',
      'Change Time',
    ];
    final url = Uri.parse(
      'https://sheets.googleapis.com/v4/spreadsheets/$_sheetId/values/Sheet1!A1:J1:append?valueInputOption=RAW',
    );

    final response = await http.post(
      url,
      headers: authHeaders,
      body: jsonEncode({
        'values': [initialHeaders],
      }),
    );

    if (response.statusCode != 200) {
      print("Failed to write headers: ${response.body}");
    }
  }

  Future<void> _createFolderAndSheet() async {
    if (_isCreating) return;

    setState(() {
      _isCreating = true;
    });

    try {
      final googleSignIn = ref.read(googleSignInProvider);
      final auth = await googleSignIn.currentUser?.authentication;
      final token = auth?.accessToken;

      if (token == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Authentication failed.")));
        return;
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      await _createFolder(signIn: googleSignIn, authHeaders: headers);
      await _createSheet(signIn: googleSignIn, authHeaders: headers);
      await _createInitialHeaders(signIn: googleSignIn, authHeaders: headers);

      if (!mounted) return;
      final startInfo = await ref.read(appInitializerProvider.future);
      final userId = startInfo.googleAccount!.id;
      final session = SessionsCompanion(
        libraryName: Value(_libraryName!),
        userId: Value(userId),
        sheetId: Value(_sheetId!),
        driveFolderId: Value(_folderId),
        isAdmin: Value(true),
        isActive: Value(true),
        isUserPrimary: Value(true),
        hasSheetErrors: Value(false),
      );
      await ref.read(sessionProvider.notifier).setSession(session);
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const Home()));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: ${e.toString()}")));
    } finally {
      if (mounted) {
        setState(() {
          _isCreating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isCreating
              ? Center(child: FlashingLogo())
              : Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromRGBO(24, 24, 24, 1),
                          Color.fromRGBO(52, 52, 52, 1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(alpha: 0.8),
                            Colors.white.withValues(alpha: 0.03),
                          ],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: Image.asset(
                        'assets/img/redbull.png',
                        height: 400,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildLibraryNameInput(),
                      _buildFolderNameInput(),
                      _buildSheetNameInput(),
                      _buildSummaryScreen(),
                    ],
                  ),
                ],
              ),
    );
  }

  Widget _buildLibraryNameInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Please choose a name for your Library",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 28),
          TextField(
            controller: _libraryNameController,
            decoration: InputDecoration(
              labelText: "Library Name",
              labelStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            textInputAction: TextInputAction.next,
          ),
          if (!_validInput)
            Text(
              "Please enter a name",
              style: TextStyle(color: Colors.red[500]),
            ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GradientButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  text: Text("Back"),
                  height: 24,
                  colorStart: Color.fromRGBO(87, 87, 87, 1),
                  colorEnd: Color.fromRGBO(37, 37, 37, 1),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: GradientButton(
                  onPressed: () {
                    if (_libraryNameController.text.isEmpty) {
                      setState(() {
                        _validInput = false;
                      });
                    } else {
                      setState(() {
                        _validInput = true;
                      });
                      _libraryName = _libraryNameController.text;
                      _goToNextPage();
                    }
                  },
                  text: Text("Next"),
                  height: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFolderNameInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Please choose a name for a folder to store your digital music library",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 28),
          TextField(
            controller: _folderNameController,
            decoration: InputDecoration(
              labelText: "Folder Name",
              labelStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            textInputAction: TextInputAction.next,
          ),
          if (!_validInput)
            Text(
              "Please enter a name",
              style: TextStyle(color: Colors.red[500]),
            ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GradientButton(
                  onPressed: _goToPreviousPage,
                  text: Text("Back"),
                  height: 24,
                  colorStart: Color.fromRGBO(87, 87, 87, 1),
                  colorEnd: Color.fromRGBO(37, 37, 37, 1),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: GradientButton(
                  onPressed: () {
                    if (_folderNameController.text.isEmpty) {
                      setState(() {
                        _validInput = false;
                      });
                    } else {
                      setState(() {
                        _validInput = true;
                      });
                      _folderName = _folderNameController.text;
                      _goToNextPage();
                    }
                  },
                  text: Text("Next"),
                  height: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSheetNameInput() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Please choose a name for your music catalog Google Sheet",
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: 28),
          TextField(
            controller: _sheetNameController,
            decoration: InputDecoration(
              labelText: "Sheet Name",
              labelStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            textInputAction: TextInputAction.next,
          ),
          if (!_validInput)
            Text(
              "Please enter a name",
              style: TextStyle(color: Colors.red[500]),
            ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: GradientButton(
                  onPressed: _goToPreviousPage,
                  text: Text("Back"),
                  height: 24,
                  colorStart: Color.fromRGBO(87, 87, 87, 1),
                  colorEnd: Color.fromRGBO(37, 37, 37, 1),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: GradientButton(
                  onPressed: () {
                    if (_sheetNameController.text.isEmpty) {
                      setState(() {
                        _validInput = false;
                      });
                    } else {
                      setState(() {
                        _validInput = true;
                      });
                      _sheetName = _sheetNameController.text;
                      _goToNextPage();
                    }
                  },
                  text: Text("Next"),
                  height: 24,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Create library now?",
              overflow: TextOverflow.visible,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            SizedBox(height: 24),
            Text(
              "Library Name: $_libraryName",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Folder Name: $_folderName",
              style: TextStyle(color: Colors.white),
            ),
            Text(
              "Sheet Name: $_sheetName",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: GradientButton(
                    onPressed: _goToPreviousPage,
                    text: Text("Back"),
                    height: 24,
                    colorStart: Color.fromRGBO(87, 87, 87, 1),
                    colorEnd: Color.fromRGBO(37, 37, 37, 1),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GradientButton(
                    onPressed: _createFolderAndSheet,
                    text: Text("Create"),
                    height: 24,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
