import 'package:flutter/material.dart';
import '../../../theme.dart';

/// State 5 — Connection lost / stream error.
///
/// An explicit reconnecting indicator — never lets the UI silently freeze
/// on a stale position number if the stream drops.
/// This is a specific failure mode to show, not hope doesn't happen.
class ReconnectingBanner extends StatefulWidget {
  const ReconnectingBanner({super.key});

  @override
  State<ReconnectingBanner> createState() => _ReconnectingBannerState();
}

class _ReconnectingBannerState extends State<ReconnectingBanner>
    with SingleTickerProviderStateMixin {
  late AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Reconnecting to live queue. Please wait.',
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        color: AppColors.statusExpired.withValues(alpha: 0.1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.statusExpired,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              'Reconnecting...',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.statusExpired,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
