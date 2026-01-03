import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:buzzy_bee/core/constants/storage_constants.dart';

class ApiInterceptor extends Interceptor {
  
  final FlutterSecureStorage _secureStorage;

  ApiInterceptor(this._secureStorage);
  
  

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    
    // Add Authorization token if available
    final token = await _secureStorage.read(key: StorageConstants.accessToken);
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    

    // Add Accept-Language header
    options.headers['Accept-Language'] = 'en';

    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Handle successful responses
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Handle errors (logging, token refresh, etc.)
    return handler.next(err);
  }
}
