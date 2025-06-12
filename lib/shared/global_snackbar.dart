import 'package:flutter/material.dart';

class GlobalSnackbar {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void show({
    required String message,
    VoidCallback? onRetry,
    bool isError = false,
    Duration duration = const Duration(seconds: 10),
  }) {
    final snackBar = SnackBar(
      content: Text(message, overflow: TextOverflow.visible),
      duration: duration,
      action:
          isError && onRetry != null
              ? SnackBarAction(label: 'Retry', onPressed: onRetry)
              : null,
    );

    messengerKey.currentState?.showSnackBar(snackBar);
  }
}
