import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/database/library_database.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/shared/appbar.dart';
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
  bool _loading = true;
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
        _loading = false;
      });
    } else {
      print("Error fetching files: ${folderRes.body}, ${sheetRes.body}");
    }
  }

  Future<void> _linkLibrary() async {
    final startInfo = await ref.read(appInitializerProvider.future);
    final userId = startInfo.googleAccount!.id;
    final session = UserSessionData(
      userId: userId,
      sheetId: _selectedFolderId!,
      driveFolderId: _selectedSheetId,
      isAdmin: true,
      isActive: true,
    );
    await ref.read(sessionProvider.notifier).setSession(session);
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
          _loading
              ? const Center(child: CircularProgressIndicator())
              : PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [_buildSheetSelection(), _buildFolderSelection()],
              ),
    );
  }

  Widget _buildFolderSelection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Text(
                  "Select a Drive Folder to store digital sheet music copies",
                  style: Theme.of(context).textTheme.headlineMedium,
                  overflow: TextOverflow.visible,
                ),
                ..._folders.map(
                  (f) => Container(
                    decoration:
                        _selectedFolderId == f['id']
                            ? BoxDecoration(
                              border: Border.all(
                                color: const Color.fromRGBO(229, 57, 53, 1),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            )
                            : null,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        Icons.folder,
                        color:
                            _selectedFolderId == f['id']
                                ? Colors.grey
                                : const Color.fromARGB(113, 158, 158, 158),
                      ),
                      title: Text(
                        f['name'],
                        style: TextStyle(color: Colors.white),
                      ),
                      selected: _selectedFolderId == f['id'],
                      onTap: () => setState(() => _selectedFolderId = f['id']),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
                    child: GradientButton(
                      onPressed: () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      text: Text(
                        "Back",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      colorStart: Color.fromRGBO(87, 87, 87, 1),
                      colorEnd: Color.fromRGBO(37, 37, 37, 1),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 4, 0),
                    child: GradientButton(
                      onPressed:
                          (_selectedFolderId != null) ? _linkLibrary : null,
                      text: Text(
                        "Link Library",
                        style:
                            _selectedFolderId == null
                                ? Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey)
                                : Theme.of(context).textTheme.bodyMedium,
                      ),
                      colorStart:
                          (_selectedFolderId != null)
                              ? Color.fromRGBO(185, 0, 0, 1)
                              : Color.fromRGBO(44, 44, 44, 1),
                      colorEnd:
                          (_selectedFolderId != null)
                              ? Color.fromRGBO(100, 0, 0, 1)
                              : Color.fromRGBO(73, 73, 73, 0.412),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSheetSelection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Text(
                  "Select your music catalog Google Sheet",
                  style: Theme.of(context).textTheme.headlineMedium,
                  overflow: TextOverflow.visible,
                ),
                ..._sheets.map(
                  (s) => Container(
                    decoration:
                        _selectedSheetId == s['id']
                            ? BoxDecoration(
                              border: Border.all(
                                color: const Color.fromRGBO(229, 57, 53, 1),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            )
                            : null,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        Icons.description,
                        color:
                            _selectedSheetId == s['id']
                                ? const Color.fromARGB(255, 0, 131, 46)
                                : const Color.fromARGB(99, 0, 131, 46),
                      ),
                      title: Text(
                        s['name'],
                        style: TextStyle(color: Colors.white),
                      ),
                      selected: _selectedSheetId == s['id'],
                      onTap: () => setState(() => _selectedSheetId = s['id']),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
                    child: GradientButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      text: Text(
                        "Back",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      colorStart: Color.fromRGBO(87, 87, 87, 1),
                      colorEnd: Color.fromRGBO(37, 37, 37, 1),
                    ),
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 4, 0),
                    child: GradientButton(
                      onPressed:
                          (_selectedSheetId == null)
                              ? null
                              : () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                      text: Text(
                        "Next",
                        style:
                            _selectedSheetId == null
                                ? Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey)
                                : Theme.of(context).textTheme.bodyMedium,
                      ),
                      colorStart:
                          (_selectedSheetId != null)
                              ? Color.fromRGBO(185, 0, 0, 1)
                              : Color.fromRGBO(44, 44, 44, 1),
                      colorEnd:
                          (_selectedSheetId != null)
                              ? Color.fromRGBO(100, 0, 0, 1)
                              : Color.fromRGBO(73, 73, 73, 0.412),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
