import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../services/secure_storage_service.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorageService _storageService;
  final Dio _dio;
  bool _isRefreshing = false;
  final List<void Function(String)> _refreshQueue = [];

  AuthInterceptor(this._storageService, this._dio);

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    // Skip adding auth token for auth endpoints
    if (options.path.contains('/auth/login') ||
        options.path.contains('/auth/register') ||
        options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    final token = await _storageService.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401 && !err.requestOptions.path.contains('/auth/')) {
      if (!_isRefreshing) {
        _isRefreshing = true;
        try {
          final refreshToken = await _storageService.getRefreshToken();
          if (refreshToken == null || refreshToken.isEmpty) {
            await _storageService.clearTokens();
            return handler.next(err);
          }

          // Call Refresh Endpoint
          final response = await _dio.post(
            ApiConstants.refresh,
            data: {'refresh_token': refreshToken},
            options: Options(headers: {'Authorization': ''}),
          );

          final newAccessToken = response.data['access_token'];
          final newRefreshToken = response.data['refresh_token'];

          await _storageService.saveTokens(
            accessToken: newAccessToken,
            refreshToken: newRefreshToken,
          );

          // Flush queued requests
          for (final callback in _refreshQueue) {
            callback(newAccessToken);
          }
          _refreshQueue.clear();

          // Retry failed request
          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
          final retriedResponse = await _dio.fetch(err.requestOptions);
          return handler.resolve(retriedResponse);
        } catch (refreshErr) {
          await _storageService.clearTokens();
          _refreshQueue.clear();
          return handler.next(err);
        } finally {
          _isRefreshing = false;
        }
      } else {
        // Queue request while token is actively refreshing
        return Future<void>(() {
          _refreshQueue.add((String newAccessToken) async {
            err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
            try {
              final response = await _dio.fetch(err.requestOptions);
              handler.resolve(response);
            } catch (retryError) {
              if (retryError is DioException) {
                handler.next(retryError);
              }
            }
          });
        });
      }
    }
    return handler.next(err);
  }
}
