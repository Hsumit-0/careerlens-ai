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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.psychology_outlined, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 12),
            Text(
              'CareerLens AI',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 22),
            ),
            const SizedBox(width: 10),
            const PulseDot(color: AppTheme.accentColor, size: 8),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.work_outline_rounded),
            tooltip: 'Jobs Hub & Matching',
            onPressed: () => context.push('/jobs'),
          ),
          IconButton(
            icon: const Icon(Icons.upload_file_outlined),
            tooltip: 'Upload / Manage Resumes',
            onPressed: () => context.push('/resume-upload'),
          ),
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'ATS Resume Analysis',
            onPressed: () => context.push('/ats-analysis'),
          ),
          IconButton(
            icon: const Icon(Icons.alt_route_outlined),
            tooltip: 'AI Career Navigator',
            onPressed: () => context.push('/career-navigator'),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Executive Welcome Card with User Avatar & Quick Upload
            GlassCard(
              child: Row(
                children: [
                  Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : 'R',
                        style: GoogleFonts.outfit(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Welcome back,',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const GradientBadge(
                              label: 'PRO AI MEMBER',
                              gradient: AppTheme.amberGradient,
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.fullName ?? 'Robert Chen',
                          style: GoogleFonts.outfit(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.upload_file_outlined, size: 18),
                    label: const Text('Upload CV'),
                    onPressed: () => context.push('/resume-upload'),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: -0.1, end: 0),

            const SizedBox(height: 20),

            // AI Interview Studio Quick Launch Card (Hero Spotlight)
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.4),
                    blurRadius: 20,
                    spreadRadius: 1,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'MULTIMODAL MOCK STUDIO',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const PulseDot(color: Colors.white, size: 8),
                        ],
                      ),
                      const Icon(Icons.videocam_rounded, color: Colors.white, size: 26),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'AI Interview Studio',
                    style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Practice realistic technical & behavioral mock interviews tailored to your target position with real-time speech and camera feedback.',
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.white.withOpacity(0.85), height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppTheme.primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.play_arrow_rounded, size: 20),
                        label: Text(
                          'Launch AI Studio',
                          style: GoogleFonts.inter(fontWeight: FontWeight.bold),
                        ),
                        onPressed: () => context.push('/interview/setup'),
                      ),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: BorderSide(color: Colors.white.withOpacity(0.4), width: 1.5),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        icon: const Icon(Icons.assessment_outlined, size: 18),
                        label: const Text('View Last Report'),
                        onPressed: () => context.push('/interview/report'),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().scale(delay: 100.ms, duration: 400.ms),

            const SizedBox(height: 28),

            // Section Header: Executive Overview
            const SectionHeader(
              title: 'Executive Performance Index',
              subtitle: 'Real-time Career Analytics & Skill Diagnostics',
            ),
            const SizedBox(height: 14),

            // Executive Metric 4-Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.3,
              children: [
                StatCard(
                  title: 'Career Score',
                  value: '88 pts',
                  trend: '+12%',
                  icon: Icons.trending_up_rounded,
                  accentColor: AppTheme.primaryColor,
                  progress: 0.88,
                  onTap: () => context.push('/career-navigator'),
                ),
                StatCard(
                  title: 'Job Match Rate',
                  value: '94% match',
                  trend: '+18%',
                  icon: Icons.work_outline_rounded,
                  accentColor: AppTheme.secondaryColor,
                  progress: 0.94,
                  onTap: () => context.push('/jobs'),
                ),
                StatCard(
                  title: 'ATS Readiness',
                  value: '82/100',
                  trend: '+10%',
                  icon: Icons.description_outlined,
                  accentColor: AppTheme.accentColor,
                  progress: 0.82,
                  onTap: () => context.push('/ats-analysis'),
                ),
                StatCard(
                  title: 'Mock Confidence',
                  value: '86 pts',
                  trend: '+15%',
                  icon: Icons.mic_external_on_outlined,
                  accentColor: AppTheme.warningColor,
                  progress: 0.86,
                  onTap: () => context.push('/interview/setup'),
                ),
              ],
            ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

            const SizedBox(height: 28),

            // Top Recommendations & Application Trends Section
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 700;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Application Trends Chart Mock
                    Expanded(
                      flex: isWide ? 1 : 0,
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Application Velocity', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                                const GradientBadge(label: 'Weekly', gradient: AppTheme.primaryGradient),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _buildBarChartColumn('Wk 1', 0.45, AppTheme.primaryColor),
                                _buildBarChartColumn('Wk 2', 0.75, AppTheme.secondaryColor),
                                _buildBarChartColumn('Wk 3', 0.60, AppTheme.amberGradient.colors.first),
                                _buildBarChartColumn('Wk 4', 0.90, AppTheme.accentColor),
                                _buildBarChartColumn('Wk 5', 0.50, AppTheme.roseGradient.colors.first),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (isWide) const SizedBox(width: 16) else const SizedBox(height: 16),

                    // Top Picks for Next Role
                    Expanded(
                      flex: isWide ? 1 : 0,
                      child: GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Top AI Job Matches', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                                TextButton(
                                  onPressed: () => context.push('/jobs'),
                                  child: Text('View All', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            _buildJobMatchItem(
                              context,
                              title: 'Senior Software Engineer',
                              company: 'Google • Mountain View',
                              match: '97% Match',
                              badgeColor: AppTheme.accentColor,
                              onTap: () => context.push('/jobs/job-google-101'),
                            ),
                            const Divider(height: 16),
                            _buildJobMatchItem(
                              context,
                              title: 'Backend Systems Architect',
                              company: 'Meta • Menlo Park',
                              match: '94% Match',
                              badgeColor: AppTheme.primaryColor,
                              onTap: () => context.push('/jobs/job-meta-202'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarChartColumn(String label, double heightRatio, Color color) {
    return Column(
      children: [
        Container(
          height: 90 * heightRatio,
          width: 18,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.grey)),
      ],
    );
  }

  Widget _buildJobMatchItem(
    BuildContext context, {
    required String title,
    required String company,
    required String match,
    required Color badgeColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.business_rounded, color: badgeColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                  Text(company, style: GoogleFonts.inter(color: Colors.grey, fontSize: 11)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: badgeColor.withOpacity(0.3)),
              ),
              child: Text(
                match,
                style: GoogleFonts.inter(color: badgeColor, fontSize: 11, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

