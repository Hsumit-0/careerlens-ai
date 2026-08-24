import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../data/interview_repository.dart';
import '../domain/models/interview_models.dart';

final interviewRepositoryProvider = Provider<InterviewRepository>((ref) {
  final storageService = SecureStorageService();
  final apiClient = ApiClient(storageService);
  return InterviewRepository(apiClient);
});

class InterviewState {
  final bool isLoading;
  final String? error;
  final InterviewSessionModel? session;
  final int currentQuestionIndex;
  final AnswerFeedbackModel? lastFeedback;
  final InterviewReportModel? finalReport;
  final bool cameraEnabled;
  final bool micEnabled;

  InterviewState({
    this.isLoading = false,
    this.error,
    this.session,
    this.currentQuestionIndex = 0,
    this.lastFeedback,
    this.finalReport,
    this.cameraEnabled = true,
    this.micEnabled = true,
  });

  InterviewState copyWith({
    bool? isLoading,
    String? error,
    InterviewSessionModel? session,
    int? currentQuestionIndex,
    AnswerFeedbackModel? lastFeedback,
    InterviewReportModel? finalReport,
    bool? cameraEnabled,
    bool? micEnabled,
  }) {
    return InterviewState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      session: session ?? this.session,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      lastFeedback: lastFeedback ?? this.lastFeedback,
      finalReport: finalReport ?? this.finalReport,
      cameraEnabled: cameraEnabled ?? this.cameraEnabled,
      micEnabled: micEnabled ?? this.micEnabled,
    );
  }
}

class InterviewNotifier extends StateNotifier<InterviewState> {
  final InterviewRepository _repository;

  InterviewNotifier(this._repository) : super(InterviewState());

  void toggleCamera() {
    state = state.copyWith(cameraEnabled: !state.cameraEnabled);
  }

  void toggleMic() {
    state = state.copyWith(micEnabled: !state.micEnabled);
  }

  Future<void> startSession({
    required String targetRole,
    required String interviewType,
    required String difficulty,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final session = await _repository.createSession(
        targetRole: targetRole,
        interviewType: interviewType,
        difficulty: difficulty,
        cameraEnabled: state.cameraEnabled,
      );
      state = state.copyWith(
        isLoading: false,
        session: session,
        currentQuestionIndex: 0,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> submitAnswer(String transcript, double durationSeconds) async {
    if (state.session == null || state.session!.questions.isEmpty) return;
    
    final currentQ = state.session!.questions[state.currentQuestionIndex];
    state = state.copyWith(isLoading: true, error: null);

    try {
      final feedback = await _repository.submitAnswer(
        sessionId: state.session!.id,
        questionId: currentQ.id,
        transcript: transcript,
        durationSeconds: durationSeconds,
      );

      final nextIndex = state.currentQuestionIndex + 1;
      state = state.copyWith(
        isLoading: false,
        lastFeedback: feedback,
        currentQuestionIndex: nextIndex < state.session!.questions.length ? nextIndex : state.currentQuestionIndex,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> finalizeInterview() async {
    if (state.session == null) return;
    state = state.copyWith(isLoading: true, error: null);
    try {
      final report = await _repository.analyzeAndFinalize(state.session!.id);
      state = state.copyWith(isLoading: false, finalReport: report);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final interviewNotifierProvider = StateNotifierProvider<InterviewNotifier, InterviewState>((ref) {
  final repo = ref.watch(interviewRepositoryProvider);
  return InterviewNotifier(repo);
});
