import 'package:flutter/material.dart';
import 'package:library_app/shared/gradient_button.dart';

class LibraryNamePage extends StatelessWidget {
  final TextEditingController controller;
  final bool validInput;
  final VoidCallback onBack;
  final VoidCallback onNext;

  const LibraryNamePage({
    super.key,
    required this.controller,
    required this.validInput,
    required this.onBack,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
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
            controller: controller,
            decoration: InputDecoration(
              labelText: "Library Name",
              labelStyle: Theme.of(context).textTheme.bodyMedium,
            ),
            style: Theme.of(context).textTheme.bodyMedium,
            textInputAction: TextInputAction.next,
          ),
          if (!validInput)
            Text(
              "Please enter a name",
              style: TextStyle(color: Colors.red[500]),
            ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: GradientButton(
                  onPressed: onBack,
                  text: Text("Back"),
                  height: 24,
                  colorStart: Color.fromRGBO(87, 87, 87, 1),
                  colorEnd: Color.fromRGBO(37, 37, 37, 1),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: GradientButton(
                  onPressed: onNext,
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
}
