import 'dart:async';
import 'package:flutter/foundation.dart';

enum PermissionStatusState {
  granted,
  denied,
  prompt,
}

class CameraPermissionService {
  static PermissionStatusState _cameraStatus = PermissionStatusState.prompt;
  static PermissionStatusState _micStatus = PermissionStatusState.prompt;

  static PermissionStatusState get cameraStatus => _cameraStatus;
  static PermissionStatusState get micStatus => _micStatus;

  /// Requests explicit camera & microphone permission.
  static Future<bool> requestCameraAndMicPermissions() async {
    // Simulated permission request callback for web & mobile
    await Future.delayed(const Duration(milliseconds: 600));
    _cameraStatus = PermissionStatusState.granted;
    _micStatus = PermissionStatusState.granted;
    return true;
  }

  /// Denies permission explicitly
  static void denyPermissions() {
    _cameraStatus = PermissionStatusState.denied;
    _micStatus = PermissionStatusState.denied;
  }

  /// Reset permission prompt state
  static void reset() {
    _cameraStatus = PermissionStatusState.prompt;
    _micStatus = PermissionStatusState.prompt;
  }
}
