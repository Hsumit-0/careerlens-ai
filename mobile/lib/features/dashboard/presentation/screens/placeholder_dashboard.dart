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
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Header Banner
            GlassCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppTheme.primaryColor,
                    child: Text(
                      user?.fullName.isNotEmpty == true ? user!.fullName[0].toUpperCase() : 'R',
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
                          user?.fullName ?? 'Robert!',
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
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    ),
                    icon: const Icon(Icons.upload_file_outlined, size: 18),
                    label: const Text('Upload Resume'),
                    onPressed: () => context.push('/resume-upload'),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 18),

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
                          'MULTIMODAL MOCK STUDIO',
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

            // Executive Metric 4-Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.35,
              children: [
                _buildExecutiveMetricCard(
                  context,
                  title: 'Career Score',
                  value: '85 points',
                  trend: '+12%',
                  icon: Icons.trending_up_rounded,
                  color: AppTheme.primaryColor,
                ),
                _buildExecutiveMetricCard(
                  context,
                  title: 'Skills Growth',
                  value: '12 new skills',
                  trend: '+15%',
                  icon: Icons.extension_outlined,
                  color: AppTheme.secondaryColor,
                ),
                _buildExecutiveMetricCard(
                  context,
                  title: 'LinkedIn Health',
                  value: '82 points',
                  trend: '-8%',
                  icon: Icons.share_rounded,
                  color: Colors.amber.shade700,
                ),
                _buildExecutiveMetricCard(
                  context,
                  title: 'CV Score',
                  value: '75 points',
                  trend: '+10%',
                  icon: Icons.description_outlined,
                  color: AppTheme.accentColor,
                  onTap: () => context.push('/ats-analysis'),
                ),
              ],
            ).animate().fadeIn(delay: 200.ms, duration: 500.ms),

            const SizedBox(height: 24),

            // Top Recommendations & Career Goals Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Application Trends Chart Mock
                Expanded(
                  flex: 3,
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Application Trends', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _buildBarChartColumn('1-4', 0.5, Colors.blue),
                            _buildBarChartColumn('5-8', 0.8, Colors.green),
                            _buildBarChartColumn('9-12', 0.6, Colors.amber),
                            _buildBarChartColumn('13-16', 0.9, Colors.indigo),
                            _buildBarChartColumn('17-20', 0.4, Colors.purple),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Top Picks for Next Role
                Expanded(
                  flex: 3,
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Top Job Matches', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                            Text('97% Match', style: GoogleFonts.inter(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        _buildJobMatchItem('Senior Software Engineer', 'Google • Mountain View', '97% Match'),
                        const Divider(),
                        _buildJobMatchItem('Backend Engineer', 'Verizon • Full-time', '94% Match'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExecutiveMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required String trend,
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey)),
                Icon(icon, color: color, size: 18),
              ],
            ),
            Text(value, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Row(
              children: [
                Text(trend, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: trend.contains('+') ? Colors.green : Colors.redAccent)),
                const SizedBox(width: 6),
                Text('vs last 30 days', style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
              ],
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
          height: 80 * heightRatio,
          width: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildJobMatchItem(String title, String company, String match) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
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
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(match, style: GoogleFonts.inter(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
