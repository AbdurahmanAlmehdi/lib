abstract class ErrorLogger {
  const ErrorLogger();

  void logError({
    required String error,
    required String operationName,
    StackTrace? stackTrace,
  });
}

class DefaultErrorLogger implements ErrorLogger {
  const DefaultErrorLogger();

  @override
  void logError({
    required String error,
    required String operationName,
    StackTrace? stackTrace,
  }) {
    // Default implementation - print to console
    // In production, replace with your logging solution (Firebase Crashlytics, Sentry, etc.)
    print('[$operationName] Error: $error');
    if (stackTrace != null) {
      print('StackTrace: $stackTrace');
    }
  }
}
