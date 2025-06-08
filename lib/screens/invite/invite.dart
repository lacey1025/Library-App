import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/shared/app_drawer.dart';
import 'package:library_app/shared/appbar.dart';
import 'package:library_app/shared/gradient_button.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class InviteScreen extends ConsumerStatefulWidget {
  const InviteScreen({super.key});

  @override
  ConsumerState<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends ConsumerState<InviteScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isSending = false;
  String? _inviteLink;
  String? _status;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendInvite() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    setState(() {
      _isSending = true;
    });

    final token = await _getAccessToken();
    if (token == null) {
      _status = "Authentication failed.";
      setState(() => _isSending = false);
      return;
    }

    final authHeaders = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final session = await ref.read(sessionProvider.future);

    if (session == null) {
      _status = "Failed to get session data.";
      setState(() => _isSending = false);
      return;
    }
    final sheetId = session.sheetId;
    final folderId = session.driveFolderId;
    final libraryName = session.libraryName;

    final shared =
        await _shareWithUser(sheetId, email, authHeaders) &&
        await _shareWithUser(folderId!, email, authHeaders);

    if (shared) {
      _inviteLink =
          'libraryapp://join?libraryName=$libraryName&sheetId=$sheetId&folderId=$folderId';
      final emailSuccess = await _sendEmailInvite(email);
      if (emailSuccess) {
        _status = "Invitation sent to $email";
      } else {
        _status = "Failed to send email";
      }
    } else {
      _status = "Failed to share resources";
    }

    setState(() => _isSending = false);
  }

  Future<String?> _getAccessToken() async {
    final googleSignIn = ref.read(googleSignInProvider);
    final currentUser =
        googleSignIn.currentUser ?? await googleSignIn.signInSilently();
    final auth = await currentUser?.authentication;
    return auth?.accessToken;
  }

  Future<bool> _shareWithUser(
    String fileId,
    String email,
    Map<String, String> headers,
  ) async {
    final response = await http.post(
      Uri.parse(
        'https://www.googleapis.com/drive/v3/files/$fileId/permissions',
      ),
      headers: headers,
      body: jsonEncode({
        "role": "writer",
        "type": "user",
        "emailAddress": email,
      }),
    );
    return response.statusCode == 200 || response.statusCode == 204;
  }

  Future<bool> _sendEmailInvite(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      query: Uri.encodeFull(
        'subject=Library App Invite&body=You have been invited to join the Library App! Click here to get started: $_inviteLink',
      ),
    );
    if (await canLaunchUrl(emailUri)) {
      final success = await launchUrl(emailUri);
      return success;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Invite User"),
      drawer: AppDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Enter the user's Google account email:"),
              const SizedBox(height: 12),
              TextField(
                controller: _emailController,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              GradientButton(
                onPressed: _isSending ? null : _sendInvite,
                text:
                    _isSending
                        ? const CircularProgressIndicator()
                        : const Text("Send Invite"),
              ),
              if (_status != null) ...[
                const SizedBox(height: 20),
                Text(_status!),
              ],
              if (_status == "Failed to send email") ...[
                Text("Please provide new user with the following link:"),
                GestureDetector(
                  child: Text(
                    '$_inviteLink',
                    style: TextStyle(
                      overflow: TextOverflow.visible,
                      color: Colors.blue,
                    ),
                  ),
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: _inviteLink!));
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Invite link copied to clipboard.'),
                        ),
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
