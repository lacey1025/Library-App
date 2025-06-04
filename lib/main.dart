import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:library_app/screens/splash_screen/splash_screen.dart';
import 'package:library_app/theme.dart';

void main() {
  runApp(
    ProviderScope(
      child: MaterialApp(theme: primaryTheme, home: SplashScreen()),
    ),
  );
}
