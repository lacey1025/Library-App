import 'dart:async';
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/screens/splash_screen/splash_screen.dart';
import 'package:library_app/theme.dart';

void main() {
  runApp(const ProviderScope(child: LibraryApp()));
}

class LibraryApp extends StatefulWidget {
  const LibraryApp({super.key});

  @override
  State<LibraryApp> createState() => _LibraryAppState();
}

class _LibraryAppState extends State<LibraryApp> {
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle cold start
    try {
      final initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        _handleUri(initialUri);
      }
    } catch (e) {
      debugPrint('Failed to get initial URI: $e');
    }

    // Handle in-app URIs
    _linkSubscription = _appLinks.uriLinkStream.listen(
      (Uri uri) {
        _handleUri(uri);
      },
      onError: (err) {
        debugPrint('URI stream error: $err');
      },
    );
  }

  void _handleUri(Uri uri) {
    if (uri.scheme == 'libraryapp' && uri.host == 'join') {
      final sheetId = uri.queryParameters['sheetId'];
      final folderId = uri.queryParameters['folderId'];
      final libraryName = uri.queryParameters['libraryName'];

      if (sheetId != null && folderId != null && libraryName != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (_) => SplashScreen(
                    linkSheetId: sheetId,
                    linkFolderId: folderId,
                    libraryName: libraryName,
                  ),
            ),
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library App',
      theme: primaryTheme,
      home: const SplashScreen(),
    );
  }
}
