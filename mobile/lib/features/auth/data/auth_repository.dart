import 'dart:convert';
import 'package:dio/dio.dart';
import '../../../core/api/api_client.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/services/secure_storage_service.dart';
import '../domain/models/auth_tokens.dart';
import '../domain/models/user_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final SecureStorageService _storageService;

  AuthRepository(this._apiClient, this._storageService);

  // Register Endpoint
  Future<AuthTokens> register({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.register,
        data: {
          'email': email,
          'password': password,
          'full_name': fullName,
        },
      );

      final authTokens = AuthTokens.fromJson(response.data);
      await _saveSession(authTokens);
      return authTokens;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Login Endpoint
  Future<AuthTokens> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
          'full_name': 'N/A', // ignored by login schema
        },
      );

      final authTokens = AuthTokens.fromJson(response.data);
      await _saveSession(authTokens);
      return authTokens;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Get Current User Profile
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get(ApiConstants.me);
      final user = UserModel.fromJson(response.data);
      await _storageService.saveUserData(jsonEncode(user.toJson()));
      return user;
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // Check Local Auth State
  Future<UserModel?> getStoredUser() async {
    final token = await _storageService.getAccessToken();
    if (token == null || token.isEmpty) return null;

    final userData = await _storageService.getUserData();
    if (userData != null) {
      try {
        return UserModel.fromJson(jsonDecode(userData));
      } catch (_) {}
    }
    return null;
  }

  // Logout
  Future<void> logout() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _apiClient.dio.post(
          ApiConstants.logout,
          data: {'refresh_token': refreshToken},
        );
      }
    } catch (_) {
      // Ignore network failures on logout, local tokens will be cleared anyway
    } finally {
      await _storageService.clearTokens();
    }
  }

  Future<void> _saveSession(AuthTokens tokens) async {
    await _storageService.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
    await _storageService.saveUserData(jsonEncode(tokens.user.toJson()));
  }

  String _handleDioError(DioException e) {
    if (e.response != null && e.response?.data != null) {
      final data = e.response?.data;
      if (data is Map && data.containsKey('detail')) {
        return data['detail'].toString();
      }
    }
    return e.message ?? 'An unexpected network error occurred. Please check server connection.';
  }
}
