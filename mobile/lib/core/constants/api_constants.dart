class ApiConstants {
  // Mobile Network IP Configuration
  // 172.20.10.2 connects physical Android/iOS phones on your local Wi-Fi to your PC
  static const String baseUrl = 'http://172.20.10.2:8000/api/v1';
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
