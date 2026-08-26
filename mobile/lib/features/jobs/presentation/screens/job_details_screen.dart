import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_widgets.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../data/job_repository.dart';
import '../../domain/models/job_models.dart';
import 'jobs_hub_screen.dart';

class JobDetailsScreen extends ConsumerStatefulWidget {
  final String jobId;
  const JobDetailsScreen({super.key, required this.jobId});

  @override
  ConsumerState<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends ConsumerState<JobDetailsScreen> {
  JobModel? _job;
  JobMatchModel? _match;
  bool _isLoading = true;
  String _selectedResume = 'Backend Developer Resume.pdf';

  final List<String> _userResumes = [
    'Backend Developer Resume.pdf',
    'Software Engineer Resume.pdf',
    'Machine Learning Resume.pdf',
  ];

  @override
  void initState() {
    super.initState();
    _loadJobDetails();
  }

  Future<void> _loadJobDetails() async {
    setState(() => _isLoading = true);
    final repo = ref.read(jobRepositoryProvider);
    final jobs = await repo.searchJobs();
    final matchedJob = jobs.firstWhere((j) => j.id == widget.jobId, orElse: () => jobs.first);
    final matchData = await repo.getJobMatch(widget.jobId, resumeId: _selectedResume);

    setState(() {
      _job = matchedJob;
      _match = matchData;
      _isLoading = false;
    });
  }

  void _openOriginalJobUrl() {
    if (_job?.applicationUrl != null && _job!.applicationUrl.isNotEmpty) {
      html.window.open(_job!.applicationUrl, '_blank');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_isLoading || _job == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Job Details')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final job = _job!;
    final match = _match!;

    return Scaffold(
      appBar: AppBar(
        title: Text(job.title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Job saved to Application Tracker!')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Company Header Banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppTheme.darkCardGradient,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.white24,
                        child: Text(job.companyName[0], style: GoogleFonts.outfit(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(job.title, style: GoogleFonts.outfit(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('${job.companyName} • ${job.location}', style: GoogleFonts.inter(color: Colors.white70, fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(job.salaryRange ?? 'Competitive Salary', style: GoogleFonts.inter(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(8)),
                        child: Text(job.workType, style: GoogleFonts.inter(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms),

            const SizedBox(height: 22),

            // RESUME SELECTOR DROPDOWN (Feature #7)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SELECT RESUME FOR AI MATCHING', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedResume,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      border: OutlineInputBorder(),
                    ),
                    items: _userResumes.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedResume = val);
                        _loadJobDetails();
                      }
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // AI MATCH RATIONALE CARD (Feature #5 & #6)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.green.withOpacity(0.4), width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('YOUR MATCH WITH THIS JOB', style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(color: Colors.green.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                        child: Text('${match.overallMatch.toInt()}% MATCH', style: GoogleFonts.outfit(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Match Breakdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMetricBox('Skills Match', '${match.skillMatchScore.toInt()}%', Colors.blue),
                      _buildMetricBox('Experience', '${match.experienceMatchScore.toInt()}%', Colors.purple),
                      _buildMetricBox('Semantic', '${match.semanticMatchScore.toInt()}%', Colors.teal),
                    ],
                  ),

                  const SizedBox(height: 18),

                  // Strong Matches
                  Text('✓ Strong Matches:', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: match.strongMatches.map((m) => Chip(label: Text(m), backgroundColor: Colors.green.withOpacity(0.1))).toList(),
                  ),

                  const SizedBox(height: 14),

                  // Missing Skills
                  Text('✗ Missing Skills to Acquire:', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: match.missingSkills.map((m) => Chip(label: Text(m), backgroundColor: Colors.red.withOpacity(0.1))).toList(),
                  ),

                  const SizedBox(height: 14),

                  // Evidence Trace
                  Text('Evidence Trace:', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  ...match.evidenceTrace.map((ev) => Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Text('• ${ev['skill']}: ${ev['source']}', style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
                      )),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // Job Description
            Text('Job Description', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(job.description, style: GoogleFonts.inter(fontSize: 14, height: 1.5)),

            const SizedBox(height: 28),

            // Action Buttons
            PrimaryButton(
              text: 'Apply on Original Platform',
              icon: Icons.launch_rounded,
              onPressed: _openOriginalJobUrl,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.video_call_rounded, color: AppTheme.primaryColor),
                label: Text('Practice Interview for This Job', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                onPressed: () => context.push('/interview/setup'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.map_rounded, color: Colors.purple),
                label: Text('Improve My Match Roadmap', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.purple)),
                onPressed: () => context.push('/roadmap'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricBox(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: GoogleFonts.inter(fontSize: 11, color: Colors.grey)),
      ],
    );
  }
}
