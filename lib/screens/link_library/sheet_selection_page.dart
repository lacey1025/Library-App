// lib/screens/link_library/sheet_selection_page.dart
import 'package:flutter/material.dart';
import 'package:library_app/shared/gradient_button.dart';

class SheetSelectionPage extends StatelessWidget {
  final List<dynamic> sheets;
  final String? selectedSheetId;
  final ValueChanged<String> onSelectSheet;
  final VoidCallback onBack;
  final VoidCallback? onNext;

  const SheetSelectionPage({
    super.key,
    required this.sheets,
    required this.selectedSheetId,
    required this.onSelectSheet,
    required this.onBack,
    required this.onNext,
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
                  "Select your music catalog Google Sheet",
                  style: Theme.of(context).textTheme.headlineMedium,
                  overflow: TextOverflow.visible,
                ),
                ...sheets.map(
                  (s) => Container(
                    decoration:
                        selectedSheetId == s['id']
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
                            selectedSheetId == s['id']
                                ? const Color.fromARGB(255, 0, 131, 46)
                                : const Color.fromARGB(99, 0, 131, 46),
                      ),
                      title: Text(
                        s['name'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      selected: selectedSheetId == s['id'],
                      onTap: () => onSelectSheet(s['id']),
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
                    onPressed: onNext,
                    text: Text(
                      "Next",
                      style:
                          selectedSheetId == null
                              ? Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey)
                              : Theme.of(context).textTheme.bodyMedium,
                    ),
                    colorStart:
                        selectedSheetId != null
                            ? const Color.fromRGBO(185, 0, 0, 1)
                            : const Color.fromRGBO(44, 44, 44, 1),
                    colorEnd:
                        selectedSheetId != null
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
