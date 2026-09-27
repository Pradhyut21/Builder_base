import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:queuesync_client/queuesync_client.dart';
import 'package:queuesync_flutter/theme.dart';
import 'package:queuesync_flutter/screens/visitor/widgets/join_form.dart';
import 'package:queuesync_flutter/screens/visitor/widgets/waiting_view.dart';
import 'package:queuesync_flutter/screens/visitor/widgets/called_view.dart';
import 'package:queuesync_flutter/screens/visitor/widgets/terminal_view.dart';
import 'package:queuesync_flutter/screens/visitor/widgets/reconnecting_banner.dart';

/// Widget tests for all 5 visitor screen states.
///
/// The spec requires at minimum: test that the visitor screen renders each
/// of its five states without throwing.
void main() {
  Widget wrap(Widget child) => ProviderScope(
    child: MaterialApp(
      theme: AppTheme.light,
      home: Scaffold(body: child),
    ),
  );

  group('Visitor screen — State 1: Not yet joined (JoinForm)', () {
    testWidgets('renders without throwing', (tester) async {
      await tester.pumpWidget(
        wrap(
          JoinForm(
            counterId: 1,
            isJoining: false,
            errorMessage: null,
            onJoin: (name, phone) async {},
          ),
        ),
      );
      expect(find.text('Join Queue'), findsOneWidget);
      expect(find.text('Join the queue'), findsOneWidget);
    });

    testWidgets('shows error message when provided', (tester) async {
      await tester.pumpWidget(
        wrap(
          JoinForm(
            counterId: 1,
            isJoining: false,
            errorMessage: 'This queue is currently paused.',
            onJoin: (name, phone) async {},
          ),
        ),
      );
      expect(find.text('This queue is currently paused.'), findsOneWidget);
    });

    testWidgets('shows loading indicator when joining', (tester) async {
      await tester.pumpWidget(
        wrap(
          JoinForm(
            counterId: 1,
            isJoining: true,
            errorMessage: null,
            onJoin: (name, phone) async {},
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('Visitor screen — State 2: Waiting (WaitingView)', () {
    final mockEntry = QueueEntry(
      id: 1,
      counterId: 1,
      visitorName: 'John D.',
      phone: null,
      joinedAt: DateTime.now().toUtc(),
      status: QueueEntryStatus.waiting,
      calledAt: null,
      position: 3,
      ownerToken: 'test_token',
    );

    testWidgets('renders without throwing', (tester) async {
      await tester.pumpWidget(
        wrap(
          WaitingView(
            entry: mockEntry,
            queue: [mockEntry],
            onLeave: () {},
          ),
        ),
      );
      expect(find.text('3'), findsOneWidget); // Hero position number
      expect(find.text('Your position'), findsOneWidget);
      expect(find.text('Leave queue'), findsOneWidget);
    });

    testWidgets('shows people ahead count', (tester) async {
      await tester.pumpWidget(
        wrap(
          WaitingView(
            entry: mockEntry,
            queue: [mockEntry],
            onLeave: () {},
          ),
        ),
      );
      expect(find.text('2 people ahead of you'), findsOneWidget);
    });
  });

  group('Visitor screen — State 3: Called (CalledView)', () {
    final calledEntry = QueueEntry(
      id: 2,
      counterId: 1,
      visitorName: 'Jane S.',
      phone: null,
      joinedAt: DateTime.now().toUtc().subtract(const Duration(minutes: 5)),
      status: QueueEntryStatus.called,
      calledAt: DateTime.now().toUtc().subtract(const Duration(minutes: 1)),
      position: 0,
      ownerToken: 'test_token',
    );

    testWidgets('renders without throwing', (tester) async {
      await tester.pumpWidget(wrap(CalledView(entry: calledEntry)));
      expect(find.text("It's your turn!"), findsOneWidget);
      expect(find.text('Please proceed to the counter now.'), findsOneWidget);
    });
  });

  group('Visitor screen — State 4a: Expired (TerminalView)', () {
    testWidgets('renders expired state without throwing', (tester) async {
      await tester.pumpWidget(
        wrap(
          TerminalView(
            icon: Icons.timer_off_outlined,
            iconColor: AppColors.statusExpired,
            title: 'Your spot expired',
            subtitle:
                "You weren't available when called. No worries — rejoin anytime.",
            showRejoin: true,
            onRejoin: () {},
          ),
        ),
      );
      expect(find.text('Your spot expired'), findsOneWidget);
      expect(find.text('Rejoin Queue'), findsOneWidget);
    });
  });

  group('Visitor screen — State 4b: Left (TerminalView)', () {
    testWidgets('renders left state without throwing', (tester) async {
      await tester.pumpWidget(
        wrap(
          TerminalView(
            icon: Icons.timer_off_outlined,
            iconColor: AppColors.statusExpired,
            title: 'You left the queue',
            subtitle: 'You can rejoin at any time.',
            showRejoin: true,
            onRejoin: () {},
          ),
        ),
      );
      expect(find.text('You left the queue'), findsOneWidget);
      expect(find.text('Rejoin Queue'), findsOneWidget);
    });
  });

  group('Visitor screen — State 5: Connection lost (ReconnectingBanner)', () {
    testWidgets('renders without throwing', (tester) async {
      await tester.pumpWidget(wrap(const ReconnectingBanner()));
      expect(find.text('Reconnecting...'), findsOneWidget);
    });
  });
}
