import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/models/job_models.dart';
import 'jobs_hub_screen.dart';

class JobTrackerScreen extends ConsumerStatefulWidget {
  const JobTrackerScreen({super.key});

  @override
  ConsumerState<JobTrackerScreen> createState() => _JobTrackerScreenState();
}

class _JobTrackerScreenState extends ConsumerState<JobTrackerScreen> {
  List<JobApplicationModel> _apps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadApplications();
  }

  Future<void> _loadApplications() async {
    setState(() => _isLoading = true);
    final repo = ref.read(jobRepositoryProvider);
    final apps = await repo.getApplications();
    setState(() {
      _apps = apps;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Application Tracker', style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18)),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Applied'),
              Tab(text: 'Interview Stage'),
              Tab(text: 'Offer Stage'),
              Tab(text: 'Saved'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildStageList('applied', isDark),
                  _buildStageList('interview', isDark),
                  _buildStageList('offer', isDark),
                  _buildStageList('saved', isDark),
                ],
              ),
      ),
    );
  }

  Widget _buildStageList(String stage, bool isDark) {
    final filtered = _apps.where((a) => a.status.toLowerCase() == stage.toLowerCase()).toList();

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.assignment_outlined, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text('No applications in $stage stage yet', style: GoogleFonts.inter(color: Colors.grey, fontSize: 14)),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (ctx, i) {
        final item = filtered[i];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: CircleAvatar(
              backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
              child: Text(item.companyName[0], style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
            ),
            title: Text(item.jobTitle, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 4),
                Text('${item.companyName} • Applied ${item.appliedAt.day}/${item.appliedAt.month}/${item.appliedAt.year}', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(stage.toUpperCase(), style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue)),
            ),
          ),
        ).animate().fadeIn(duration: 300.ms);
      },
    );
  }
}
