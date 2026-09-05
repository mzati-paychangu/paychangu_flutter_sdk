import '../core/json_utils.dart';

/// Shared authorization block returned by many PayChangu endpoints.
class AuthorizationData {
  final String? channel;
  final String? cardNumber;
  final String? expiry;
  final String? brand;
  final String? provider;
  final String? mobileNumber;
  final String? payerBankUuid;
  final String? payerBank;
  final String? payerAccountNumber;
  final String? payerAccountName;
  final String? completedAt;

  const AuthorizationData({
    this.channel,
    this.cardNumber,
    this.expiry,
    this.brand,
    this.provider,
    this.mobileNumber,
    this.payerBankUuid,
    this.payerBank,
    this.payerAccountNumber,
    this.payerAccountName,
    this.completedAt,
  });

  factory AuthorizationData.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return AuthorizationData(
      channel: JsonUtils.asString(map['channel']),
      cardNumber: JsonUtils.asString(map['card_number']),
      expiry: JsonUtils.asString(map['expiry']),
      brand: JsonUtils.asString(map['brand']),
      provider: JsonUtils.asString(map['provider']),
      mobileNumber: JsonUtils.asString(map['mobile_number']),
      payerBankUuid: JsonUtils.asString(map['payer_bank_uuid']),
      payerBank: JsonUtils.asString(map['payer_bank']),
      payerAccountNumber: JsonUtils.asString(map['payer_account_number']),
      payerAccountName: JsonUtils.asString(map['payer_account_name']),
      completedAt: JsonUtils.asString(map['completed_at']),
    );
  }
}

/// Mobile money operator summary nested in charge/payout responses.
class MobileMoneyInfo {
  final String? name;
  final String? refId;
  final String? country;

  const MobileMoneyInfo({this.name, this.refId, this.country});

  factory MobileMoneyInfo.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return MobileMoneyInfo(
      name: JsonUtils.asString(map['name']),
      refId: JsonUtils.asString(map['ref_id']),
      country: JsonUtils.asString(map['country']),
    );
  }
}

/// Fee / charge amount block.
class TransactionCharges {
  final String? currency;
  final String? amount;

  const TransactionCharges({this.currency, this.amount});

  factory TransactionCharges.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return TransactionCharges(
      currency: JsonUtils.asString(map['currency']),
      amount: JsonUtils.asString(map['amount']),
    );
  }
}

/// Log entry from payment/payout responses.
class LogEntry {
  final String? type;
  final String? message;
  final String? createdAt;

  const LogEntry({this.type, this.message, this.createdAt});

  factory LogEntry.fromJson(Map<String, dynamic> json) {
    return LogEntry(
      type: JsonUtils.asString(json['type']),
      message: JsonUtils.asString(json['message']),
      createdAt: JsonUtils.asString(json['created_at']),
    );
  }
}

/// Customer block on checkout verification.
class CustomerData {
  final String? email;
  final String? firstName;
  final String? lastName;

  const CustomerData({this.email, this.firstName, this.lastName});

  factory CustomerData.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return CustomerData(
      email: JsonUtils.asString(map['email']),
      firstName: JsonUtils.asString(map['first_name']),
      lastName: JsonUtils.asString(map['last_name']),
    );
  }
}

/// Checkout customization block.
class CustomizationData {
  final String? title;
  final String? description;
  final String? logo;

  const CustomizationData({this.title, this.description, this.logo});

  factory CustomizationData.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return CustomizationData(
      title: JsonUtils.asString(map['title']),
      description: JsonUtils.asString(map['description']),
      logo: JsonUtils.asString(map['logo']),
    );
  }
}

/// Generic API envelope when data shape varies.
class ApiResponse {
  final String status;
  final String message;
  final dynamic data;
  final Map<String, dynamic> raw;

  const ApiResponse({
    required this.status,
    required this.message,
    this.data,
    required this.raw,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      data: json['data'],
      raw: json,
    );
  }

  Map<String, dynamic>? get dataAsMap => JsonUtils.asMap(data);

  List<dynamic> get dataAsList => JsonUtils.asList(data);
}
