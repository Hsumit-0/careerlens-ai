import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_widgets.dart';

class ResumeUploadScreen extends StatefulWidget {
  const ResumeUploadScreen({super.key});

  @override
  State<ResumeUploadScreen> createState() => _ResumeUploadScreenState();
}

class _ResumeUploadScreenState extends State<ResumeUploadScreen> {
  final List<Map<String, dynamic>> _resumes = [
    {
      'id': 'res-1',
      'fileName': 'Software_Engineer_Resume.pdf',
      'uploadedAt': '2026-08-26 • 10:45 AM',
      'isActive': true,
      'parsedSkills': ['Python (90%)', 'FastAPI (85%)', 'PostgreSQL (80%)', 'Docker (75%)', 'REST APIs'],
      'projects': ['Async REST API Platform', 'AI Career Intelligence Engine'],
    },
  ];

  bool _isUploading = false;

  void _uploadNewResume() {
    setState(() => _isUploading = true);
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isUploading = false;
          final newId = 'res-${_resumes.length + 1}';
          for (var r in _resumes) {
            r['isActive'] = false;
          }
          _resumes.add({
            'id': newId,
            'fileName': 'Data_Scientist_CV_${_resumes.length + 1}.pdf',
            'uploadedAt': 'Just now',
            'isActive': true,
            'parsedSkills': ['Python (95%)', 'PyTorch (85%)', 'Pandas (90%)', 'Machine Learning', 'Data Analysis'],
            'projects': ['Deep Learning Recommendation Engine', 'Predictive Modeling Pipeline'],
          });
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New resume uploaded and parsed successfully! Active profile updated.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    });
  }

  void _setActiveResume(String id) {
    setState(() {
      for (var r in _resumes) {
        r['isActive'] = (r['id'] == id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeResume = _resumes.firstWhere((r) => r['isActive'] == true, orElse: () => _resumes.first);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Resume Manager & Parser',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            tooltip: 'View ATS Analysis',
            onPressed: () => context.push('/ats-analysis'),
          ),
        ],
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
                    child: const Icon(Icons.upload_file_outlined, color: Colors.white, size: 28),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Multi-Resume Management',
                          style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Upload multiple resumes, switch active profiles, and parse skills for personalized AI mock interviews.',
                          style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: 24),

            // Dropzone Box / Upload Button
            InkWell(
              onTap: _isUploading ? null : _uploadNewResume,
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.indigo.shade50.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.4),
                    width: 2,
                  ),
                ),
                child: Column(
                  children: [
                    if (_isUploading) ...[
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text('Extracting Skills & Parsing Projects PDF...', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 13)),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.cloud_upload_outlined, color: AppTheme.primaryColor, size: 36),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Click to Upload PDF or DOCX Resume',
                        style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Supports multiple resume uploads. Drag and drop or browse files.',
                        style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 28),

            // Uploaded Resumes List Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Uploaded Resumes (${_resumes.length})',
                  style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  ),
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Upload Another Resume'),
                  onPressed: _uploadNewResume,
                ),
              ],
            ),
            const SizedBox(height: 14),

            ..._resumes.map((res) {
              final isActive = res['isActive'] == true;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppTheme.primaryColor.withOpacity(0.12)
                        : (isDark ? const Color(0xFF1E293B) : Colors.white),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isActive ? AppTheme.primaryColor : Colors.grey.withOpacity(0.3),
                      width: isActive ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf, color: Colors.redAccent, size: 32),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    res['fileName'],
                                    style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isActive) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'ACTIVE',
                                      style: GoogleFonts.inter(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              res['uploadedAt'],
                              style: GoogleFonts.inter(fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      if (!isActive)
                        OutlinedButton(
                          onPressed: () => _setActiveResume(res['id']),
                          child: const Text('Set Active'),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),

            const SizedBox(height: 24),

            // Active Resume Parsed Skill Summary Card (Image 5 style)
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.psychology_outlined, color: AppTheme.primaryColor, size: 22),
                          const SizedBox(width: 8),
                          Text('Parsed Skills & Projects', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.purple.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'NLP Extracted',
                          style: GoogleFonts.inter(color: Colors.purpleAccent, fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text('Extracted Technical Skills:', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (activeResume['parsedSkills'] as List<String>)
                        .map((skill) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
                              ),
                              child: Text(skill, style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Text('Extracted Resume Projects:', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                  const SizedBox(height: 6),
                  ...(activeResume['projects'] as List<String>)
                      .map((proj) => Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: Row(
                              children: [
                                const Icon(Icons.code_rounded, color: AppTheme.secondaryColor, size: 16),
                                const SizedBox(width: 8),
                                Text(proj, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ))
                      .toList(),
                ],
              ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 28),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    text: 'View ATS Analysis',
                    icon: Icons.analytics_outlined,
                    onPressed: () => context.push('/ats-analysis'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    text: 'Start AI Mock Interview',
                    icon: Icons.videocam_outlined,
                    onPressed: () => context.push('/interview/setup'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
