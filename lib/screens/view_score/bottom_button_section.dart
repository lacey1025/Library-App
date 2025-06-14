import 'package:flutter/material.dart';
import 'package:library_app/shared/global_snackbar.dart';
import 'package:library_app/shared/gradient_button.dart';

class BottomButtonsSection extends StatelessWidget {
  final bool edit;
  final VoidCallback onReset;
  final VoidCallback onDelete;

  const BottomButtonsSection({
    super.key,
    required this.edit,
    required this.onReset,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: GlobalSnackbar.isSnackbarVisible,
      builder: (context, isVisible, _) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 10, 4, 5),
                      child: GradientButton(
                        onPressed: onReset,
                        colorStart: Color.fromRGBO(87, 87, 87, 1),
                        colorEnd: Color.fromRGBO(37, 37, 37, 1),
                        text: Text(
                          edit ? "Reset" : "Back",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 10, 8, 5),
                      child: GradientButton(
                        onPressed: onDelete,
                        text: Text(
                          "Delete Score",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (isVisible) SizedBox(height: 50),
          ],
        );
      },
    );
  }
}
