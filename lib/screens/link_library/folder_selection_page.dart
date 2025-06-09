// lib/screens/link_library/folder_selection_page.dart
import 'package:flutter/material.dart';
import 'package:library_app/shared/gradient_button.dart';

class FolderSelectionPage extends StatelessWidget {
  final List<dynamic> folders;
  final String? selectedFolderId;
  final ValueChanged<String> onSelectFolder;
  final VoidCallback onBack;
  final VoidCallback? onLink;

  const FolderSelectionPage({
    super.key,
    required this.folders,
    required this.selectedFolderId,
    required this.onSelectFolder,
    required this.onBack,
    required this.onLink,
  });

  @override
  Widget build(BuildContext context) {
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
                ...folders.map(
                  (f) => Container(
                    decoration:
                        selectedFolderId == f['id']
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
                            selectedFolderId == f['id']
                                ? Colors.grey
                                : const Color.fromARGB(113, 158, 158, 158),
                      ),
                      title: Text(
                        f['name'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      selected: selectedFolderId == f['id'],
                      onTap: () => onSelectFolder(f['id']),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 8, 0),
                  child: GradientButton(
                    onPressed: onBack,
                    text: Text(
                      "Back",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    colorStart: const Color.fromRGBO(87, 87, 87, 1),
                    colorEnd: const Color.fromRGBO(37, 37, 37, 1),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 4, 0),
                  child: GradientButton(
                    onPressed: onLink,
                    text: Text(
                      "Link Library",
                      style:
                          selectedFolderId == null
                              ? Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey)
                              : Theme.of(context).textTheme.bodyMedium,
                    ),
                    colorStart:
                        selectedFolderId != null
                            ? const Color.fromRGBO(185, 0, 0, 1)
                            : const Color.fromRGBO(44, 44, 44, 1),
                    colorEnd:
                        selectedFolderId != null
                            ? const Color.fromRGBO(100, 0, 0, 1)
                            : const Color.fromRGBO(73, 73, 73, 0.412),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
