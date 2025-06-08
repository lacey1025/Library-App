import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/database/library_database.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/screens/home/home.dart';
import 'package:library_app/shared/gradient_button.dart';

class JoinLibraryScreen extends ConsumerStatefulWidget {
  final String sheetId;
  final String folderId;
  final String libraryName;

  const JoinLibraryScreen({
    super.key,
    required this.sheetId,
    required this.folderId,
    required this.libraryName,
  });

  @override
  ConsumerState<JoinLibraryScreen> createState() => _JoinLibraryScreenState();
}

class _JoinLibraryScreenState extends ConsumerState<JoinLibraryScreen> {
  @override
  Widget build(BuildContext context) {
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

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Do you want to join this library?",
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                Text(
                  widget.libraryName,
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 60),
                GradientButton(
                  onPressed: () async {
                    final account =
                        await ref.read(googleSignInProvider).signInSilently();
                    if (mounted && account == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Not signed in")),
                      );
                      return;
                    }

                    final session = UserSessionData(
                      libraryName: widget.libraryName,
                      userId: account!.id,
                      sheetId: widget.sheetId,
                      driveFolderId: widget.folderId,
                      isAdmin: false,
                      isActive: true,
                    );

                    await ref
                        .read(sessionProvider.notifier)
                        .setSession(session);

                    if (!mounted) return;
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => Home()),
                    );
                  },
                  text: const Text(
                    "Join",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'GI',
                      fontWeight: FontWeight.w700,
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
