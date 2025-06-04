import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/screens/login/create_sheet.dart';
import 'package:library_app/screens/login/login_screen.dart';
import 'package:library_app/shared/appbar.dart';

class NoLibraryScreen extends ConsumerWidget {
  const NoLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: CustomAppBar(title: "Set Up Your Library"),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.library_books, size: 80, color: Colors.blue),
              const SizedBox(height: 16),
              const Text(
                "No library found for your account.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Create New Library"),
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (_) => CreateSheet()));
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                icon: const Icon(Icons.folder_open),
                label: const Text("Link Existing Sheet"),
                onPressed: () {
                  // TODO: Implement select flow
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text("Join Existing Library"),
                onPressed: () {
                  // TODO: Navigate to access code entry screen
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text("Switch account"),
                onPressed: () {
                  ref.read(googleSignInProvider).signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
