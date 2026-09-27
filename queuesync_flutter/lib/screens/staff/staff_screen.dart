import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:queuesync_client/queuesync_client.dart';
import '../../theme.dart';
import '../../providers/client_provider.dart';
import '../../providers/queue_provider.dart';

/// SCREEN 2 — STAFF DASHBOARD (/staff)
///
/// Live queue list ordered by position, with:
/// - One unmistakable primary action: "Call Next" (large, single button)
/// - Pause/resume as a clearly labeled toggle (not an icon)
/// - Mark served / no-show only on the currently-called entry
/// - Authenticated via Serverpod auth — redirects to login if not authed
class StaffScreen extends ConsumerStatefulWidget {
  const StaffScreen({super.key});

  @override
  ConsumerState<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends ConsumerState<StaffScreen> {
  // For demo: hardcoded to counter 1. In a real deploy, this comes from the
  // authenticated staff user's counterId.
  static const _counterId = 1;

  // isPaused is server-sourced, not optimistic local state.
  // Fetched on mount and after every toggle so two open browser tabs stay in sync.
  bool _isPaused = false;
  bool _isPauseLoading = true;
  bool _isCallingNext = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPauseState();
  }

  /// Fetches the current isPaused state from the server.
  /// Called on mount and after every pause/resume toggle.
  Future<void> _loadPauseState() async {
    try {
      final client = ref.read(clientProvider);
      final counter = await client.staff.getCounterStatus(_counterId);
      if (mounted) {
        setState(() {
          _isPaused = counter?.isPaused ?? false;
          _isPauseLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isPauseLoading = false);
    }
  }

  Future<void> _callNext() async {
    setState(() {
      _isCallingNext = true;
      _error = null;
    });
    try {
      final client = ref.read(clientProvider);
      await client.staff.callNext(_counterId);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isCallingNext = false);
    }
  }

  Future<void> _togglePause() async {
    try {
      final client = ref.read(clientProvider);
      if (_isPaused) {
        await client.staff.resumeCounter(_counterId);
      } else {
        await client.staff.pauseCounter(_counterId);
      }
      // Re-fetch server state after toggle — don't optimistically flip locally.
      await _loadPauseState();
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _markServed(int entryId) async {
    try {
      final client = ref.read(clientProvider);
      await client.staff.markServed(entryId);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _markNoShow(int entryId) async {
    try {
      final client = ref.read(clientProvider);
      await client.staff.markNoShow(entryId);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final queueStream = ref.watch(staffQueueStreamProvider(_counterId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Staff Dashboard',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        actions: [
          // Pause/resume — clearly labeled toggle, not an icon requiring tooltip.
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: _isPauseLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : TextButton.icon(
                    onPressed: _togglePause,
                    icon: Icon(
                      _isPaused ? Icons.play_arrow : Icons.pause,
                      color: Colors.white,
                      semanticLabel: _isPaused ? 'Resume queue' : 'Pause queue',
                    ),
                    label: Text(
                      _isPaused ? 'Resume Queue' : 'Pause Queue',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_isPaused)
            Container(
              width: double.infinity,
              color: AppColors.statusExpired.withValues(alpha: 0.12),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.pause_circle_outline,
                    color: AppColors.statusExpired,
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Queue is paused — new visitors cannot join',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.statusExpired,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

          if (_error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              color: AppColors.error.withValues(alpha: 0.08),
              child: Text(
                _error!,
                style: TextStyle(color: AppColors.error),
              ),
            ),

          // Primary action — "Call Next" — large, prominent, unmistakable.
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: SizedBox(
              width: double.infinity,
              height: 64,
              child: ElevatedButton.icon(
                onPressed: _isCallingNext ? null : _callNext,
                icon: _isCallingNext
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.campaign_outlined, size: 28),
                label: Text(
                  _isCallingNext ? 'Calling...' : 'Call Next',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ),

          const Divider(height: 1),

          // Live queue list.
          Expanded(
            child: queueStream.when(
              data: (entries) => entries.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64,
                            color: AppColors.textMuted,
                          ),
                          SizedBox(height: AppSpacing.md),
                          Text(
                            'Queue is empty',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      itemCount: entries.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final entry = entries[index];
                        return _QueueEntryCard(
                          entry: entry,
                          onMarkServed: entry.status == QueueEntryStatus.called
                              ? () => _markServed(entry.id!)
                              : null,
                          onMarkNoShow: entry.status == QueueEntryStatus.called
                              ? () => _markNoShow(entry.id!)
                              : null,
                        );
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 56,
                        color: AppColors.textMuted,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Staff Authentication Required',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Sign in to manage Counter A queue entries.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ElevatedButton.icon(
                        onPressed: () => context.go('/login'),
                        icon: const Icon(Icons.login),
                        label: const Text('Sign in to Staff Portal'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single queue entry row in the staff dashboard.
class _QueueEntryCard extends StatelessWidget {
  final QueueEntry entry;
  final VoidCallback? onMarkServed;
  final VoidCallback? onMarkNoShow;

  const _QueueEntryCard({
    required this.entry,
    required this.onMarkServed,
    required this.onMarkNoShow,
  });

  @override
  Widget build(BuildContext context) {
    final isCalled = entry.status == QueueEntryStatus.called;
    final waitMinutes = DateTime.now()
        .toUtc()
        .difference(entry.joinedAt.toUtc())
        .inMinutes;

    return Card(
      color: isCalled
          ? AppColors.statusCalled.withValues(alpha: 0.06)
          : AppColors.surfaceCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          // statusCalledOn, not statusCalled — the bright amber border
          // measures ~2:1 against this card's light tint, under the 3:1
          // WCAG minimum for non-text UI components. See theme.dart.
          color: isCalled ? AppColors.statusCalledOn : AppColors.border,
          width: isCalled ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            // Position badge.
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                // statusCalledOn (not statusCalled) so the white glyph on
                // top clears WCAG AA contrast — see theme.dart.
                color: isCalled
                    ? AppColors.statusCalledOn
                    : AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  isCalled ? '→' : '${entry.position}',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: isCalled ? Colors.white : AppColors.primary,
                    fontSize: isCalled ? 20 : 16,
                  ),
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.md),

            // Name + wait time.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.visitorName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: isCalled ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      // Status label + icon — color never alone.
                      _StatusTag(status: entry.status),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        '${waitMinutes}m wait',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      if (entry.phone != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        Icon(
                          Icons.phone,
                          size: 12,
                          color: AppColors.textMuted,
                          semanticLabel: 'Phone: ${entry.phone}',
                        ),
                        const SizedBox(width: 2),
                        Text(
                          entry.phone!,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // Mark served / no-show — only shown on called entry.
            if (isCalled) ...[
              const SizedBox(width: AppSpacing.sm),
              Column(
                children: [
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: onMarkServed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.statusServed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      child: const Text('Served'),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    height: 36,
                    child: OutlinedButton(
                      onPressed: onMarkNoShow,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.statusExpired,
                        side: const BorderSide(color: AppColors.statusExpired),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                        ),
                        textStyle: const TextStyle(fontSize: 13),
                      ),
                      child: const Text('No-show'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusTag extends StatelessWidget {
  final QueueEntryStatus status;
  const _StatusTag({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color, icon) = switch (status) {
      QueueEntryStatus.waiting => (
        'Waiting',
        AppColors.statusWaiting,
        Icons.schedule,
      ),
      QueueEntryStatus.called => (
        'Called',
        // statusCalledOn, not statusCalled — this color renders directly as
        // small icon/text on a light background, where the bright amber
        // fails WCAG AA contrast (~2:1). See theme.dart.
        AppColors.statusCalledOn,
        Icons.campaign_outlined,
      ),
      QueueEntryStatus.served => (
        'Served',
        AppColors.statusServed,
        Icons.check_circle_outline,
      ),
      QueueEntryStatus.expired => (
        'Expired',
        AppColors.statusExpired,
        Icons.timer_off_outlined,
      ),
      QueueEntryStatus.left => (
        'Left',
        AppColors.statusLeft,
        Icons.exit_to_app_outlined,
      ),
    };

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color, semanticLabel: label),
        const SizedBox(width: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
