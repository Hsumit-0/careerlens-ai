class JobModel {
  final String id;
  final String? externalId;
  final String provider;
  final String title;
  final String companyName;
  final String location;
  final String workType;
  final String experienceLevel;
  final String? salaryRange;
  final String description;
  final List<String> requiredSkills;
  final String applicationUrl;
  final DateTime postedAt;
  final double aiMatchScore;

  JobModel({
    required this.id,
    this.externalId,
    required this.provider,
    required this.title,
    required this.companyName,
    required this.location,
    required this.workType,
    required this.experienceLevel,
    this.salaryRange,
    required this.description,
    required this.requiredSkills,
    required this.applicationUrl,
    required this.postedAt,
    this.aiMatchScore = 85.0,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? '',
      externalId: json['external_id'],
      provider: json['provider'] ?? 'official',
      title: json['title'] ?? 'Software Engineer',
      companyName: json['company_name'] ?? 'Tech Company',
      location: json['location'] ?? 'Remote',
      workType: json['work_type'] ?? 'Full-time',
      experienceLevel: json['experience_level'] ?? 'Mid Level',
      salaryRange: json['salary_range'],
      description: json['description'] ?? '',
      requiredSkills: List<String>.from(json['required_skills'] ?? []),
      applicationUrl: json['application_url'] ?? '',
      postedAt: json['posted_at'] != null ? DateTime.parse(json['posted_at']) : DateTime.now(),
      aiMatchScore: (json['ai_match_score'] as num?)?.toDouble() ?? 85.0,
    );
  }
}

class JobMatchModel {
  final String jobId;
  final String resumeId;
  final double overallMatch;
  final double skillMatchScore;
  final double experienceMatchScore;
  final double semanticMatchScore;
  final List<String> strongMatches;
  final List<String> missingSkills;
  final List<Map<String, String>> evidenceTrace;

  JobMatchModel({
    required this.jobId,
    required this.resumeId,
    required this.overallMatch,
    required this.skillMatchScore,
    required this.experienceMatchScore,
    required this.semanticMatchScore,
    required this.strongMatches,
    required this.missingSkills,
    required this.evidenceTrace,
  });

  factory JobMatchModel.fromJson(Map<String, dynamic> json) {
    return JobMatchModel(
      jobId: json['job_id'] ?? '',
      resumeId: json['resume_id'] ?? '',
      overallMatch: (json['overall_match'] as num?)?.toDouble() ?? 82.0,
      skillMatchScore: (json['skill_match_score'] as num?)?.toDouble() ?? 88.0,
      experienceMatchScore: (json['experience_match_score'] as num?)?.toDouble() ?? 75.0,
      semanticMatchScore: (json['semantic_match_score'] as num?)?.toDouble() ?? 80.0,
      strongMatches: List<String>.from(json['strong_matches'] ?? ['Python', 'FastAPI', 'PostgreSQL']),
      missingSkills: List<String>.from(json['missing_skills'] ?? ['AWS', 'Kubernetes']),
      evidenceTrace: (json['evidence_trace'] as List?)
              ?.map((item) => Map<String, String>.from(item as Map))
              .toList() ??
          [],
    );
  }
}

class JobApplicationModel {
  final String id;
  final String jobId;
  final String jobTitle;
  final String companyName;
  final String status;
  final DateTime appliedAt;
  final String? notes;

  JobApplicationModel({
    required this.id,
    required this.jobId,
    required this.jobTitle,
    required this.companyName,
    required this.status,
    required this.appliedAt,
    this.notes,
  });

  factory JobApplicationModel.fromJson(Map<String, dynamic> json) {
    return JobApplicationModel(
      id: json['id'] ?? '',
      jobId: json['job_id'] ?? '',
      jobTitle: json['job_title'] ?? 'Software Engineer',
      companyName: json['company_name'] ?? 'Tech Company',
      status: json['status'] ?? 'applied',
      appliedAt: json['applied_at'] != null ? DateTime.parse(json['applied_at']) : DateTime.now(),
      notes: json['notes'],
    );
  }
}
