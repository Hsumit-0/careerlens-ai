import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_widgets.dart';
import '../../../../core/widgets/camera_permission_modal.dart';
import '../../providers/interview_provider.dart';

class InterviewSetupScreen extends ConsumerStatefulWidget {
  const InterviewSetupScreen({super.key});

  @override
  ConsumerState<InterviewSetupScreen> createState() => _InterviewSetupScreenState();
}

class _InterviewSetupScreenState extends ConsumerState<InterviewSetupScreen> {
  final _roleController = TextEditingController(text: 'Backend Developer');
  String _selectedMode = 'full_mock';
  final String _selectedDifficulty = 'intermediate';

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
          'AI Interview Studio Setup',
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
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.videocam_outlined, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Personalized AI Studio',
                          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Simulate real interview environments with real-time speech analytics & instant AI scoring.',
                          style: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 24),

            // Target Role
            Text('Target Position / Job Title', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: _roleController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.work_outline_rounded, color: AppTheme.primaryColor),
                hintText: 'e.g. Senior Backend Developer, Machine Learning Engineer',
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
                child: GlassCard(
                  onTap: () => setState(() => _selectedMode = mode['id']!),
                  borderColor: isSelected ? AppTheme.primaryColor : null,
                  backgroundGradient: isSelected ? AppTheme.ambientGlowGradient : null,
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mode['title']!,
                              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              mode['desc']!,
                              style: GoogleFonts.inter(fontSize: 12, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 16),
                        ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 20),

            // Hardware Toggles with Explicit Permission Dialog Trigger
            GlassCard(
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text('Enable Camera Stream', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Allows visual posture feedback (100% private, processed client-side)', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                    value: state.cameraEnabled,
                    onChanged: (val) {
                      if (val) {
                        CameraPermissionModal.show(
                          context,
                          onPermissionGranted: () => ref.read(interviewNotifierProvider.notifier).toggleCamera(),
                          onPermissionDenied: () {},
                        );
                      } else {
                        ref.read(interviewNotifierProvider.notifier).toggleCamera();
                      }
                    },
                    activeColor: AppTheme.primaryColor,
                  ),
                  const Divider(height: 1),
                  SwitchListTile(
                    title: Text('Enable Voice Recording & Speech Analysis', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600)),
                    subtitle: Text('Enables real-time speech-to-text transcript & clarity metrics', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                    value: state.micEnabled,
                    onChanged: (_) => ref.read(interviewNotifierProvider.notifier).toggleMic(),
                    activeColor: AppTheme.primaryColor,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Start Button
            PrimaryButton(
              text: 'Launch AI Mock Session',
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

