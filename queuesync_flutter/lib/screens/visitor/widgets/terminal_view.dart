import 'package:flutter/material.dart';
import '../../../theme.dart';

/// States 4 — Expired/Left/Served.
/// Clear, non-blaming message with optional Rejoin action.
class TerminalView extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool showRejoin;
  final VoidCallback? onRejoin;

  const TerminalView({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.showRejoin,
    this.onRejoin,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: iconColor,
              semanticLabel: title,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (showRejoin && onRejoin != null) ...[
              const SizedBox(height: AppSpacing.xxl),
              ElevatedButton.icon(
                onPressed: onRejoin,
                icon: const Icon(Icons.refresh),
                label: const Text('Rejoin Queue'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
