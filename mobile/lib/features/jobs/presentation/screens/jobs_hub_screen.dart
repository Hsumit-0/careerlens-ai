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

final jobRepositoryProvider = Provider<JobRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return JobRepository(apiClient);
});

class JobsHubScreen extends ConsumerStatefulWidget {
  const JobsHubScreen({super.key});

  @override
  ConsumerState<JobsHubScreen> createState() => _JobsHubScreenState();
}

class _JobsHubScreenState extends ConsumerState<JobsHubScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';
  List<JobModel> _jobs = [];
  List<JobModel> _recommendedJobs = [];
  bool _isLoading = true;

  final List<String> _quickFilters = ['All', 'Remote', 'Fresher', 'Backend', 'AI & ML', 'Full-time'];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoading = true);
    final repo = ref.read(jobRepositoryProvider);
    final jobs = await repo.searchJobs(
      query: _searchController.text.trim(),
      remoteOnly: _selectedFilter == 'Remote',
      experience_level: _selectedFilter == 'Fresher' ? 'Entry Level' : null,
    );
    final recommended = await repo.getRecommendations();

    setState(() {
      _jobs = jobs;
      _recommendedJobs = recommended;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jobs Hub & Matching',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded),
            tooltip: 'Application Tracker',
            onPressed: () => context.push('/jobs/tracker'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar & Filter Chips (Image 4 style)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: AppTheme.primaryColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search jobs, skills (e.g. Python, Backend)...',
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      onSubmitted: (_) => _loadJobs(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.tune_rounded, color: AppTheme.primaryColor),
                    onPressed: _loadJobs,
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 350.ms),

            const SizedBox(height: 14),

            // Quick Filter Pills
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _quickFilters.map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (val) {
                        setState(() => _selectedFilter = filter);
                        _loadJobs();
                      },
                      selectedColor: AppTheme.primaryColor,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 24),

            // RECOMMENDED FOR YOU (Image 4 matching)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: Colors.amber, size: 20),
                    const SizedBox(width: 6),
                    Text('Recommended For You', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
                TextButton(
                  onPressed: () => context.push('/jobs/tracker'),
                  child: const Text('Tracker >'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              // Recommended Horizontal Cards
              SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recommendedJobs.length,
                  itemBuilder: (ctx, i) {
                    final item = _recommendedJobs[i];
                    return Padding(
                      padding: const EdgeInsets.only(right: 14.0),
                      child: Container(
                        width: 280,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: AppTheme.darkCardGradient,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.green.withOpacity(0.4)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.green.withOpacity(0.25),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${item.aiMatchScore.toInt()}% MATCH',
                                    style: GoogleFonts.inter(color: Colors.greenAccent, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            Text('${item.companyName} • ${item.location}', style: GoogleFonts.inter(color: Colors.grey.shade300, fontSize: 12)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(item.salaryRange ?? 'Competitive', style: GoogleFonts.inter(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.bold)),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, foregroundColor: Colors.white),
                                  child: const Text('Details'),
                                  onPressed: () => context.push('/jobs/${item.id}'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 28),

              // TRENDING JOB LISTINGS (Image 4 matching)
              Text('Trending Job Listings', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),

              ..._jobs.map((job) => Padding(
                    padding: const EdgeInsets.only(bottom: 14.0),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
                                child: Text(job.companyName[0], style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(job.title, style: GoogleFonts.outfit(fontSize: 17, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 2),
                                    Text('${job.companyName} • ${job.location} • ${job.workType}', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '${job.aiMatchScore.toInt()}% MATCH',
                                  style: GoogleFonts.inter(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: job.requiredSkills
                                .map((sk) => Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(sk, style: GoogleFonts.inter(fontSize: 11, color: Colors.indigo)),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(job.salaryRange ?? 'Salary Undisclosed', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: AppTheme.primaryColor)),
                              PrimaryButton(
                                text: 'View Details & Match',
                                icon: Icons.arrow_forward_rounded,
                                onPressed: () => context.push('/jobs/${job.id}'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )).toList(),
            ],
          ],
        ),
      ),
    );
  }
}
