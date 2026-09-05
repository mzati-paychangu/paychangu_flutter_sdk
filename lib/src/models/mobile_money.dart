import '../core/json_utils.dart';
import 'common.dart';

/// Mobile money operator from `GET /mobile-money`.
class MobileMoneyOperator {
  final int? id;
  final String? name;
  final String? refId;
  final String? shortCode;
  final String? logo;
  final bool? supportsWithdrawals;
  final String? countryName;
  final String? countryCurrency;

  const MobileMoneyOperator({
    this.id,
    this.name,
    this.refId,
    this.shortCode,
    this.logo,
    this.supportsWithdrawals,
    this.countryName,
    this.countryCurrency,
  });

  factory MobileMoneyOperator.fromJson(Map<String, dynamic> json) {
    final country = JsonUtils.asMap(json['supported_country']);
    return MobileMoneyOperator(
      id: JsonUtils.asInt(json['id']),
      name: JsonUtils.asString(json['name']),
      refId: JsonUtils.asString(json['ref_id']),
      shortCode: JsonUtils.asString(json['short_code']),
      logo: JsonUtils.asString(json['logo']),
      supportsWithdrawals: JsonUtils.asBool(json['supports_withdrawals']),
      countryName: JsonUtils.asString(country?['name']),
      countryCurrency: JsonUtils.asString(country?['currency']),
    );
  }
}

class MobileMoneyOperatorsResponse {
  final String status;
  final String message;
  final List<MobileMoneyOperator> data;

  const MobileMoneyOperatorsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MobileMoneyOperatorsResponse.fromJson(Map<String, dynamic> json) {
    return MobileMoneyOperatorsResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      data: JsonUtils.asList(json['data'])
          .whereType<Map>()
          .map((e) => MobileMoneyOperator.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

/// Direct MoMo charge request (`POST /mobile-money/payments/initialize`).
class MobileMoneyChargeRequest {
  final String mobile;
  final String mobileMoneyOperatorRefId;
  final String amount;
  final String chargeId;
  final String? email;
  final String? firstName;
  final String? lastName;

  const MobileMoneyChargeRequest({
    required this.mobile,
    required this.mobileMoneyOperatorRefId,
    required this.amount,
    required this.chargeId,
    this.email,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() => {
        'mobile': mobile,
        'mobile_money_operator_ref_id': mobileMoneyOperatorRefId,
        'amount': amount,
        'charge_id': chargeId,
        if (email != null) 'email': email,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
      };
}

/// MoMo payout request (`POST /mobile-money/payouts/initialize`).
class MobileMoneyPayoutRequest {
  final String mobile;
  final String mobileMoneyOperatorRefId;
  final String amount;
  final String chargeId;
  final String? email;
  final String? firstName;
  final String? lastName;

  /// Sandbox only: `successful` or `failed`.
  final String? transactionStatus;

  const MobileMoneyPayoutRequest({
    required this.mobile,
    required this.mobileMoneyOperatorRefId,
    required this.amount,
    required this.chargeId,
    this.email,
    this.firstName,
    this.lastName,
    this.transactionStatus,
  });

  Map<String, dynamic> toJson() => {
        'mobile': mobile,
        'mobile_money_operator_ref_id': mobileMoneyOperatorRefId,
        'amount': amount,
        'charge_id': chargeId,
        if (email != null) 'email': email,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (transactionStatus != null) 'transaction_status': transactionStatus,
      };
}

/// Shared charge/payout transaction payload for mobile money.
class MobileMoneyTransaction {
  final num? amount;
  final String? chargeId;
  final String? refId;
  final String? transId;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? type;
  final String? traceId;
  final String? status;
  final String? mobile;
  final int? attempts;
  final String? currency;
  final String? mode;
  final String? createdAt;
  final String? completedAt;
  final String? eventType;
  final MobileMoneyInfo? mobileMoney;
  final TransactionCharges? transactionCharges;
  final AuthorizationData? authorization;
  final List<LogEntry> logs;

  const MobileMoneyTransaction({
    this.amount,
    this.chargeId,
    this.refId,
    this.transId,
    this.firstName,
    this.lastName,
    this.email,
    this.type,
    this.traceId,
    this.status,
    this.mobile,
    this.attempts,
    this.currency,
    this.mode,
    this.createdAt,
    this.completedAt,
    this.eventType,
    this.mobileMoney,
    this.transactionCharges,
    this.authorization,
    this.logs = const [],
  });

  factory MobileMoneyTransaction.fromJson(Map<String, dynamic> json) {
    return MobileMoneyTransaction(
      amount: JsonUtils.asDouble(json['amount']) ?? JsonUtils.asInt(json['amount']),
      chargeId: JsonUtils.asString(json['charge_id']),
      refId: JsonUtils.asString(json['ref_id']),
      transId: JsonUtils.asString(json['trans_id']),
      firstName: JsonUtils.asString(json['first_name']),
      lastName: JsonUtils.asString(json['last_name']),
      email: JsonUtils.asString(json['email']),
      type: JsonUtils.asString(json['type']),
      traceId: JsonUtils.asString(json['trace_id']),
      status: JsonUtils.asString(json['status']),
      mobile: JsonUtils.asString(json['mobile']),
      attempts: JsonUtils.asInt(json['attempts']),
      currency: JsonUtils.asString(json['currency']),
      mode: JsonUtils.asString(json['mode']),
      createdAt: JsonUtils.asString(json['created_at']),
      completedAt: JsonUtils.asString(json['completed_at']),
      eventType: JsonUtils.asString(json['event_type']),
      mobileMoney: json['mobile_money'] != null
          ? MobileMoneyInfo.fromJson(JsonUtils.asMap(json['mobile_money']))
          : null,
      transactionCharges: json['transaction_charges'] != null
          ? TransactionCharges.fromJson(
              JsonUtils.asMap(json['transaction_charges']),
            )
          : null,
      authorization: json['authorization'] != null
          ? AuthorizationData.fromJson(JsonUtils.asMap(json['authorization']))
          : null,
      logs: JsonUtils.asList(json['logs'])
          .whereType<Map>()
          .map((e) => LogEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class MobileMoneyTransactionResponse {
  final String status;
  final String message;
  final MobileMoneyTransaction data;

  const MobileMoneyTransactionResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MobileMoneyTransactionResponse.fromJson(Map<String, dynamic> json) {
    return MobileMoneyTransactionResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      data: MobileMoneyTransaction.fromJson(JsonUtils.asMap(json['data']) ?? {}),
    );
  }
}
