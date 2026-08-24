import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_widgets.dart';
import '../../providers/interview_provider.dart';

class InterviewSetupScreen extends ConsumerStatefulWidget {
  const InterviewSetupScreen({super.key});

  @override
  ConsumerState<InterviewSetupScreen> createState() => _InterviewSetupScreenState();
}

class _InterviewSetupScreenState extends ConsumerState<InterviewSetupScreen> {
  final _roleController = TextEditingController(text: 'Backend Developer');
  String _selectedMode = 'full_mock';
  String _selectedDifficulty = 'intermediate';

  final List<Map<String, String>> _modes = [
    {
      'id': 'quick_practice',
      'title': '⚡ Quick Practice',
      'desc': '3 quick questions (~5 mins) with instant feedback.',
    },
    {
      'id': 'technical',
      'title': '💻 Technical Interview',
      'desc': 'Architecture, databases, system design & coding concepts.',
    },
    {
      'id': 'behavioral',
      'title': '🗣️ HR & Behavioral',
      'desc': 'STAR method questions on teamwork, conflict & leadership.',
    },
    {
      'id': 'resume_based',
      'title': '📄 Resume-Based',
      'desc': 'Questions generated directly from your uploaded projects.',
    },
    {
      'id': 'full_mock',
      'title': '🎯 Full Mock Session',
      'desc': 'Comprehensive end-to-end multi-round AI interview.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(interviewNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Interview Studio',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            GlassCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.videocam_outlined, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personalized Mock Studio',
                          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'AI-generated questions based on your resume & target job role.',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 24),

            // Target Role
            Text('Target Job Role', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _roleController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.work_outline_rounded),
                hintText: 'e.g. Backend Developer, Data Scientist',
              ),
            ),

            const SizedBox(height: 24),

            // Interview Modes
            Text('Select Interview Mode', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._modes.map((mode) {
              final isSelected = _selectedMode == mode['id'];
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => setState(() => _selectedMode = mode['id']!),
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.primaryColor.withOpacity(0.12)
                          : (isDark ? const Color(0xFF1E293B) : Colors.white),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected ? AppTheme.primaryColor : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mode['title']!,
                                style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                mode['desc']!,
                                style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded, color: AppTheme.primaryColor, size: 22),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 20),

            // Hardware Toggles
            GlassCard(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('Enable Camera Preview', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Allows visual engagement feedback (strictly optional & private)', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                    value: state.cameraEnabled,
                    onChanged: (_) => ref.read(interviewNotifierProvider.notifier).toggleCamera(),
                    activeColor: AppTheme.primaryColor,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text('Enable Microphone Answer', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Enables speech-to-text transcript & filler word analysis', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                    value: state.micEnabled,
                    onChanged: (_) => ref.read(interviewNotifierProvider.notifier).toggleMic(),
                    activeColor: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Start Button
            PrimaryGradientButton(
              text: 'Start AI Mock Interview',
              icon: Icons.play_arrow_rounded,
              isLoading: state.isLoading,
              onPressed: () async {
                await ref.read(interviewNotifierProvider.notifier).startSession(
                      targetRole: _roleController.text.trim(),
                      interviewType: _selectedMode,
                      difficulty: _selectedDifficulty,
                    );
                if (mounted) {
                  context.push('/interview/studio');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
