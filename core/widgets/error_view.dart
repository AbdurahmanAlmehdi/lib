import 'package:flutter/material.dart';
import 'package:buzzy_bee/core/theme/app_typography.dart';
import 'package:buzzy_bee/core/extensions/context_extensions.dart';

class ErrorView extends StatelessWidget {
  final String? errorMessage;
  final VoidCallback? onRetry;
  final String? retryLabel;

  const ErrorView({
    super.key,
    this.errorMessage,
    this.onRetry,
    this.retryLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: context.colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              errorMessage ?? context.t.error,
              style: AppTypography.bodyLarge(context),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onRetry,
                child: Text(retryLabel ?? context.t.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

