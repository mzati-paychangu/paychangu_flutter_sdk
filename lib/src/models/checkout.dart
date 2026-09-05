import '../core/json_utils.dart';
import 'common.dart';

/// Response from `POST /payment`.
class PaymentSessionResponse {
  final String status;
  final String message;
  final PaymentSessionData data;

  const PaymentSessionResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PaymentSessionResponse.fromJson(Map<String, dynamic> json) {
    return PaymentSessionResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      data: PaymentSessionData.fromJson(JsonUtils.asMap(json['data']) ?? {}),
    );
  }
}

class PaymentSessionData {
  final String? event;
  final String checkoutUrl;
  final PaymentSessionDetails? details;

  const PaymentSessionData({
    this.event,
    required this.checkoutUrl,
    this.details,
  });

  factory PaymentSessionData.fromJson(Map<String, dynamic> json) {
    return PaymentSessionData(
      event: JsonUtils.asString(json['event']),
      checkoutUrl: JsonUtils.asStringRequired(json['checkout_url']),
      details: json['data'] != null
          ? PaymentSessionDetails.fromJson(JsonUtils.asMap(json['data']) ?? {})
          : null,
    );
  }
}

class PaymentSessionDetails {
  final String? txRef;
  final String? currency;
  final num? amount;
  final String? mode;
  final String? status;

  const PaymentSessionDetails({
    this.txRef,
    this.currency,
    this.amount,
    this.mode,
    this.status,
  });

  factory PaymentSessionDetails.fromJson(Map<String, dynamic> json) {
    return PaymentSessionDetails(
      txRef: JsonUtils.asString(json['tx_ref']),
      currency: JsonUtils.asString(json['currency']),
      amount: JsonUtils.asDouble(json['amount']) ?? JsonUtils.asInt(json['amount']),
      mode: JsonUtils.asString(json['mode']),
      status: JsonUtils.asString(json['status']),
    );
  }
}

/// Response from `GET /verify-payment/{tx_ref}`.
class PaymentVerificationResponse {
  final String status;
  final String message;
  final VerificationData data;

  const PaymentVerificationResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory PaymentVerificationResponse.fromJson(Map<String, dynamic> json) {
    return PaymentVerificationResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      data: VerificationData.fromJson(JsonUtils.asMap(json['data']) ?? {}),
    );
  }
}

class VerificationData {
  final String? eventType;
  final String? txRef;
  final String? mode;
  final String? type;
  final String? status;
  final int? numberOfAttempts;
  final String? reference;
  final String? currency;
  final num? amount;
  final num? charges;
  final CustomizationData? customization;
  final dynamic meta;
  final AuthorizationData? authorization;
  final CustomerData? customer;
  final List<LogEntry> logs;
  final String? createdAt;
  final String? updatedAt;

  const VerificationData({
    this.eventType,
    this.txRef,
    this.mode,
    this.type,
    this.status,
    this.numberOfAttempts,
    this.reference,
    this.currency,
    this.amount,
    this.charges,
    this.customization,
    this.meta,
    this.authorization,
    this.customer,
    this.logs = const [],
    this.createdAt,
    this.updatedAt,
  });

  factory VerificationData.fromJson(Map<String, dynamic> json) {
    return VerificationData(
      eventType: JsonUtils.asString(json['event_type']),
      txRef: JsonUtils.asString(json['tx_ref']),
      mode: JsonUtils.asString(json['mode']),
      type: JsonUtils.asString(json['type']),
      status: JsonUtils.asString(json['status']),
      numberOfAttempts: JsonUtils.asInt(json['number_of_attempts']),
      reference: JsonUtils.asString(json['reference']),
      currency: JsonUtils.asString(json['currency']),
      amount: JsonUtils.asDouble(json['amount']) ?? JsonUtils.asInt(json['amount']),
      charges:
          JsonUtils.asDouble(json['charges']) ?? JsonUtils.asInt(json['charges']),
      customization: json['customization'] != null
          ? CustomizationData.fromJson(JsonUtils.asMap(json['customization']))
          : null,
      meta: json['meta'],
      authorization: json['authorization'] != null
          ? AuthorizationData.fromJson(JsonUtils.asMap(json['authorization']))
          : null,
      customer: json['customer'] != null
          ? CustomerData.fromJson(JsonUtils.asMap(json['customer']))
          : null,
      logs: JsonUtils.asList(json['logs'])
          .whereType<Map>()
          .map((e) => LogEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      createdAt: JsonUtils.asString(json['created_at']),
      updatedAt: JsonUtils.asString(json['updated_at']),
    );
  }
}
