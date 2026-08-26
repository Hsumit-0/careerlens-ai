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
import '../features/jobs/presentation/screens/jobs_hub_screen.dart';
import '../features/jobs/presentation/screens/job_details_screen.dart';
import '../features/jobs/presentation/screens/job_tracker_screen.dart';
import '../features/resume/presentation/screens/ats_analysis_screen.dart';
import '../features/resume/presentation/screens/resume_upload_screen.dart';
import '../features/roadmap/presentation/screens/career_navigator_screen.dart';

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
        path: '/jobs',
        builder: (context, state) => const JobsHubScreen(),
      ),
      GoRoute(
        path: '/jobs/tracker',
        builder: (context, state) => const JobTrackerScreen(),
      ),
      GoRoute(
        path: '/jobs/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'job-google-101';
          return JobDetailsScreen(jobId: id);
        },
      ),
      GoRoute(
        path: '/resume-upload',
        builder: (context, state) => const ResumeUploadScreen(),
      ),
      GoRoute(
        path: '/ats-analysis',
        builder: (context, state) => const AtsAnalysisScreen(),
      ),
      GoRoute(
        path: '/career-navigator',
        builder: (context, state) => const CareerNavigatorScreen(),
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
      final isLoggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/splash';

      if (status == AuthStatus.unauthenticated && !isLoggingIn) {
        return '/login';
      }
      if (status == AuthStatus.authenticated && isLoggingIn) {
        return '/dashboard';
      }
      return null;
    },
  );
});
