import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/database/library_database.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/screens/link_library/fix_errors_page.dart';
import 'package:library_app/screens/link_library/folder_selection_page.dart';
import 'package:library_app/screens/link_library/library_name_page.dart';
import 'package:library_app/screens/link_library/setup_loading_page.dart';
import 'package:library_app/screens/link_library/sheet_selection_page.dart';
import 'package:library_app/shared/gradient_button.dart';

class LinkLibraryScreen extends ConsumerStatefulWidget {
  const LinkLibraryScreen({super.key});

  @override
  ConsumerState<LinkLibraryScreen> createState() => _LinkLibraryScreenState();
}

class _LinkLibraryScreenState extends ConsumerState<LinkLibraryScreen> {
  List<dynamic> _folders = [];
  List<dynamic> _sheets = [];
  String? _selectedFolderId;
  String? _selectedSheetId;
  String? _libraryName;
  bool _error = false;
  bool _validInput = true;
  final TextEditingController _libraryNameController = TextEditingController();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadFiles();
  }

  Future<void> _loadFiles() async {
    final signIn = ref.read(googleSignInProvider);
    final auth = await signIn.currentUser?.authentication;
    final token = auth?.accessToken;

    if (token == null) return;

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final folderRes = await http.get(
      Uri.parse(
        "https://www.googleapis.com/drive/v3/files?q=mimeType='application/vnd.google-apps.folder'+and+trashed=false+and+'me'+in+owners&fields=files(id%2Cname)",
      ),
      headers: headers,
    );
    final sheetRes = await http.get(
      Uri.parse(
        "https://www.googleapis.com/drive/v3/files?q=mimeType='application/vnd.google-apps.spreadsheet'+and+trashed=false+and+'me'+in+owners&fields=files(id%2Cname)",
      ),
      headers: headers,
    );

    if (folderRes.statusCode == 200 && sheetRes.statusCode == 200) {
      setState(() {
        _folders = jsonDecode(folderRes.body)['files'];
        _sheets = jsonDecode(sheetRes.body)['files'];
        _error = false;
      });
    } else {
      setState(() {
        _error = true;
      });
    }
  }

  Future<void> _linkLibrary() async {
    final startInfo = await ref.read(appInitializerProvider.future);
    final userId = startInfo.googleAccount!.id;
    final session = SessionsCompanion(
      libraryName: Value(_libraryName!),
      userId: Value(userId),
      sheetId: Value(_selectedSheetId!),
      driveFolderId: Value(_selectedFolderId),
      isAdmin: Value(true),
      isActive: Value(true),
      isUserPrimary: Value(true),
    );
    await ref.read(sessionProvider.notifier).setSession(session);

    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => FixErrorsPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Link Library"),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body:
          _error
              ? _errorMessageWidget()
              : PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  LibraryNamePage(
                    controller: _libraryNameController,
                    validInput: _validInput,
                    onBack: () => Navigator.of(context).pop(),
                    onNext: () {
                      if (_libraryNameController.text.isEmpty) {
                        setState(() => _validInput = false);
                      } else {
                        setState(() {
                          _validInput = true;
                          _libraryName = _libraryNameController.text;
                        });
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                  SheetSelectionPage(
                    sheets: _sheets,
                    selectedSheetId: _selectedSheetId,
                    onSelectSheet:
                        (id) => setState(() => _selectedSheetId = id),
                    onBack: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    onNext:
                        (_selectedSheetId == null)
                            ? null
                            : () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                  ),
                  FolderSelectionPage(
                    folders: _folders,
                    selectedFolderId: _selectedFolderId,
                    onSelectFolder:
                        (id) => setState(() => _selectedFolderId = id),
                    onBack:
                        () => _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        ),
                    onLink: (_selectedFolderId == null) ? null : _linkLibrary,
                  ),
                  const SettingUpPage(),
                ],
              ),
    );
  }

  Widget _errorMessageWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Error loading files"),
          SizedBox(height: 24),
          GradientButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            height: 30,
            width: 300,
            text: Text("Back", style: Theme.of(context).textTheme.bodyMedium),
            colorStart: Color.fromRGBO(87, 87, 87, 1),
            colorEnd: Color.fromRGBO(37, 37, 37, 1),
          ),
        ],
      ),
    );
  }
}
