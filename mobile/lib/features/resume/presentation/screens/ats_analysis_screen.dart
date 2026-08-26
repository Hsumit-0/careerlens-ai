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
          'ATS Resume Intelligence',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Re-Analyze Resume',
            onPressed: () {},
          ),
          const SizedBox(width: 8),
        ],
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
                      'Applicant Tracking System Diagnostic',
                      style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'AI parsing, keyword extraction, and compatibility report for your current target role.',
                      style: GoogleFonts.inter(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const GradientBadge(
                  label: 'ATS VERIFIED',
                  gradient: AppTheme.emeraldGradient,
                  icon: Icons.verified_user_outlined,
                ),
              ],
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: 24),

            // Top Layout: Overall Score Panel + Radial Progress Gauge Card
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
                              'Overall ATS Compatibility',
                              style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.amberGradient.colors.first.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.amberGradient.colors.first.withOpacity(0.3)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.stars_rounded, color: AppTheme.amberGradient.colors.first, size: 15),
                                  const SizedBox(width: 4),
                                  Text(
                                    '84 / 100',
                                    style: GoogleFonts.outfit(color: AppTheme.amberGradient.colors.first, fontWeight: FontWeight.bold, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your resume is optimized for enterprise ATS parsers (Taleo, Greenhouse, Workday). Follow the AI suggestions below to reach 95%+ match.',
                          style: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade700, height: 1.4),
                        ),
                        const SizedBox(height: 20),

                        // Sub-Score Metric Blocks
                        Row(
                          children: [
                            _buildSubScoreBlock(context, '88', 'Format Score', 'Structure & Fonts', AppTheme.primaryColor),
                            const SizedBox(width: 10),
                            _buildSubScoreBlock(context, '82', 'Keywords', 'Domain Terms', AppTheme.secondaryColor),
                            const SizedBox(width: 10),
                            _buildSubScoreBlock(context, '85', 'Impact Metrics', 'Action Verbs', AppTheme.accentColor),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // Radial Score Gauge Indicator Right Panel
                Expanded(
                  flex: 2,
                  child: GlassCard(
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 110,
                              height: 110,
                              child: CircularProgressIndicator(
                                value: 0.84,
                                strokeWidth: 11,
                                backgroundColor: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.withOpacity(0.15),
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '84%',
                                  style: GoogleFonts.outfit(fontSize: 30, fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'MATCH SCORE',
                                  style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle_rounded, color: AppTheme.accentColor, size: 16),
                            const SizedBox(width: 6),
                            Text(
                              'High Compliance',
                              style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildProgressBar('Technical Keyword Match', 0.85, AppTheme.accentColor),
                        _buildProgressBar('Parsing & Font Hygiene', 0.90, AppTheme.primaryColor),
                        _buildProgressBar('Quantitative Impact Verbs', 0.76, AppTheme.warningColor),
                      ],
                    ),
                  ),
                ),
              ],
            ).animate().fadeIn(delay: 150.ms, duration: 400.ms),

            const SizedBox(height: 24),

            // Detailed Analysis & AST JSON Section
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
                            const Icon(Icons.psychology_outlined, color: AppTheme.primaryColor, size: 22),
                            const SizedBox(width: 8),
                            Text('AI Diagnostic Feedback', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
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
                                      const Icon(Icons.check_circle_outline_rounded, color: AppTheme.accentColor, size: 18),
                                      const SizedBox(width: 6),
                                      Text('Key Strengths', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.accentColor)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '• Clean single-column layout passes ATS text extractors smoothly.\n• Strong representation of Core Python, System Architecture, & API Design.',
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
                                      const Icon(Icons.warning_amber_rounded, color: AppTheme.warningColor, size: 18),
                                      const SizedBox(width: 6),
                                      Text('Recommended Fixes', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13, color: AppTheme.warningColor)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '• Missing target keywords: Kubernetes, Docker, Distributed Caching.\n• Convert project descriptions to include percentage results (e.g. "+35% latency drop").',
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
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0D1117),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.code_rounded, color: Colors.cyanAccent, size: 18),
                            const SizedBox(width: 6),
                            Text('Parsed AST Metadata', style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '{\n  "atsCompliance": true,\n  "extractedSkills": [\n    "Python", "FastAPI", "PostgreSQL",\n    "Redis", "Microservices"\n  ],\n  "readabilityScore": 92.4,\n  "quantifiedImpactCount": 5\n}',
                          style: GoogleFonts.firaCode(color: Colors.cyanAccent, fontSize: 11, height: 1.45),
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
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(score, style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(title, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
            Text(subtitle, style: GoogleFonts.inter(fontSize: 10, color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(String label, double val, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: val,
              minHeight: 5,
              backgroundColor: Colors.grey.withOpacity(0.15),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

