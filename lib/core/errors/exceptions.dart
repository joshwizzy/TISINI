sealed class AppException implements Exception {
  const AppException(this.message, {this.code});

  final String message;
  final String? code;

  @override
  String toString() => 'AppException($code): $message';
}

// Network-level
class NetworkException extends AppException {
  const NetworkException(super.message, {super.code});
}

class TimeoutException extends NetworkException {
  const TimeoutException() : super('Request timed out', code: 'TIMEOUT');
}

class NoConnectionException extends NetworkException {
  const NoConnectionException()
    : super('No internet connection', code: 'NO_CONNECTION');
}

// Server-level (API returned an error)
class ServerException extends AppException {
  const ServerException(
    super.message, {
    required this.statusCode,
    super.code,
    this.details,
  });

  final int statusCode;
  final Map<String, dynamic>? details;
}

// Business logic
class BusinessException extends AppException {
  const BusinessException(super.message, {super.code});
}

class InsufficientBalanceException extends BusinessException {
  const InsufficientBalanceException()
    : super('Insufficient balance', code: 'INSUFFICIENT_BALANCE');
}

class KycRequiredException extends BusinessException {
  const KycRequiredException()
    : super('Identity verification required', code: 'KYC_REQUIRED');
}

class PaymentFailedException extends BusinessException {
  const PaymentFailedException({this.reason})
    : super('Payment failed', code: 'PAYMENT_FAILED');

  final String? reason;
}

// Validation
class ValidationException extends AppException {
  const ValidationException(
    super.message, {
    required this.fieldErrors,
    super.code,
  });

  final Map<String, String> fieldErrors;
}

// Auth
class AuthException extends AppException {
  const AuthException(super.message, {super.code});
}

class SessionExpiredException extends AuthException {
  const SessionExpiredException()
    : super('Session expired', code: 'AUTH_REFRESH_FAILED');
}
