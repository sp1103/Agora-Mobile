import 'package:flutter/material.dart';

/// Enum for classifying error importance
enum ErrorLevel { info, warning, error }

/// A global error handler that can display snackbars or dialogs safely.
class ErrorHandler {
  static final ValueNotifier<_ErrorMessage?> _notifier = ValueNotifier(null);

  static void showError(
    String message, {
    ErrorLevel level = ErrorLevel.error,
    Duration throttle = const Duration(seconds: 2),
  }) {
    // Prevent spamming the user
    if (_lastShown != null &&
        DateTime.now().difference(_lastShown!) < throttle) {
      return;
    }

    _lastShown = DateTime.now();
    _notifier.value = _ErrorMessage(message, level);
  }

  static DateTime? _lastShown;

  /// Attach this to your app root so it can listen for errors.
  static Widget attachToApp(Widget child) {
    return ValueListenableBuilder<_ErrorMessage?>(
      valueListenable: _notifier,
      builder: (context, value, _) {
        if (value != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            switch (value.level) {
              case ErrorLevel.info:
              case ErrorLevel.warning:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(value.message),
                    backgroundColor: value.level == ErrorLevel.warning
                        ? Colors.orange
                        : Colors.blue,
                  ),
                );
                break;
              case ErrorLevel.error:
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Error"),
                    content: Text(value.message),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("OK"),
                      )
                    ],
                  ),
                );
                break;
            }

            // Reset notifier after showing
            _notifier.value = null;
          });
        }

        return child;
      },
    );
  }
}

class _ErrorMessage {
  final String message;
  final ErrorLevel level;
  _ErrorMessage(this.message, this.level);
}
