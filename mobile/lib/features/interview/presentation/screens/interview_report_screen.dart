import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_widgets.dart';
import '../../providers/interview_provider.dart';

class InterviewReportScreen extends ConsumerWidget {
  const InterviewReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(interviewNotifierProvider);
    final report = state.finalReport;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (report == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Interview Report')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Post-Interview Analysis',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_rounded),
            onPressed: () => context.go('/dashboard'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Score Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 90,
                        height: 90,
                        child: CircularProgressIndicator(
                          value: report.overallScore / 100.0,
                          strokeWidth: 8,
                          backgroundColor: Colors.white24,
                          color: Colors.white,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${report.overallScore.toInt()}',
                            style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text(
                            '/ 100',
                            style: GoogleFonts.inter(fontSize: 10, color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Overall Mock Score',
                          style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
                        ),
                        Text(
                          'Target: ${report.targetRole}',
                          style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'FAANG Rubric Evaluated',
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().scale(duration: 400.ms),

            const SizedBox(height: 24),

            // Performance Breakdown Grid
            Text('Performance Metrics', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 14),

            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 1.25,
              children: [
                _buildScoreTile(
                  context,
                  title: 'Technical Knowledge',
                  score: report.technicalScore,
                  icon: Icons.code_rounded,
                  color: AppTheme.primaryColor,
                ),
                _buildScoreTile(
                  context,
                  title: 'Answer Quality',
                  score: report.answerQualityScore,
                  icon: Icons.fact_check_outlined,
                  color: AppTheme.secondaryColor,
                ),
                _buildScoreTile(
                  context,
                  title: 'Communication',
                  score: report.communicationScore,
                  icon: Icons.record_voice_over_outlined,
                  color: AppTheme.accentColor,
                ),
                _buildScoreTile(
                  context,
                  title: 'Observed Confidence',
                  score: report.observedConfidenceIndicator,
                  icon: Icons.psychology_outlined,
                  color: Colors.amber.shade700,
                ),
              ],
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 20),

            // Speech pattern breakdown
            GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text('Speaking Pace', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text('${report.speakingPaceWpm.toInt()} WPM', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                      Text('Optimal (120-160)', style: GoogleFonts.inter(fontSize: 10, color: Colors.green)),
                    ],
                  ),
                  Container(height: 35, width: 1, color: Colors.grey.withOpacity(0.3)),
                  Column(
                    children: [
                      Text('Filler Words', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                      const SizedBox(height: 4),
                      Text('${report.fillerWordCount}', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: report.fillerWordCount > 3 ? Colors.amber : Colors.green)),
                      Text(report.fillerWordCount > 3 ? 'Needs Control' : 'Excellent', style: GoogleFonts.inter(fontSize: 10, color: report.fillerWordCount > 3 ? Colors.amber : Colors.green)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Strengths
            Text('Strengths', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...report.strengths.map((s) => _buildBullet(s, Icons.check_circle_rounded, Colors.green)).toList(),

            const SizedBox(height: 20),

            // Areas for Improvement
            Text('Areas for Improvement', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...report.improvements.map((imp) => _buildBullet(imp, Icons.warning_amber_rounded, Colors.amber.shade800)).toList(),

            const SizedBox(height: 20),

            // Recommended Daily Practice
            Text('Recommended Practice', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            ...report.recommendations.map((rec) => _buildBullet(rec, Icons.star_outline_rounded, AppTheme.primaryColor)).toList(),

            const SizedBox(height: 24),

            // Disclaimer Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded, color: Colors.blue, size: 22),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      report.disclaimer,
                      style: GoogleFonts.inter(fontSize: 11, color: isDark ? Colors.grey.shade400 : Colors.grey.shade700, height: 1.4),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            PrimaryButton(
              text: 'Back to Career Dashboard',
              icon: Icons.dashboard_rounded,
              onPressed: () => context.go('/dashboard'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreTile(BuildContext context, {required String title, required double score, required IconData icon, required Color color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(title, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey))),
              Icon(icon, color: color, size: 18),
            ],
          ),
          Text('${score.toInt()} / 100', style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildBullet(String text, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: GoogleFonts.inter(fontSize: 13, height: 1.4))),
        ],
      ),
    );
  }
}
