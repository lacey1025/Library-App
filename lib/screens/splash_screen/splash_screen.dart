import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/providers/app_initializer.dart';
import 'package:library_app/screens/home/home.dart';
import 'package:library_app/shared/flashing_logo.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

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
    await ref.read(appInitializerProvider.future);
    if (!mounted) return;
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const Home()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: FlashingLogo()));
  }
}
