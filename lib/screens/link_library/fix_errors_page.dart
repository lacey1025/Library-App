import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/providers/database_provider.dart';
import 'package:library_app/providers/session_provider.dart';
import 'package:library_app/screens/home/home.dart';
import 'package:library_app/shared/flashing_logo.dart';
import 'package:library_app/shared/gradient_button.dart';
import 'package:library_app/utils/exceptions.dart';
import 'package:library_app/utils/google_sheet_importer.dart';
import 'package:library_app/utils/schema_validator.dart';
import 'package:url_launcher/url_launcher.dart';

class FixErrorsPage extends ConsumerStatefulWidget {
  const FixErrorsPage({super.key});

  @override
  ConsumerState<FixErrorsPage> createState() => _FixErrorsPageState();
}

class _FixErrorsPageState extends ConsumerState<FixErrorsPage> {
  final List<ImportError> errors = [];
  final List<String> missingHeaders = [];

  bool _urlLaunchSuccess = true;
  bool _hasLaunchedUrl = false;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _retryUpload();
    });
  }

  Future<void> _fixNowClick() async {
    final googleSignIn = ref.read(googleSignInProvider);
    final auth = await googleSignIn.currentUser?.authentication;
    final token = auth?.accessToken;

    if (token == null) return;

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final session = await ref.read(sessionProvider.future);
    if (session == null) return;

    final sheetId = session.sheetId;
    _openGoogleSheet(headers, sheetId);
  }

  Future<void> _retryUpload() async {
    if (mounted) {
      setState(() {
        _isRetrying = true;
        missingHeaders.clear();
      });
    }
    final startInfo = await ref.read(appInitializerProvider.future);
    final authHeaders = await startInfo.googleAccount!.authHeaders;
    final db = ref.read(databaseProvider);

    final session = await ref.read(sessionProvider.future);
    if (session == null) {
      return;
    }
    final sheetId = session.sheetId;

    final importer = GoogleSheetImporter(
      sheetId: sheetId,
      authHeaders: authHeaders,
      db: db,
    );

    final List<ImportError> newErrors = [];
    try {
      newErrors.addAll(await importer.importScores());
    } on MissingHeaderException catch (e) {
      setState(() {
        missingHeaders.addAll(e.missingHeaders);
        _isRetrying = false;
      });
      return;
    } catch (e) {
      debugPrint("unexpected import error: $e");
      if (mounted) {
        setState(() {
          _isRetrying = false;
        });
      }
      return;
    }

    if (newErrors.isEmpty) {
      ref.read(sessionProvider.notifier).updateHasErrors(session.id, false);
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (_) => const Home()));
    } else {
      ref.read(sessionProvider.notifier).updateHasErrors(session.id, true);
      setState(() {
        errors.clear();
        errors.addAll(newErrors);
        _isRetrying = false;
        _hasLaunchedUrl = false;
      });
    }
  }

  Future<void> _openGoogleSheet(
    Map<String, String> authHeaders,
    String sheetId,
  ) async {
    try {
      final sheetUrl = "https://docs.google.com/spreadsheets/d/$sheetId/edit";
      final Uri url = Uri.parse(sheetUrl);

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
        setState(() {
          _urlLaunchSuccess = true;
          _hasLaunchedUrl = true;
        });
      } else {
        setState(() => _urlLaunchSuccess = false);
        debugPrint("Could not launch $sheetUrl");
      }
    } catch (e) {
      setState(() => _urlLaunchSuccess = false);
      debugPrint("launchUrl failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
        child:
            _isRetrying
                ? Center(child: FlashingLogo())
                : SafeArea(
                  child: Column(
                    children: [
                      if (missingHeaders.isEmpty)
                        ..._buildErrorList(context)
                      else
                        ..._buildMissingHeaders(context),

                      const SizedBox(height: 28),

                      if (!_urlLaunchSuccess)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Text(
                            "Could not open Google Sheet. Please try again or check your browser.",
                            style: Theme.of(context).textTheme.headlineMedium,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.visible,
                          ),
                        ),

                      GradientButton(
                        onPressed:
                            _hasLaunchedUrl ? _retryUpload : _fixNowClick,
                        text: Text(
                          _hasLaunchedUrl ? "Retry upload" : "Fix Now",
                        ),
                      ),

                      GradientButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const Home()),
                          );
                        },
                        text: const Text("Continue and fix later"),
                        colorStart: const Color.fromRGBO(87, 87, 87, 1),
                        colorEnd: const Color.fromRGBO(37, 37, 37, 1),
                      ),
                    ],
                  ),
                ),
      ),
    );
  }

  List<Widget> _buildErrorList(BuildContext context) {
    return [
      Text(
        "Almost Done!",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      const SizedBox(height: 8),
      Text(
        "We found a few errors in your Google Sheet. The following rows will not be imported",
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineMedium,
        overflow: TextOverflow.visible,
      ),
      const SizedBox(height: 28),
      Expanded(
        child: ListView.builder(
          itemCount: errors.length,
          itemBuilder: (context, index) {
            final error = errors[index];
            return Card(
              color: Colors.grey[800],
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                title: Text(
                  (error.rowIndex > 0)
                      ? "Row: ${error.rowIndex}"
                      : "System error",
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  error.message,
                  overflow: TextOverflow.visible,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            );
          },
        ),
      ),
    ];
  }

  List<Widget> _buildMissingHeaders(BuildContext context) {
    return [
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Your spreadsheet is missing some crucial headers. Please add the following:",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ...missingHeaders.map(
              (h) => Text(
                h,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontSize: 24),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ];
  }
}
