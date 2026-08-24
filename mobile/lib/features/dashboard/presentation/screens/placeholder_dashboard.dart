import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_widgets.dart';
import '../../../auth/providers/auth_provider.dart';

class PlaceholderDashboard extends ConsumerWidget {
  const PlaceholderDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.psychology_outlined, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Text(
              'CareerLens AI',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header
            GlassCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : 'C',
                      style: GoogleFonts.outfit(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back,',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                          ),
                        ),
                        Text(
                          user?.fullName ?? 'Career Candidate',
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.email ?? '',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 500.ms),

            const SizedBox(height: 20),

            // AI Interview Studio Quick Launch Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'NEW FEATURE • PHASE 9',
                          style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Icon(Icons.videocam_outlined, color: Colors.white, size: 24),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'AI Interview Studio',
                    style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Practice realistic mock interviews using your uploaded resume & target job role with speech & camera feedback.',
                    style: GoogleFonts.inter(fontSize: 12, color: Colors.white70, height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Launch AI Mock Interview'),
                    onPressed: () => context.push('/interview/setup'),
                  ),
                ],
              ),
            ).animate().scale(delay: 100.ms, duration: 400.ms),

            const SizedBox(height: 24),

            Text(
              'Career Overview',
              style: GoogleFonts.outfit(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),

            // Overview Metric Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.3,
              children: [
                _buildMetricCard(
                  context,
                  title: 'Career Readiness',
                  value: '78%',
                  icon: Icons.speed_rounded,
                  color: AppTheme.primaryColor,
                  subtitle: 'Target: Software Engineer',
                ),
                _buildMetricCard(
                  context,
                  title: 'Top Skill Gaps',
                  value: '3 Skills',
                  icon: Icons.extension_outlined,
                  color: Colors.amber.shade700,
                  subtitle: 'FastAPI, Docker, AWS',
                ),
                _buildMetricCard(
                  context,
                  title: 'Job Recommendations',
                  value: '8 Roles',
                  icon: Icons.work_outline_rounded,
                  color: AppTheme.secondaryColor,
                  subtitle: '78% - 94% Match Range',
                ),
                _buildMetricCard(
                  context,
                  title: 'Interview Readiness',
                  value: '72%',
                  icon: Icons.quiz_outlined,
                  color: AppTheme.accentColor,
                  subtitle: '2 Mock Sessions Done',
                ),
              ],
            ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required String subtitle,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                ),
              ),
              Icon(icon, color: color, size: 20),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
