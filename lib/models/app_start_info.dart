import 'package:google_sign_in/google_sign_in.dart';
import 'package:library_app/database/library_database.dart';

class AppStartInfo {
  final UserSessionData? session;
  final GoogleSignInAccount? googleAccount;

  AppStartInfo({required this.session, required this.googleAccount});
}
