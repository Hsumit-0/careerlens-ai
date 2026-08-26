import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_widgets.dart';

class CareerNavigatorScreen extends StatelessWidget {
  const CareerNavigatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080C14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF080C14),
        title: Text(
          'AI Career Navigator',
          style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section Layout
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;
                return Flex(
                  direction: isWide ? Axis.horizontal : Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Resume Analysis & Identified Skills
                    Expanded(
                      flex: isWide ? 3 : 0,
                      child: GlassCard(
                        borderColor: AppTheme.primaryColor.withOpacity(0.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Resume & Skill Diagnostics', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                const PulseDot(color: AppTheme.accentColor, size: 8),
                              ],
                            ),
                            const SizedBox(height: 14),
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.04),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.white.withOpacity(0.1)),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.purple.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(Icons.picture_as_pdf_outlined, color: Colors.purpleAccent, size: 24),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('Active Resume PDF', style: GoogleFonts.inter(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                      Text('Parsed 18 skills • ATS 84%', style: GoogleFonts.inter(color: Colors.grey, fontSize: 11)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text('Identified Skills Matrix:', style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 12)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildSkillChip('Python (90%)', AppTheme.primaryColor),
                                _buildSkillChip('System Design (85%)', AppTheme.secondaryColor),
                                _buildSkillChip('FastAPI & REST (88%)', AppTheme.accentColor),
                                _buildSkillChip('PostgreSQL & Redis', Colors.purpleAccent),
                                _buildSkillChip('Docker & CI/CD', Colors.amber),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (isWide) const SizedBox(width: 16) else const SizedBox(height: 16),

                    // 2. Personalized Roadmap Flow Diagram
                    Expanded(
                      flex: isWide ? 5 : 0,
                      child: GlassCard(
                        borderColor: AppTheme.secondaryColor.withOpacity(0.3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Personalized Career Roadmap', style: GoogleFonts.inter(color: Colors.grey, fontSize: 12)),
                            Text('Journey to Staff Systems Architect', style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 20),

                            // Interactive Flow Diagram Nodes
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  _buildFlowNode('Current Skills', Icons.person_outline, AppTheme.primaryColor),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(Icons.arrow_forward_rounded, color: Colors.cyanAccent, size: 18),
                                  ),
                                  _buildFlowNode('Gap Analysis', Icons.tune_rounded, AppTheme.warningColor),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(Icons.arrow_forward_rounded, color: Colors.cyanAccent, size: 18),
                                  ),
                                  _buildFlowNode('Learning Path', Icons.school_outlined, Colors.purpleAccent),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Icon(Icons.arrow_forward_rounded, color: Colors.cyanAccent, size: 18),
                                  ),
                                  _buildFlowNode('Target Role', Icons.emoji_events_outlined, AppTheme.accentColor),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 28),

            // Bottom Section: LangChain Processing Pipeline Diagram (Footer)
            GlassCard(
              borderColor: AppTheme.primaryColor.withOpacity(0.3),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Agentic Graph Processing Pipeline', style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                      const GradientBadge(label: 'LANGGRAPH AI', gradient: AppTheme.primaryGradient),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildPipelineStep('1. Resume Ingestion', Icons.description_outlined),
                        _buildPipelineArrow(),
                        _buildPipelineStep('2. Skill Parsing (OCR)', Icons.crop_free_outlined),
                        _buildPipelineArrow(),
                        _buildPipelineStep('3. Knowledge Graph Search', Icons.account_tree_outlined),
                        _buildPipelineArrow(),
                        _buildPipelineStep('4. Career Path Generation', Icons.alt_route_outlined),
                        _buildPipelineArrow(),
                        _buildPipelineStep('5. Match & Scoring Engine', Icons.recommend_outlined),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFlowNode(String title, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPipelineStep(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 18),
          const SizedBox(width: 8),
          Text(label, style: GoogleFonts.inter(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPipelineArrow() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      child: Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
    );
  }
}
