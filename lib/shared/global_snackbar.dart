import 'package:flutter/material.dart';

class GlobalSnackbar {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static final ValueNotifier<bool> isSnackbarVisible = ValueNotifier(false);

  static void show({
    required String message,
    VoidCallback? onRetry,
    bool isError = false,
    Duration duration = const Duration(seconds: 3),
  }) {
    if (isSnackbarVisible.value) {
      messengerKey.currentState?.hideCurrentSnackBar();
    }

    final snackBar = SnackBar(
      backgroundColor: Color.fromRGBO(217, 0, 0, 0.3),
      content: Text(message, overflow: TextOverflow.visible),
      duration: duration,
      action:
          isError && onRetry != null
              ? SnackBarAction(label: 'Retry', onPressed: onRetry)
              : null,
    );

    final controller = messengerKey.currentState?.showSnackBar(snackBar);

    isSnackbarVisible.value = true;

    controller?.closed.then((_) {
      isSnackbarVisible.value = false;
    });
  }
}
