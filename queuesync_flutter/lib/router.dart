import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'screens/visitor/visitor_screen.dart';
import 'screens/staff/staff_screen.dart';
import 'screens/staff/staff_login_screen.dart';
import 'theme.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const _HomeScreen(),
      ),
      GoRoute(
        path: '/q/:counterId',
        builder: (context, state) {
          final counterIdStr = state.pathParameters['counterId'] ?? '1';
          final counterId = int.tryParse(counterIdStr) ?? 1;
          return VisitorScreen(counterId: counterId);
        },
      ),
      GoRoute(
        path: '/staff',
        builder: (context, state) => const StaffScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const StaffLoginScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page not found: ${state.uri}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    ),
  );
});

/// Root landing page — demo entry point linking visitor and staff views.
class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Branding
                const Icon(
                  Icons.queue,
                  size: 64,
                  color: AppColors.primary,
                  semanticLabel: 'QueueSync logo',
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'QueueSync',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Real-time virtual queue for walk-in counters.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xxxl),

                // Visitor entry
                ElevatedButton(
                  onPressed: () => context.go('/q/1'),
                  child: const Text('Join Queue — Counter A'),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton(
                  onPressed: () => context.go('/q/2'),
                  child: const Text('Join Queue — Counter B'),
                ),

                const SizedBox(height: AppSpacing.xl),
                const Divider(),
                const SizedBox(height: AppSpacing.xl),

                // Staff entry
                TextButton(
                  onPressed: () => context.go('/staff'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                  child: const Text('Staff Dashboard →'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
