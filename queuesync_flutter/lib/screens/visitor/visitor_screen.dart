import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:queuesync_client/queuesync_client.dart';
import '../../theme.dart';
import '../../providers/client_provider.dart';
import '../../providers/queue_provider.dart';
import 'widgets/join_form.dart';
import 'widgets/waiting_view.dart';
import 'widgets/called_view.dart';
import 'widgets/terminal_view.dart';
import 'widgets/reconnecting_banner.dart';

/// SCREEN 1 — VISITOR VIEW (/q/:counterId)
///
/// No login, no navigation chrome, no hamburger menu.
/// This is opened from a QR code on someone's phone while standing
/// in a waiting room — every unnecessary element is a design failure here.
///
/// States designed (not just "handled"):
///   1. Not yet joined   — name/phone input + Join Queue button
///   2. Waiting          — hero position number + Leave queue action
///   3. Called           — visually distinct "you're next" state
///   4. Expired/Left     — clear message + Rejoin action
///   5. Connection lost  — explicit reconnecting indicator
class VisitorScreen extends ConsumerStatefulWidget {
  final int counterId;

  const VisitorScreen({super.key, required this.counterId});

  @override
  ConsumerState<VisitorScreen> createState() => _VisitorScreenState();
}

class _VisitorScreenState extends ConsumerState<VisitorScreen> {
  bool _isJoining = false;
  String? _errorMessage;

  Future<void> _joinQueue(String name, String? phone) async {
    setState(() {
      _isJoining = true;
      _errorMessage = null;
    });

    try {
      final client = ref.read(clientProvider);
      final entry = await client.queue.joinQueue(
        widget.counterId,
        name,
        phone,
      );
      ref.read(visitorEntryProvider.notifier).state = entry;
      ref.read(ownerTokenProvider.notifier).state = entry.ownerToken;
    } on CounterPausedException catch (e) {
      setState(() => _errorMessage = e.message);
    } on ValidationException catch (e) {
      setState(() => _errorMessage = e.message);
    } catch (e) {
      setState(() => _errorMessage = 'Something went wrong. Please try again.');
    } finally {
      setState(() => _isJoining = false);
    }
  }

  Future<void> _leaveQueue() async {
    final entry = ref.read(visitorEntryProvider);
    final token = ref.read(ownerTokenProvider);
    if (entry == null || token == null) return;

    try {
      final client = ref.read(clientProvider);
      await client.queue.leaveQueue(entry.id!, token);
      ref.read(visitorEntryProvider.notifier).state = null;
      ref.read(ownerTokenProvider.notifier).state = null;
    } catch (e) {
      // Silently handle — the user is already leaving.
    }
  }

  @override
  Widget build(BuildContext context) {
    final entry = ref.watch(visitorEntryProvider);
    final queueStream = ref.watch(
      visitorQueueStreamProvider(widget.counterId),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: queueStream.when(
          data: (queue) {
            // Update the visitor's own entry from the live queue data.
            final myEntry = entry != null
                ? queue.firstWhere(
                    (e) => e.id == entry.id,
                    orElse: () => entry,
                  )
                : null;

            return _buildBody(myEntry, queue);
          },
          loading: () => _buildBody(entry, const []),
          error: (error, stack) {
            // Connection lost — show reconnecting indicator.
            return Column(
              children: [
                const ReconnectingBanner(),
                Expanded(child: _buildBody(entry, const [])),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildBody(QueueEntry? entry, List<QueueEntry> queue) {
    // Determine which state to show.
    if (entry == null) {
      return JoinForm(
        counterId: widget.counterId,
        isJoining: _isJoining,
        errorMessage: _errorMessage,
        onJoin: _joinQueue,
      );
    }

    switch (entry.status) {
      case QueueEntryStatus.waiting:
        return WaitingView(
          entry: entry,
          queue: queue,
          onLeave: _leaveQueue,
        );
      case QueueEntryStatus.called:
        return CalledView(entry: entry);
      case QueueEntryStatus.served:
        return const TerminalView(
          icon: Icons.check_circle_outline,
          iconColor: AppColors.statusServed,
          title: 'All done!',
          subtitle: 'Thank you for visiting.',
          showRejoin: false,
        );
      case QueueEntryStatus.expired:
      case QueueEntryStatus.left:
        return TerminalView(
          icon: Icons.timer_off_outlined,
          iconColor: AppColors.statusExpired,
          title: entry.status == QueueEntryStatus.left
              ? 'You left the queue'
              : 'Your spot expired',
          subtitle: entry.status == QueueEntryStatus.left
              ? 'You can rejoin at any time.'
              : "You weren't available when called. No worries — rejoin anytime.",
          showRejoin: true,
          onRejoin: () {
            ref.read(visitorEntryProvider.notifier).state = null;
            ref.read(ownerTokenProvider.notifier).state = null;
          },
        );
    }
  }
}
