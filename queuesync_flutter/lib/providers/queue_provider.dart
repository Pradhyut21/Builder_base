import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:queuesync_client/queuesync_client.dart';
import 'client_provider.dart';

/// Holds the visitor's own entry after they join the queue.
/// null = not yet joined.
final visitorEntryProvider = StateProvider<QueueEntry?>((ref) => null);

/// Holds the visitor's ownership token (returned at join time).
/// Required to call leaveQueue.
final ownerTokenProvider = StateProvider<String?>((ref) => null);

/// Live queue stream for the visitor view — real-time via Serverpod streams.
/// Provides the redacted queue list (no phone numbers, name redacted).
final visitorQueueStreamProvider = StreamProvider.family<List<QueueEntry>, int>(
  (ref, counterId) {
    final client = ref.watch(clientProvider);
    return client.queue.watchQueue(counterId);
  },
);

/// Live full queue stream for staff — includes phone numbers and full names.
final staffQueueStreamProvider = StreamProvider.family<List<QueueEntry>, int>(
  (ref, counterId) {
    final client = ref.watch(clientProvider);
    return client.staff.watchStaffQueue(counterId);
  },
);

/// Whether the app is currently attempting to reconnect after a stream drop.
final streamReconnectingProvider = StateProvider<bool>((ref) => false);
