import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/screens/login/create_sheet.dart';
import 'package:library_app/screens/link_library/link_library.dart';
import 'package:library_app/screens/login/login_screen.dart';
import 'package:library_app/shared/gradient_button.dart';

class NoLibraryScreen extends ConsumerWidget {
  const NoLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(24, 24, 24, 1),
                  Color.fromRGBO(52, 52, 52, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.8),
                    Colors.white.withValues(alpha: 0.03),
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/img/redbull.png',
                height: 400,
                fit: BoxFit.contain,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "No library found for your account.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 24),
                  GradientButton(
                    onPressed: () {
                      Navigator.of(
                        context,
                      ).push(MaterialPageRoute(builder: (_) => CreateSheet()));
                    },
                    text: Text("Create New Library"),
                    icon: Icon(Icons.add),
                    height: 30,
                    colorStart: Color.fromRGBO(87, 87, 87, 1),
                    colorEnd: Color.fromRGBO(37, 37, 37, 1),
                  ),
                  const SizedBox(height: 12),
                  GradientButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => LinkLibraryScreen()),
                      );
                    },
                    text: Text("Link My Google Sheets Catalog"),
                    icon: Icon(Icons.folder_open),
                    height: 30,
                    colorStart: Color.fromRGBO(87, 87, 87, 1),
                    colorEnd: Color.fromRGBO(37, 37, 37, 1),
                  ),
                  const SizedBox(height: 12),
                  GradientButton(
                    onPressed: null,
                    text: Text(
                      "Join Existing Library",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(Icons.login, color: Colors.white),
                    height: 30,
                    colorStart: Color.fromRGBO(87, 87, 87, 1),
                    colorEnd: Color.fromRGBO(37, 37, 37, 1),
                  ),
                  const SizedBox(height: 12),
                  GradientButton(
                    onPressed: () {
                      ref.read(googleSignInProvider).signOut();
                      ref.read(sessionProvider.notifier).logout();
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    text: Text(
                      "Switch Account",
                      style: TextStyle(color: Colors.white),
                    ),
                    icon: Icon(Icons.login, color: Colors.white),
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
