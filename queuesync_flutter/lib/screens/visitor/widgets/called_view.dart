import 'package:flutter/material.dart';
import 'package:queuesync_client/queuesync_client.dart';
import '../../../theme.dart';

/// State 3 — Called ("you're next").
///
/// Visually DISTINCT from waiting — different color treatment throughout,
/// not just different text. The person must recognize this state without
/// reading it (e.g. from across a waiting room).
///
/// Uses a subtle, non-jarring pulse animation on the ambient background
/// color and the icon — not a flashing alert that causes anxiety.
class CalledView extends StatefulWidget {
  final QueueEntry entry;

  const CalledView({super.key, required this.entry});

  @override
  State<CalledView> createState() => _CalledViewState();
}

class _CalledViewState extends State<CalledView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Semantics(
      label: 'It\'s your turn! Please proceed to the counter.',
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: AppColors.statusCalled.withValues(alpha: 0.06),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? AppSpacing.lg : AppSpacing.xxxl,
              vertical: AppSpacing.xl,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pulsing icon — the amber color is the visual signal,
                // paired with text for accessibility.
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) => Transform.scale(
                    scale: _pulseAnimation.value,
                    child: child,
                  ),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      // statusCalledOn (not statusCalled) so the white icon on
                      // top clears WCAG AA contrast — see theme.dart.
                      color: AppColors.statusCalledOn,
                      shape: BoxShape.circle,
                      boxShadow: [
                        // The glow itself carries no content, so the brighter
                        // decorative amber is fine here.
                        BoxShadow(
                          color: AppColors.statusCalled.withValues(alpha: 0.4),
                          blurRadius: 32,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.notifications_active,
                      color: Colors.white,
                      size: 56,
                      semanticLabel: 'Bell ringing — your turn',
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                Text(
                  "It's your turn!",
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    // statusCalledOn, not statusCalled — see theme.dart.
                    color: AppColors.statusCalledOn,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.md),

                Text(
                  'Please proceed to the counter now.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xxl),

                // Countdown indicator — shows time since called.
                _CalledCountdown(calledAt: widget.entry.calledAt),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Shows elapsed time since the visitor was called.
class _CalledCountdown extends StatefulWidget {
  final DateTime? calledAt;
  const _CalledCountdown({required this.calledAt});

  @override
  State<_CalledCountdown> createState() => _CalledCountdownState();
}

class _CalledCountdownState extends State<_CalledCountdown> {
  late final Stream<Duration> _elapsed;

  @override
  void initState() {
    super.initState();
    _elapsed = Stream.periodic(
      const Duration(seconds: 1),
      (_) => widget.calledAt != null
          ? DateTime.now().toUtc().difference(widget.calledAt!.toUtc())
          : Duration.zero,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.calledAt == null) return const SizedBox.shrink();

    return StreamBuilder<Duration>(
      stream: _elapsed,
      initialData: Duration.zero,
      builder: (context, snapshot) {
        final elapsed = snapshot.data ?? Duration.zero;
        final minutes = elapsed.inMinutes;
        final seconds = elapsed.inSeconds % 60;
        return Text(
          'Called ${minutes > 0 ? '${minutes}m ' : ''}${seconds}s ago',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted,
          ),
          semanticsLabel:
              'You were called $minutes minutes and $seconds seconds ago',
        );
      },
    );
  }
}
