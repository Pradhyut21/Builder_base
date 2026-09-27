import 'package:flutter/material.dart';
import 'package:queuesync_client/queuesync_client.dart';
import '../../../theme.dart';

/// State 2 — Waiting.
/// Hero position number (airport departure board style), people-ahead count,
/// and a subtle "Leave queue" text-button (not competing with the hero number).
///
/// Position animates smoothly when it changes — no jump-cuts.
class WaitingView extends StatelessWidget {
  final QueueEntry entry;
  final List<QueueEntry> queue;
  final VoidCallback onLeave;

  const WaitingView({
    super.key,
    required this.entry,
    required this.queue,
    required this.onLeave,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;
    final position = entry.position > 0 ? entry.position : 1;
    final peopleAhead = position - 1;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? AppSpacing.lg : AppSpacing.xxxl,
          vertical: AppSpacing.xl,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Status chip — color + label, never color alone.
            _StatusChip(
              label: 'Waiting',
              color: AppColors.statusWaiting,
              icon: Icons.schedule,
            ),

            const SizedBox(height: AppSpacing.xxl),

            // Hero position number — airport departure board feel.
            // AnimatedSwitcher gives a smooth count-down transition.
            Semantics(
              label: 'Your position in the queue is $position',
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, animation) => ScaleTransition(
                  scale: animation,
                  child: FadeTransition(opacity: animation, child: child),
                ),
                child: Text(
                  '$position',
                  key: ValueKey(position),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: isMobile ? (size.width < 380 ? 72 : 96) : 128,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                    height: 1.0,
                    letterSpacing: -4,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              'Your position',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // People ahead count.
            if (peopleAhead > 0)
              Text(
                '$peopleAhead ${peopleAhead == 1 ? 'person' : 'people'} ahead of you',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                semanticsLabel:
                    '$peopleAhead ${peopleAhead == 1 ? 'person' : 'people'} ahead of you in the queue',
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  'You\'re almost next!',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    // statusCalledOn, not the bright warning amber — the
                    // bright shade measures ~2:1 contrast here, well under
                    // the 4.5:1 WCAG AA minimum. See theme.dart.
                    color: AppColors.statusCalledOn,
                  ),
                ),
              ),

            const SizedBox(height: AppSpacing.xxl),

            // Leave queue — subtle, not visually competing with the position number.
            // Small text button, not a prominent action.
            Semantics(
              label: 'Leave the queue',
              child: TextButton(
                onPressed: onLeave,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textMuted,
                ),
                child: const Text('Leave queue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;

  const _StatusChip({
    required this.label,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16, semanticLabel: label),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
