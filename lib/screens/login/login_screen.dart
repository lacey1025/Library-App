import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/screens/home/home.dart';
import 'package:library_app/screens/login/no_library_screen.dart';
import 'package:library_app/shared/appbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

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
        isSignInError = true;
        return;
      } else {
        isSignInError = false;
      }

      setState(() {
        _user = account;
      });

      final sheetExists = await ref
          .read(sessionProvider.notifier)
          .switchSession(account.id);
      final session = await ref.read(sessionProvider.future);

      // Maybe check if sheet is in drive - could also do in upload
      if (sheetExists && session != null) {
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
      isSignInError = true;
    }
  }

  Future<void> _handleSignOut() async {
    await ref.read(googleSignInProvider).signOut();
    setState(() {
      _user = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Login"),
      body: Center(
        child:
            _user == null
                ? Column(
                  children: [
                    if (isSignInError)
                      Text("Error signing in. Please try again"),
                    ElevatedButton.icon(
                      onPressed: _handleSignIn,
                      icon: const Icon(Icons.login),
                      label: const Text('Sign in with Google'),
                    ),
                  ],
                )
                : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(_user!.photoUrl ?? ''),
                      radius: 30,
                    ),
                    const SizedBox(height: 10),
                    Text('Hello, ${_user!.displayName}'),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: _handleSignOut,
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign out'),
                    ),
                  ],
                ),
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
