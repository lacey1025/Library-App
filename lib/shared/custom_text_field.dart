import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({super.key, this.textController, this.errorMessage});

  final TextEditingController? textController;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textController,
      cursorColor: Colors.white,
      cursorErrorColor: const Color.fromARGB(255, 255, 53, 53),
      autofocus: true,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        errorMaxLines: 3,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 255, 53, 53)),
        ),
        errorText: errorMessage,
        errorStyle: TextStyle(color: const Color.fromARGB(255, 255, 53, 53)),
      ),
    );
  }
}
