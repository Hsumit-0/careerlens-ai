import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/dashboard/presentation/screens/placeholder_dashboard.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const PlaceholderDashboard(),
      ),
    ],
    redirect: (context, state) {
      final status = authState.status;
      final isSplashing = state.matchedLocation == '/splash';
      final isLoggingIn = state.matchedLocation == '/login';
      final isRegistering = state.matchedLocation == '/register';

      if (status == AuthStatus.initial || status == AuthStatus.authenticating) {
        return isSplashing ? null : '/splash';
      }

      if (status == AuthStatus.authenticated) {
        if (isSplashing || isLoggingIn || isRegistering) {
          return '/dashboard';
        }
      }

      if (status == AuthStatus.unauthenticated || status == AuthStatus.error) {
        if (!isLoggingIn && !isRegistering) {
          return '/login';
        }
      }

      return null;
    },
  );
});
