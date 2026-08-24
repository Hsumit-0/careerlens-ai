class InterviewQuestionModel {
  final String id;
  final int questionOrder;
  final String questionText;
  final String questionType;
  final String difficulty;
  final String? sourceContext;

  InterviewQuestionModel({
    required this.id,
    required this.questionOrder,
    required this.questionText,
    required this.questionType,
    required this.difficulty,
    this.sourceContext,
  });

  factory InterviewQuestionModel.fromJson(Map<String, dynamic> json) {
    return InterviewQuestionModel(
      id: json['id'] ?? '',
      questionOrder: json['question_order'] ?? 1,
      questionText: json['question_text'] ?? '',
      questionType: json['question_type'] ?? 'technical',
      difficulty: json['difficulty'] ?? 'intermediate',
      sourceContext: json['source_context'],
    );
  }
}

class InterviewSessionModel {
  final String id;
  final String targetRole;
  final String interviewType;
  final String difficulty;
  final String status;
  final List<InterviewQuestionModel> questions;

  InterviewSessionModel({
    required this.id,
    required this.targetRole,
    required this.interviewType,
    required this.difficulty,
    required this.status,
    required this.questions,
  });

  factory InterviewSessionModel.fromJson(Map<String, dynamic> json) {
    return InterviewSessionModel(
      id: json['id'] ?? '',
      targetRole: json['target_role'] ?? 'Software Engineer',
      interviewType: json['interview_type'] ?? 'full_mock',
      difficulty: json['difficulty'] ?? 'intermediate',
      status: json['status'] ?? 'in_progress',
      questions: (json['questions'] as List<dynamic>?)
              ?.map((q) => InterviewQuestionModel.fromJson(q))
              .toList() ??
          [],
    );
  }
}

class AnswerFeedbackModel {
  final String questionId;
  final double evaluatedScore;
  final String feedback;
  final String suggestedImprovement;
  final bool isFollowupNeeded;
  final String? followupQuestion;

  AnswerFeedbackModel({
    required this.questionId,
    required this.evaluatedScore,
    required this.feedback,
    required this.suggestedImprovement,
    required this.isFollowupNeeded,
    this.followupQuestion,
  });

  factory AnswerFeedbackModel.fromJson(Map<String, dynamic> json) {
    return AnswerFeedbackModel(
      questionId: json['question_id'] ?? '',
      evaluatedScore: (json['evaluated_score'] as num?)?.toDouble() ?? 80.0,
      feedback: json['feedback'] ?? '',
      suggestedImprovement: json['suggested_improvement'] ?? '',
      isFollowupNeeded: json['is_followup_needed'] ?? false,
      followupQuestion: json['followup_question'],
    );
  }
}

class InterviewReportModel {
  final String interviewId;
  final String targetRole;
  final double overallScore;
  final double technicalScore;
  final double answerQualityScore;
  final double communicationScore;
  final double observedConfidenceIndicator;
  final double speakingPaceWpm;
  final int fillerWordCount;
  final List<String> strengths;
  final List<String> improvements;
  final List<String> recommendations;
  final String disclaimer;

  InterviewReportModel({
    required this.interviewId,
    required this.targetRole,
    required this.overallScore,
    required this.technicalScore,
    required this.answerQualityScore,
    required this.communicationScore,
    required this.observedConfidenceIndicator,
    required this.speakingPaceWpm,
    required this.fillerWordCount,
    required this.strengths,
    required this.improvements,
    required this.recommendations,
    required this.disclaimer,
  });

  factory InterviewReportModel.fromJson(Map<String, dynamic> json) {
    return InterviewReportModel(
      interviewId: json['interview_id'] ?? '',
      targetRole: json['target_role'] ?? 'Software Engineer',
      overallScore: (json['overall_score'] as num?)?.toDouble() ?? 82.0,
      technicalScore: (json['technical_score'] as num?)?.toDouble() ?? 84.0,
      answerQualityScore: (json['answer_quality_score'] as num?)?.toDouble() ?? 80.0,
      communicationScore: (json['communication_score'] as num?)?.toDouble() ?? 78.0,
      observedConfidenceIndicator: (json['observed_confidence_indicator'] as num?)?.toDouble() ?? 76.0,
      speakingPaceWpm: (json['speaking_pace_wpm'] as num?)?.toDouble() ?? 135.0,
      fillerWordCount: json['filler_word_count'] ?? 2,
      strengths: List<String>.from(json['strengths'] ?? []),
      improvements: List<String>.from(json['improvements'] ?? []),
      recommendations: List<String>.from(json['recommendations'] ?? []),
      disclaimer: json['disclaimer'] ?? 'Estimated observable communication signals.',
    );
  }
}
