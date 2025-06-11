import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/screens/home/home.dart';
import 'package:library_app/screens/invite/join_screen.dart';
import 'package:library_app/screens/login/no_library_screen.dart';
import 'package:library_app/shared/gradient_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  final String? linkSheetId;
  final String? linkFolderId;
  final String? libraryName;

  const LoginScreen({
    super.key,
    this.linkSheetId,
    this.linkFolderId,
    this.libraryName,
  });

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool isSignInError = false;

  GoogleSignInAccount? _user;

  Future<void> _handleSignIn() async {
    try {
      final account = await ref.read(googleSignInProvider).signIn();
      if (account == null) {
        setState(() {
          isSignInError = true;
        });
        return;
      } else {
        setState(() {
          isSignInError = false;
        });
      }

      setState(() {
        _user = account;
      });

      final session = await ref
          .read(sessionProvider.notifier)
          .getUserCurrentSession(account.id);
      // final session = await ref.read(sessionProvider.future);

      if (widget.linkSheetId != null && widget.linkFolderId != null) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (_) => JoinLibraryScreen(
                  sheetId: widget.linkSheetId!,
                  folderId: widget.linkFolderId!,
                  libraryName: widget.libraryName!,
                ),
          ),
        );
      }
      // Maybe check if sheet is in drive - could also do in upload
      else if (session != null) {
        if (!session.isActive) {
          ref.read(sessionProvider.notifier).activateUserPrimary(account.id);
        }
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const Home()));
      } else {
        if (!mounted) return;
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => NoLibraryScreen()));
      }
    } catch (error) {
      setState(() {
        isSignInError = true;
      });
    }
  }

  Future<void> _handleSignOut() async {
    await ref.read(googleSignInProvider).signOut();
    await ref.read(sessionProvider.notifier).logout();
    setState(() {
      _user = null;
    });
  }

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
          Center(
            child:
            // _user == null
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to the 34th ID Band Library Management App!",
                    style: Theme.of(context).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  Text(
                    "To continue, please sign in with Google",
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  GradientButton(
                    onPressed: _handleSignIn,
                    text: Text(
                      "Google Sign In",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    height: 40,
                    // width: 320,
                    icon: Icon(Icons.login, color: Colors.white, size: 20),
                  ),
                  SizedBox(height: 32),
                  if (isSignInError)
                    Text(
                      "Error signing in. Please try again",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
            ),
            // : Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     CircleAvatar(
            //       backgroundImage: NetworkImage(_user!.photoUrl ?? ''),
            //       radius: 30,
            //     ),
            //     const SizedBox(height: 10),
            //     Text('Hello, ${_user!.displayName}'),
            //     const SizedBox(height: 10),
            //     ElevatedButton.icon(
            //       onPressed: _handleSignOut,
            //       icon: const Icon(Icons.logout),
            //       label: const Text('Sign out'),
            //     ),
            //     const SizedBox(height: 10),
            //     if (widget.linkFolderId != null &&
            //         widget.linkSheetId != null)
            //       ElevatedButton.icon(
            //         onPressed: () {
            //           Navigator.of(context).pushReplacement(
            //             MaterialPageRoute(
            //               builder:
            //                   (_) => JoinLibraryScreen(
            //                     sheetId: widget.linkSheetId!,
            //                     folderId: widget.linkFolderId!,
            //                     libraryName: widget.libraryName!,
            //                   ),
            //             ),
            //           );
            //         },
            //         icon: const Icon(Icons.logout),
            //         label: const Text('Continue with this account'),
            //       ),
            //   ],
            // ),
          ),
        ],
      ),
    );
  }
}

/*
user signs in to google account
if already linked to a library - go to that library
if not, option to create new or join
creating new would cause them to be an admin, join would be regular user

BUTTON OPTIONS:
* create library
* join library
* sign in as admin

CREATE LIBRARY FLOW:
* link existing sheet/folder or start new
* add users

*/
