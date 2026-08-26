class ApiConstants {
  // Environment override: Pass --dart-define=API_BASE_URL=https://your-backend.onrender.com/api/v1
  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');
  static String get baseUrl {
    if (_envBaseUrl.isNotEmpty) {
      return _envBaseUrl;
    }
    return fallbackLocalUrl;
  }

  static const String androidEmulatorUrl = 'http://10.0.2.2:8000/api/v1';
  static const String fallbackLocalUrl = 'http://127.0.0.1:8000/api/v1';


  // Timeout Config
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  // Endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login/json';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String me = '/auth/me';

  // Storage Keys
  static const String accessTokenKey = 'auth_access_token';
  static const String refreshTokenKey = 'auth_refresh_token';
  static const String userDataKey = 'auth_user_data';
}
