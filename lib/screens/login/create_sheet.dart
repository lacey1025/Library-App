import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/database/library_database.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/shared/appbar.dart';

class CreateSheet extends ConsumerStatefulWidget {
  const CreateSheet({super.key});

  @override
  ConsumerState<CreateSheet> createState() => _CreateSheetState();
}

class _CreateSheetState extends ConsumerState<CreateSheet> {
  final PageController _pageController = PageController();
  final TextEditingController _folderNameController = TextEditingController();
  final TextEditingController _sheetNameController = TextEditingController();

  String? _folderId;
  String? _sheetId;
  String? _folderName;
  String? _sheetName;
  bool _validInput = true;

  @override
  void dispose() {
    _pageController.dispose();
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
      print(folderResponse.body);
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
      print(sheetResponse.body);
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to create sheet.")));
      return;
    }

    _sheetId = jsonDecode(sheetResponse.body)['spreadsheetId'];
    print("Sheet created: $_sheetId");

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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Folder and sheet created successfully!")),
    );
    final startInfo = await ref.read(appInitializerProvider.future);
    final userId = startInfo.googleAccount!.id;
    final session = UserSessionData(
      userId: userId,
      sheetId: _sheetId!,
      driveFolderId: _folderId,
      isAdmin: true,
      isActive: true,
    );
    await ref.read(sessionProvider.notifier).setSession(session);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Create Library"),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _buildFolderNameInput(),
          _buildSheetNameInput(),
          _buildSummaryScreen(),
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
          const Text("Name Your Folder"),
          TextField(
            controller: _folderNameController,
            decoration: const InputDecoration(labelText: "Folder Name"),
          ),
          if (!_validInput)
            Text(
              "Please enter a name",
              style: TextStyle(color: Colors.red[600]),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Back"),
              ),
              ElevatedButton(
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
                child: Text("Next"),
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
          const Text("Name Your Sheet"),
          TextField(
            controller: _sheetNameController,
            decoration: const InputDecoration(labelText: "Sheet Name"),
          ),
          if (!_validInput)
            Text(
              "Please enter a name",
              style: TextStyle(color: Colors.red[600]),
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: _goToPreviousPage, child: Text("Back")),
              ElevatedButton(
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
                child: const Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Folder: $_folderName", style: TextStyle(color: Colors.white)),
          Text("Sheet: $_sheetName", style: TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: _goToPreviousPage, child: Text("Back")),
              ElevatedButton(
                onPressed: _createFolderAndSheet,
                child: const Text("Create"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
