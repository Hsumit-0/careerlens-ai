import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_widgets.dart';
import '../../providers/interview_provider.dart';

class InterviewStudioScreen extends ConsumerStatefulWidget {
  const InterviewStudioScreen({super.key});

  @override
  ConsumerState<InterviewStudioScreen> createState() => _InterviewStudioScreenState();
}

class _InterviewStudioScreenState extends ConsumerState<InterviewStudioScreen> {
  final _textController = TextEditingController();
  bool _isRecording = false;
  bool _useVoiceInput = true;
  html.VideoElement? _videoElement;
  String _viewId = '';
  dynamic _speechRecognition;
  String _liveTranscript = "";
  bool _hasCameraStream = false;

  @override
  void initState() {
    super.initState();
    _initWebCamStream();
    _initSpeechRecognition();
  }

  void _initWebCamStream() {
    try {
      _viewId = 'web-cam-view-${DateTime.now().millisecondsSinceEpoch}';
      _videoElement = html.VideoElement()
        ..autoplay = true
        ..muted = true // Crucial for Chrome autoplay policy
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover'
        ..setAttribute('playsinline', 'true');

      ui_web.platformViewRegistry.registerViewFactory(_viewId, (int id) => _videoElement!);

      html.window.navigator.mediaDevices?.getUserMedia({
        'video': {
          'width': {'ideal': 1280},
          'height': {'ideal': 720},
          'facingMode': 'user'
        },
        'audio': false
      }).then((stream) {
        if (_videoElement != null) {
          _videoElement!.srcObject = stream;
          _videoElement!.play(); // Forces immediate video playback
          setState(() => _hasCameraStream = true);
        }
      }).catchError((err) {
        setState(() => _hasCameraStream = false);
      });
    } catch (e) {
      _hasCameraStream = false;
    }
  }

  void _initSpeechRecognition() {
    try {
      if (html.SpeechRecognition.supported) {
        _speechRecognition = html.SpeechRecognition()
          ..continuous = true
          ..interimResults = true
          ..lang = 'en-US';

        _speechRecognition.onResult.listen((event) {
          String transcript = "";
          for (var result in event.results) {
            transcript += result[0].transcript + " ";
          }
          setState(() {
            _liveTranscript = transcript;
            _textController.text = transcript;
          });
        });
      }
    } catch (e) {}
  }

  void _toggleMicRecording() {
    setState(() => _isRecording = !_isRecording);
    if (_isRecording) {
      try {
        _speechRecognition?.start();
      } catch (e) {}
    } else {
      try {
        _speechRecognition?.stop();
      } catch (e) {}
    }
  }

  @override
  void dispose() {
    try {
      final mediaStream = _videoElement?.srcObject as html.MediaStream?;
      mediaStream?.getTracks().forEach((track) => track.stop());
    } catch (e) {}
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(interviewNotifierProvider);
    final session = state.session;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (session == null || session.questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('AI Interview Studio')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final totalQ = session.questions.length;
    final currentIdx = state.currentQuestionIndex.clamp(0, totalQ - 1);
    final currentQ = session.questions[currentIdx];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'AI Mock Interview',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.stop_circle_outlined, color: Colors.redAccent),
            label: Text('End Session', style: GoogleFonts.inter(color: Colors.redAccent, fontWeight: FontWeight.bold)),
            onPressed: () async {
              await ref.read(interviewNotifierProvider.notifier).finalizeInterview();
              if (mounted) context.push('/interview/report');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: isDark ? const Color(0xFF1E293B) : Colors.indigo.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.greenAccent,
                        shape: BoxShape.circle,
                      ),
                    ).animate(onPlay: (c) => c.repeat()).fade(duration: 1.seconds),
                    const SizedBox(width: 8),
                    Text(
                      _isRecording ? 'Listening to your voice...' : 'AI Interviewer Active',
                      style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: _isRecording ? Colors.redAccent : null),
                    ),
                  ],
                ),
                Text(
                  'Question ${currentIdx + 1} of $totalQ',
                  style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.primaryColor),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                children: [
                  // Live Camera Stream Box with explicit play() & HTML view
                  if (state.cameraEnabled)
                    Container(
                      height: 220,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.6), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryColor.withOpacity(0.2),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Stack(
                          children: [
                            if (_viewId.isNotEmpty)
                              HtmlElementView(viewType: _viewId)
                            else
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.videocam_outlined, color: Colors.white54, size: 44),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Connecting Live Camera Feed...',
                                      style: GoogleFonts.inter(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            Positioned(
                              top: 12,
                              left: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      _isRecording ? Icons.fiber_manual_record : Icons.videocam,
                                      color: _isRecording ? Colors.redAccent : Colors.greenAccent,
                                      size: 14,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      _isRecording ? 'LIVE RECORDING' : 'WEBCAM STREAM LIVE',
                                      style: GoogleFonts.inter(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(duration: 400.ms),

                  const SizedBox(height: 18),

                  // Current Question Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppTheme.darkCardGradient,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.25),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                currentQ.questionType.toUpperCase(),
                                style: GoogleFonts.inter(color: AppTheme.secondaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            if (currentQ.sourceContext != null)
                              Flexible(
                                child: Text(
                                  currentQ.sourceContext!,
                                  style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 10),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '"${currentQ.questionText}"',
                          style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600, height: 1.4),
                        ),
                      ],
                    ),
                  ).animate().scale(duration: 350.ms),

                  const SizedBox(height: 20),

                  // Voice vs Text Input Mode Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ChoiceChip(
                        label: const Text('🎙️ Live Voice Input'),
                        selected: _useVoiceInput,
                        onSelected: (val) => setState(() => _useVoiceInput = true),
                        selectedColor: AppTheme.primaryColor,
                      ),
                      const SizedBox(width: 12),
                      ChoiceChip(
                        label: const Text('⌨️ Text Input'),
                        selected: !_useVoiceInput,
                        onSelected: (val) => setState(() => _useVoiceInput = false),
                        selectedColor: AppTheme.primaryColor,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // LARGE PROMINENT UN-MISSABLE MICROPHONE RECORD BUTTON
                  if (_useVoiceInput) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _isRecording ? Colors.red.withOpacity(0.15) : (isDark ? const Color(0xFF1E293B) : Colors.indigo.shade50),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: _isRecording ? Colors.redAccent : AppTheme.primaryColor.withOpacity(0.4),
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _isRecording
                                ? '🔴 RECORDING LIVE... Speak your answer now!'
                                : 'Tap the big Red Button below to start speaking your answer:',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: _isRecording ? Colors.redAccent : (isDark ? Colors.white : Colors.indigo.shade900),
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _isRecording ? Colors.redAccent : const Color(0xFFEF4444),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 8,
                            ),
                            icon: Icon(_isRecording ? Icons.stop_circle_rounded : Icons.mic_rounded, size: 30),
                            label: Text(
                              _isRecording ? 'TAP TO STOP RECORDING' : '🎙️ TAP HERE TO RECORD YOUR VOICE',
                              style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            onPressed: _toggleMicRecording,
                          ).animate(target: _isRecording ? 1 : 0).scale(duration: 300.ms),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Spoken / Written Response Box
                  TextField(
                    controller: _textController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Spoken speech or typed response will appear here...',
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Submit Button
                  PrimaryButton(
                    text: currentIdx < totalQ - 1 ? 'Submit & Next Question' : 'Complete & Generate Report',
                    icon: Icons.send_rounded,
                    isLoading: state.isLoading,
                    onPressed: () async {
                      final text = _textController.text.trim();
                      await ref.read(interviewNotifierProvider.notifier).submitAnswer(text, 35.0);
                      _textController.clear();
                      setState(() => _isRecording = false);

                      if (currentIdx >= totalQ - 1) {
                        await ref.read(interviewNotifierProvider.notifier).finalizeInterview();
                        if (mounted) context.push('/interview/report');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
