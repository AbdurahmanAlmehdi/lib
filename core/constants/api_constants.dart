class ApiConstants {
  ApiConstants._();

  /// Base URL based on flavor
  static String baseUrl = 'https://moamalat-dev.mataaa.com';

  static const String devBaseUrl = 'https://dev-api.buzzy-bee.ly/api/v1';
  static const String stagingBaseUrl =
      'https://staging-api.buzzy-bee.ly/api/v1';
  static const String productionBaseUrl = 'https://api.buzzy-bee.ly/api/v1';

  static const String banners = '/banners';
  static const String categories = '/categories';
  static const String services = '/services';
  static const String cleaners = '/cleaners';
  static const String bookings = '/bookings';
  static const String orders = '/orders';
  static const String favorites = '/favorites';
  static const String auth = '/auth';
  static const String user = '/user';

  /// HTTP Status Helpers
  static bool isHttpStatusOK(int? statusCode) {
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }
}
