import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/camera_permission_service.dart';
import '../theme/app_theme.dart';
import 'custom_widgets.dart';

class CameraPermissionModal extends StatefulWidget {
  final VoidCallback onPermissionGranted;
  final VoidCallback onPermissionDenied;

  const CameraPermissionModal({
    super.key,
    required this.onPermissionGranted,
    required this.onPermissionDenied,
  });

  static Future<void> show(
    BuildContext context, {
    required VoidCallback onPermissionGranted,
    required VoidCallback onPermissionDenied,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => CameraPermissionModal(
        onPermissionGranted: onPermissionGranted,
        onPermissionDenied: onPermissionDenied,
      ),
    );
  }

  @override
  State<CameraPermissionModal> createState() => _CameraPermissionModalState();
}

class _CameraPermissionModalState extends State<CameraPermissionModal> {
  bool _isRequesting = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      contentPadding: const EdgeInsets.all(24),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.videocam_outlined, color: AppTheme.primaryColor, size: 28),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Camera & Mic Access',
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Strictly Private & Optional',
                      style: GoogleFonts.inter(fontSize: 11, color: AppTheme.secondaryColor, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'CareerLens AI uses your camera and microphone during mock interviews to evaluate observable communication signals (speaking pace, vocal clarity, and gaze engagement).',
            style: GoogleFonts.inter(fontSize: 13, height: 1.5, color: isDark ? Colors.grey.shade300 : Colors.grey.shade700),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.shield_outlined, color: Colors.green, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'No video recordings are permanently stored or used for model training without your explicit consent.',
                    style: GoogleFonts.inter(fontSize: 11, color: isDark ? Colors.grey.shade300 : Colors.grey.shade800),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: 'Allow Camera & Microphone',
            icon: Icons.check_circle_outline,
            isLoading: _isRequesting,
            onPressed: () async {
              setState(() => _isRequesting = true);
              await CameraPermissionService.requestCameraAndMicPermissions();
              if (mounted) {
                Navigator.of(context).pop();
                widget.onPermissionGranted();
              }
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                CameraPermissionService.denyPermissions();
                Navigator.of(context).pop();
                widget.onPermissionDenied();
              },
              child: Text(
                'Continue Without Camera (Text Only)',
                style: GoogleFonts.inter(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
