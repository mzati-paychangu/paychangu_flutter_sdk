import 'enums.dart';

/// Hosted checkout payment request (`POST /payment`).
class PaymentRequest {
  final String? txRef;
  final String? firstName;
  final String? lastName;
  final String? email;
  final Currency currency;
  final num amount;
  final String callbackUrl;
  final String returnUrl;
  final Map<String, String>? customization;
  final dynamic meta;
  final String? uuid;

  PaymentRequest({
    this.txRef,
    this.firstName,
    this.lastName,
    this.email,
    required this.currency,
    required this.amount,
    required this.callbackUrl,
    required this.returnUrl,
    this.customization,
    this.meta,
    this.uuid,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount.toString(),
      'currency': currency.apiValue,
      'callback_url': callbackUrl,
      'return_url': returnUrl,
      if (txRef != null) 'tx_ref': txRef,
      if (firstName != null) 'first_name': firstName,
      if (lastName != null) 'last_name': lastName,
      if (email != null) 'email': email,
      if (customization != null) 'customization': customization,
      if (meta != null) 'meta': meta,
      if (uuid != null) 'uuid': uuid,
    };
  }
}
