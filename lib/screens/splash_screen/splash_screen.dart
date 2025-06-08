import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/screens/home/home.dart';
import 'package:library_app/screens/login/login_screen.dart';
import 'package:library_app/screens/login/no_library_screen.dart';
import 'package:library_app/shared/flashing_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  final String? linkSheetId;
  final String? linkFolderId;
  final String? libraryName;

  const SplashScreen({
    super.key,
    this.linkSheetId,
    this.linkFolderId,
    this.libraryName,
  });

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      final appStartInfo = await ref.read(appInitializerProvider.future);

      if (!mounted) return;

      if (widget.linkSheetId != null && widget.linkFolderId != null) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (_) => LoginScreen(
                  linkSheetId: widget.linkSheetId,
                  linkFolderId: widget.linkFolderId,
                  libraryName: widget.libraryName,
                ),
          ),
        );
      } else if (appStartInfo.googleAccount == null) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
      } else {
        final session = await ref
            .read(sessionProvider.notifier)
            .switchSession(appStartInfo.googleAccount!.id);
        if (session == false) {
          if (!mounted) return;
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => NoLibraryScreen()),
          );
        } else {
          if (!mounted) return;
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => const Home()));
        }
      }
    } catch (e, st) {
      debugPrint('Init error: $e\n$st');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Failed to start app.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: FlashingLogo()));
  }
}
