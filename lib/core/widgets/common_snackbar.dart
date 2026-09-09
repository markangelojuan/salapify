import 'package:flutter/material.dart';

class CommonSnackbar {
  static void showError(BuildContext context, Object error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_sanitizeError(error)),
        backgroundColor: Colors.red.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  static void showWarning(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.amber.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  static String _sanitizeError(Object error) {
    final message = error.toString();

    const errorMap = {
      'user-not-found': 'No account found with this email.',
      'wrong-password': 'Incorrect password.',
      'invalid-credential': 'Invalid email or password.',
      'email-already-in-use': 'This email is already registered.',
      'weak-password': 'Password is too weak.',
      'network-request-failed': 'No internet connection.',
      'too-many-requests': 'Too many attempts. Please try again later.',
      'user-disabled': 'This account has been disabled.',
    };

    for (final entry in errorMap.entries) {
      if (message.contains(entry.key)) return entry.value;
    }


    if (error is String) return message;

    return 'Something went wrong. Please try again.';
  }
}
