import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/dashboard/presentation/screens/placeholder_dashboard.dart';
import '../features/interview/presentation/screens/interview_setup_screen.dart';
import '../features/interview/presentation/screens/interview_studio_screen.dart';
import '../features/interview/presentation/screens/interview_report_screen.dart';

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
      GoRoute(
        path: '/interview/setup',
        builder: (context, state) => const InterviewSetupScreen(),
      ),
      GoRoute(
        path: '/interview/studio',
        builder: (context, state) => const InterviewStudioScreen(),
      ),
      GoRoute(
        path: '/interview/report',
        builder: (context, state) => const InterviewReportScreen(),
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
