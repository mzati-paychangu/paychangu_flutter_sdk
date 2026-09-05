/// Exception thrown when a PayChangu API call fails.
class PayChanguException implements Exception {
  final String message;
  final String? details;
  final int? statusCode;
  final Object? cause;

  PayChanguException(
    this.message, {
    this.details,
    this.statusCode,
    this.cause,
  });

  @override
  String toString() {
    final buffer = StringBuffer('PayChanguException: $message');
    if (statusCode != null) buffer.write(' (HTTP $statusCode)');
    if (details != null && details!.isNotEmpty) {
      buffer.write('\nDetails: $details');
    }
    if (cause != null) {
      buffer.write('\nCause: $cause');
    }
    return buffer.toString();
  }
}
