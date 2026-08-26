import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_widgets.dart';

class AtsAnalysisScreen extends StatelessWidget {
  const AtsAnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ATS Score Analysis',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ATS Score Analysis',
                      style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Detailed analysis of how well your resume performs with Applicant Tracking Systems.',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Text(
                    'Good',
                    style: GoogleFonts.inter(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: 24),

            // Top Layout: Overall Card + Circular Indicator Card
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall ATS Score Left Panel
                Expanded(
                  flex: 3,
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Overall ATS Score',
                              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.amber.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    '74/100',
                                    style: GoogleFonts.outfit(color: Colors.amber.shade800, fontWeight: FontWeight.bold, fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Overall, your resume is a good start. Follow the suggestions to improve the ATS match.',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 20),

                        // 3 Score Breakdown Blocks
                        Row(
                          children: [
                            _buildSubScoreBlock(context, '62', 'Format Score', 'Structure & Layout', Colors.indigo),
                            const SizedBox(width: 10),
                            _buildSubScoreBlock(context, '68', 'Keywords', 'Industry Terms', Colors.green),
                            const SizedBox(width: 10),
                            _buildSubScoreBlock(context, '65', 'Content Quality', 'Relevance & Impact', Colors.purple),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Circular Score Indicator Right Panel
                Expanded(
                  flex: 2,
                  child: GlassCard(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                value: 0.74,
                                strokeWidth: 10,
                                backgroundColor: Colors.grey.withOpacity(0.2),
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '74',
                                  style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '/ 100',
                                  style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'Good Progress',
                              style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'A few improvements will boost your score significantly.',
                          style: GoogleFonts.inter(fontSize: 10, color: Colors.grey),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        _buildProgressBar('Keywords', 0.79, Colors.orange),
                        _buildProgressBar('Format', 0.64, Colors.orange),
                        _buildProgressBar('Structure', 0.74, Colors.orange),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            const SizedBox(height: 24),

            // Detailed Analysis & Code AST Section
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Strengths & Improvements
                Expanded(
                  flex: 3,
                  child: GlassCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.psychology_outlined, color: AppTheme.primaryColor, size: 20),
                            const SizedBox(width: 8),
                            Text('Detailed Analysis', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                                      const SizedBox(width: 6),
                                      Text('Strengths', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.green)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '• Clean, readable format that ATS systems can parse effectively.\n• High correlation in Backend & Python core skills.',
                                    style: GoogleFonts.inter(fontSize: 12, height: 1.5, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.warning_amber_rounded, color: Colors.amber.shade800, size: 16),
                                      const SizedBox(width: 6),
                                      Text('Areas for Improvement', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.amber.shade800)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '• Add more industry-specific keywords (Docker, Kubernetes, AWS).\n• Include quantified outcome metrics in project descriptions.',
                                    style: GoogleFonts.inter(fontSize: 12, height: 1.5, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // AST JSON Analysis Details Viewer
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1117),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade800),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.code_rounded, color: Colors.cyanAccent, size: 16),
                            const SizedBox(width: 6),
                            Text('Analysis Details (AST)', style: GoogleFonts.inter(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '{\n  "skills": {\n    "count": 3,\n    "skillScore": 9,\n    "parsed": ["Python", "FastAPI"]\n  },\n  "atsCompliance": true\n}',
                          style: GoogleFonts.firaCode(color: Colors.cyanAccent, fontSize: 11, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildSubScoreBlock(BuildContext context, String score, String title, String subtitle, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(score, style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(title, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold)),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, double val, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
              Text('${(val * 100).toInt()}%', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: val,
            backgroundColor: Colors.grey.withOpacity(0.2),
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
