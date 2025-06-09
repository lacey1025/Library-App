// lib/screens/link_library/setting_up_page.dart
import 'package:flutter/material.dart';

class SettingUpPage extends StatelessWidget {
  const SettingUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Setting up your library...",
            textAlign: TextAlign.center,
            overflow: TextOverflow.visible,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 28),
          const SizedBox(
            height: 100,
            width: 100,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
