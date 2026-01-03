import 'package:dio/dio.dart';
import 'package:buzzy_bee/core/network/error_logger.dart';

class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic data;

  const ServerException(this.message, {this.statusCode, this.data});

  @override
  String toString() => 'ServerException: $message';
}

class NoInternetException extends ServerException {
  NoInternetException(DioExceptionType error)
      : super(_buildMessage(error));

  static String _buildMessage(DioExceptionType error) {
    const String baseMessage = 'Please check your internet connection';

    switch (error) {
      case DioExceptionType.connectionTimeout:
        return '$baseMessage - Connection Timeout';
      case DioExceptionType.sendTimeout:
        return '$baseMessage - Send Timeout';
      case DioExceptionType.receiveTimeout:
        return '$baseMessage - Receive Timeout';
      case DioExceptionType.connectionError:
        return '$baseMessage - No Internet';
      default:
        return '$baseMessage - Unknown Error';
    }
  }
}

class ApiException extends ServerException {
  const ApiException(super.message, {super.statusCode, super.data});
}

class TimeoutException extends ServerException {
  const TimeoutException() : super('Request timeout');
}

class UnknownException extends ServerException {
  const UnknownException({
    String message = 'An unknown error occurred',
    int? statusCode,
    dynamic data,
  }) : super(message, statusCode: statusCode, data: data);
}

class ExceptionHandler {
  const ExceptionHandler._();

  static ErrorLogger _errorLogger = const DefaultErrorLogger();

  static set errorLogger(ErrorLogger errorLogger) {
    _errorLogger = errorLogger;
  }

  static ServerException handle(Object error, [String? operationName]) {
    if (error is ServerException) {
      _errorLogger.logError(
        error: error.toString(),
        operationName: operationName ?? 'Unknown Operation',
      );
      return error;
    }

    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.connectionError:
          final noInternetException = NoInternetException(error.type);
          _errorLogger.logError(
            error: noInternetException.toString(),
            operationName: operationName ?? 'Unknown Operation',
          );
          return noInternetException;

        case DioExceptionType.badResponse:
          final response = error.response;
          final statusCode = response?.statusCode;
          final data = response?.data;

          String message = _extractErrorMessage(data, statusCode) ??
              'An unknown error occurred';

          final apiException =
              ApiException(message, statusCode: statusCode, data: data);

          _errorLogger.logError(
            error: apiException.toString(),
            operationName: operationName ?? 'Unknown Operation',
          );

          return apiException;

        case DioExceptionType.badCertificate:
        case DioExceptionType.cancel:
        case DioExceptionType.unknown:
          final technicalError = UnknownException(
            message: 'An unknown error occurred',
            statusCode: error.response?.statusCode,
            data: error.error,
          );
          _errorLogger.logError(
            error: technicalError.toString(),
            operationName: operationName ?? 'Unknown Operation',
          );
          return technicalError;
      }
    }

    final unknownException = UnknownException(
      data: error.toString(),
    );
    _errorLogger.logError(
      error: unknownException.toString(),
      operationName: operationName ?? 'Unknown Operation',
    );
    return unknownException;
  }

  static String? _extractErrorMessage(dynamic data, int? statusCode) {
    if (data == null) return null;

    if (statusCode == 500) {
      return 'Server error occurred. Please contact support.';
    }

    if (data is Map) {
      const possibleFields = ['code', 'message', 'Message', 'error', 'title'];
      for (final field in possibleFields) {
        final value = data[field];
        if (value is String && value.isNotEmpty) {
          return value;
        }
      }
    }

    return null;
  }
}

class ApiHelper {
  const ApiHelper._();

  static Future<T> call<T>({
    required Future<Response<dynamic>> Function() apiCall,
    required Future<T> Function(Response<dynamic> response) successHandler,
    Future<T> Function(DioException response)? errorHandler,
    Future<T> Function(Response<dynamic> response)? inValideResponseHandler,
    required String operationName,
    bool Function(int? statusCode)? validateStatus,
  }) async {
    try {
      final response = await apiCall();
      final isValid = validateStatus?.call(response.statusCode) ??
          _defaultStatusValidator(response.statusCode);

      if (isValid) {
        return await successHandler(response);
      } else {
        if (inValideResponseHandler != null) {
          return await inValideResponseHandler(response);
        }
        throw ApiException(
          ExceptionHandler._extractErrorMessage(
                  response.data, response.statusCode) ??
              'Invalid response',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } catch (e) {
      if (errorHandler != null && e is DioException) {
        return await errorHandler(e);
      }
      throw ExceptionHandler.handle(e, operationName);
    }
  }

  static Future<void> voidCall({
    required Future<Response<dynamic>> Function() apiCall,
    required String operationName,
    Function(DioException response)? errorHandler,
    Future<void> Function(Response<dynamic> response)? inValideResponseHandler,
    bool Function(int? statusCode)? validateStatus,
  }) async {
    try {
      final response = await apiCall();
      final isValid = validateStatus?.call(response.statusCode) ??
          _defaultStatusValidator(response.statusCode);

      if (!isValid) {
        if (inValideResponseHandler != null) {
          await inValideResponseHandler(response);
          return;
        }
        throw ApiException(
          ExceptionHandler._extractErrorMessage(
                  response.data, response.statusCode) ??
              'Invalid response',
          statusCode: response.statusCode,
          data: response.data,
        );
      }
    } catch (e) {
      if (errorHandler != null && e is DioException) {
        errorHandler(e);
        return;
      }
      throw ExceptionHandler.handle(e, operationName);
    }
  }

  static bool _defaultStatusValidator(int? statusCode) {
    if (statusCode == null) return false;
    return statusCode >= 200 && statusCode < 300;
  }
}
