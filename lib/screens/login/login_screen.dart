import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:library_app/shared/appbar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'https://www.googleapis.com/auth/drive.readonly'],
  );

  GoogleSignInAccount? _user;

  Future<void> _handleSignIn() async {
    try {
      final account = await _googleSignIn.signIn();
      setState(() {
        _user = account;
      });
    } catch (error) {
      print("Sign in error: $error");
    }
  }

  Future<void> _handleSignOut() async {
    await _googleSignIn.signOut();
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
                ? ElevatedButton.icon(
                  onPressed: _handleSignIn,
                  icon: const Icon(Icons.login),
                  label: const Text('Sign in with Google'),
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
