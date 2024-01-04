import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void showSessionExpiredDialog(BuildContext context) => showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('Session Expired'),
        content: const Text(
          'Sorry, your session has expired, please log in again.',
        ),
        actions: [
          FilledButton(
            onPressed: () => context.goNamed('sign in'),
            child: const Text('OK'),
          ),
        ],
      ),
    );

void showSomeErrorDialog(BuildContext context, String errorMessage) => showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text('An Error Occurred'),
        content: Text(
          'Sorry, there is some error, with the following message: $errorMessage',
        ),
        actions: [
          FilledButton(
            onPressed: () => context.pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
