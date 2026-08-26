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
      final viewId = 'web-cam-view-${DateTime.now().millisecondsSinceEpoch}';
      _videoElement = html.VideoElement()
        ..autoplay = true
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = 'cover';

      ui_web.platformViewRegistry.registerViewFactory(viewId, (int id) => _videoElement!);

      html.window.navigator.mediaDevices?.getUserMedia({'video': true, 'audio': false}).then((stream) {
        if (_videoElement != null) {
          _videoElement!.srcObject = stream;
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
    } catch (e) {
      // Fallback handling
    }
  }

  void _toggleMicRecording() {
    setState(() => _isRecording = !_isRecording);
    if (_isRecording) {
      try {
        _speechRecognition?.start();
      } catch (e) {
        // Speech API fallback simulation
      }
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
          // Interview Progress & AI Status Banner
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
                      _isRecording ? 'Listening & Transcribing Speech...' : 'AI Interviewer Active',
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
                  // Live Camera Stream Container
                  if (state.cameraEnabled)
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5), width: 2),
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
                            if (_hasCameraStream && _videoElement != null)
                              HtmlElementView(viewType: _videoElement!.id)
                            else
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.videocam_outlined, color: Colors.white54, size: 44),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Live Webcam Stream Enabled',
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
                                  color: Colors.black.withOpacity(0.7),
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
                                      _isRecording ? 'LIVE RECORDING' : 'WEBCAM ACTIVE',
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
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.15),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
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

                  // Live Mic Controls
                  if (_useVoiceInput) ...[
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: _isRecording ? Colors.redAccent : Colors.transparent),
                      ),
                      child: Column(
                        children: [
                          Text(
                            _isRecording
                                ? '🎤 Speaking Now... Spoken words transcribing live below!'
                                : 'Tap Red Mic to Speak into Microphone',
                            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: _isRecording ? Colors.redAccent : Colors.grey),
                          ),
                          const SizedBox(height: 14),
                          GestureDetector(
                            onTap: _toggleMicRecording,
                            child: CircleAvatar(
                              radius: 36,
                              backgroundColor: _isRecording ? Colors.redAccent : AppTheme.primaryColor,
                              child: Icon(
                                _isRecording ? Icons.mic : Icons.mic_none_rounded,
                                color: Colors.white,
                                size: 36,
                              ),
                            ).animate(target: _isRecording ? 1 : 0).scale(duration: 300.ms),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 14),

                  // Live Transcript Input Box
                  TextField(
                    controller: _textController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Speak into your mic or type your detailed response here...',
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
