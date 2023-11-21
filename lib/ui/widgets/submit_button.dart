import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  const SubmitButton({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(
          theme.colorScheme.primary,
        ),
        foregroundColor: MaterialStatePropertyAll(
          theme.colorScheme.onPrimary,
        ),
      ),
      child: const Text('Submit', style: TextStyle(height: 3)),
    );
  }
}
