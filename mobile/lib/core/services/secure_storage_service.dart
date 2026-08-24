import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save Tokens
  Future<void> saveTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: ApiConstants.accessTokenKey, value: accessToken);
    await _storage.write(key: ApiConstants.refreshTokenKey, value: refreshToken);
  }

  // Get Access Token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: ApiConstants.accessTokenKey);
  }

  // Get Refresh Token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: ApiConstants.refreshTokenKey);
  }

  // Clear Tokens (Logout)
  Future<void> clearTokens() async {
    await _storage.delete(key: ApiConstants.accessTokenKey);
    await _storage.delete(key: ApiConstants.refreshTokenKey);
    await _storage.delete(key: ApiConstants.userDataKey);
  }

  // Save User Cache
  Future<void> saveUserData(String jsonString) async {
    await _storage.write(key: ApiConstants.userDataKey, value: jsonString);
  }

  // Get User Cache
  Future<String?> getUserData() async {
    return await _storage.read(key: ApiConstants.userDataKey);
  }
}
