import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'theme.dart';
import 'router.dart';

/// QueueSync — Real-time virtual queue management.
///
/// Entry point: initializes Riverpod (provider scope) and go_router.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: QueueSyncApp(),
    ),
  );
}

class QueueSyncApp extends ConsumerWidget {
  const QueueSyncApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'QueueSync — Live Virtual Queue',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: router,
    );
  }
}
