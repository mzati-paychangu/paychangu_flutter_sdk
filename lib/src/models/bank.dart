import '../core/json_utils.dart';
import 'common.dart';
import 'enums.dart';

/// Bank transfer charge request (`POST /direct-charge/payments/initialize`).
class BankTransferChargeRequest {
  final String amount;
  final Currency currency;
  final String chargeId;
  final String paymentMethod;
  final String? email;
  final String? firstName;
  final String? lastName;
  final String? mobile;
  final bool? createPermanentAccount;

  const BankTransferChargeRequest({
    required this.amount,
    this.currency = Currency.MWK,
    required this.chargeId,
    this.paymentMethod = 'mobile_bank_transfer',
    this.email,
    this.firstName,
    this.lastName,
    this.mobile,
    this.createPermanentAccount,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount,
        'currency': currency.apiValue,
        'payment_method': paymentMethod,
        'charge_id': chargeId,
        if (email != null) 'email': email,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
        if (mobile != null) 'mobile': mobile,
        if (createPermanentAccount != null)
          'create_permanent_account': createPermanentAccount,
      };
}

class PaymentAccountDetails {
  final String? bankName;
  final String? accountNumber;
  final String? accountName;
  final int? accountExpirationTimestamp;

  const PaymentAccountDetails({
    this.bankName,
    this.accountNumber,
    this.accountName,
    this.accountExpirationTimestamp,
  });

  factory PaymentAccountDetails.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return PaymentAccountDetails(
      bankName: JsonUtils.asString(map['bank_name']),
      accountNumber: JsonUtils.asString(map['account_number']),
      accountName: JsonUtils.asString(map['account_name']),
      accountExpirationTimestamp:
          JsonUtils.asInt(map['account_expiration_timestamp']),
    );
  }
}

class BankTransferTransaction {
  final String? chargeId;
  final String? refId;
  final String? transId;
  final String? currency;
  final num? amount;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? type;
  final String? traceId;
  final String? status;
  final String? mobile;
  final int? attempts;
  final String? mode;
  final String? createdAt;
  final String? completedAt;
  final String? eventType;
  final TransactionCharges? transactionCharges;
  final AuthorizationData? authorization;
  final RecipientAccountDetails? recipientAccountDetails;
  final List<LogEntry> logs;

  const BankTransferTransaction({
    this.chargeId,
    this.refId,
    this.transId,
    this.currency,
    this.amount,
    this.firstName,
    this.lastName,
    this.email,
    this.type,
    this.traceId,
    this.status,
    this.mobile,
    this.attempts,
    this.mode,
    this.createdAt,
    this.completedAt,
    this.eventType,
    this.transactionCharges,
    this.authorization,
    this.recipientAccountDetails,
    this.logs = const [],
  });

  factory BankTransferTransaction.fromJson(Map<String, dynamic> json) {
    return BankTransferTransaction(
      chargeId: JsonUtils.asString(json['charge_id']),
      refId: JsonUtils.asString(json['ref_id']),
      transId: JsonUtils.asString(json['trans_id']),
      currency: JsonUtils.asString(json['currency']),
      amount: JsonUtils.asDouble(json['amount']) ?? JsonUtils.asInt(json['amount']),
      firstName: JsonUtils.asString(json['first_name']),
      lastName: JsonUtils.asString(json['last_name']),
      email: JsonUtils.asString(json['email']),
      type: JsonUtils.asString(json['type']),
      traceId: JsonUtils.asString(json['trace_id']),
      status: JsonUtils.asString(json['status']),
      mobile: JsonUtils.asString(json['mobile']),
      attempts: JsonUtils.asInt(json['attempts']),
      mode: JsonUtils.asString(json['mode']),
      createdAt: JsonUtils.asString(json['created_at']),
      completedAt: JsonUtils.asString(json['completed_at']),
      eventType: JsonUtils.asString(json['event_type']),
      transactionCharges: json['transaction_charges'] != null
          ? TransactionCharges.fromJson(
              JsonUtils.asMap(json['transaction_charges']),
            )
          : null,
      authorization: json['authorization'] != null
          ? AuthorizationData.fromJson(JsonUtils.asMap(json['authorization']))
          : null,
      recipientAccountDetails: json['recipient_account_details'] != null
          ? RecipientAccountDetails.fromJson(
              JsonUtils.asMap(json['recipient_account_details']),
            )
          : null,
      logs: JsonUtils.asList(json['logs'])
          .whereType<Map>()
          .map((e) => LogEntry.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class RecipientAccountDetails {
  final String? bankUuid;
  final String? bankName;
  final String? accountName;
  final String? accountNumber;

  const RecipientAccountDetails({
    this.bankUuid,
    this.bankName,
    this.accountName,
    this.accountNumber,
  });

  factory RecipientAccountDetails.fromJson(Map<String, dynamic>? json) {
    final map = json ?? const {};
    return RecipientAccountDetails(
      bankUuid: JsonUtils.asString(map['bank_uuid']),
      bankName: JsonUtils.asString(map['bank_name']),
      accountName: JsonUtils.asString(map['account_name']),
      accountNumber: JsonUtils.asString(map['account_number']),
    );
  }
}

class BankTransferInitResponse {
  final String status;
  final String message;
  final PaymentAccountDetails? paymentAccountDetails;
  final BankTransferTransaction? transaction;

  const BankTransferInitResponse({
    required this.status,
    required this.message,
    this.paymentAccountDetails,
    this.transaction,
  });

  factory BankTransferInitResponse.fromJson(Map<String, dynamic> json) {
    final data = JsonUtils.asMap(json['data']) ?? {};
    return BankTransferInitResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      paymentAccountDetails: data['payment_account_details'] != null
          ? PaymentAccountDetails.fromJson(
              JsonUtils.asMap(data['payment_account_details']),
            )
          : null,
      transaction: data['transaction'] != null
          ? BankTransferTransaction.fromJson(
              JsonUtils.asMap(data['transaction']) ?? {},
            )
          : null,
    );
  }
}

class BankTransferDetailsResponse {
  final String status;
  final String message;
  final BankTransferTransaction? transaction;

  const BankTransferDetailsResponse({
    required this.status,
    required this.message,
    this.transaction,
  });

  factory BankTransferDetailsResponse.fromJson(Map<String, dynamic> json) {
    final data = JsonUtils.asMap(json['data']) ?? {};
    final txMap = JsonUtils.asMap(data['transaction']) ?? data;
    return BankTransferDetailsResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      transaction: BankTransferTransaction.fromJson(txMap),
    );
  }
}

/// Bank for payouts (`GET /direct-charge/payouts/supported-banks`).
class Bank {
  final String? uuid;
  final String? name;

  const Bank({this.uuid, this.name});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      uuid: JsonUtils.asString(json['uuid']),
      name: JsonUtils.asString(json['name']),
    );
  }
}

class BanksResponse {
  final String status;
  final String message;
  final List<Bank> data;

  const BanksResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory BanksResponse.fromJson(Map<String, dynamic> json) {
    return BanksResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      data: JsonUtils.asList(json['data'])
          .whereType<Map>()
          .map((e) => Bank.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

/// Bank payout request (`POST /direct-charge/payouts/initialize`).
class BankPayoutRequest {
  final String bankUuid;
  final String amount;
  final String chargeId;
  final String bankAccountName;
  final String bankAccountNumber;
  final String payoutMethod;
  final String? email;
  final String? firstName;
  final String? lastName;

  const BankPayoutRequest({
    required this.bankUuid,
    required this.amount,
    required this.chargeId,
    required this.bankAccountName,
    required this.bankAccountNumber,
    this.payoutMethod = 'bank_transfer',
    this.email,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() => {
        'payout_method': payoutMethod,
        'bank_uuid': bankUuid,
        'amount': amount,
        'charge_id': chargeId,
        'bank_account_name': bankAccountName,
        'bank_account_number': bankAccountNumber,
        if (email != null) 'email': email,
        if (firstName != null) 'first_name': firstName,
        if (lastName != null) 'last_name': lastName,
      };
}

class BankPayoutResponse {
  final String status;
  final String message;
  final BankTransferTransaction? transaction;

  const BankPayoutResponse({
    required this.status,
    required this.message,
    this.transaction,
  });

  factory BankPayoutResponse.fromJson(Map<String, dynamic> json) {
    final data = JsonUtils.asMap(json['data']) ?? {};
    final tx = JsonUtils.asMap(data['transaction']) ?? data;
    return BankPayoutResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      transaction: BankTransferTransaction.fromJson(tx),
    );
  }
}

class BankPayoutListResponse {
  final String status;
  final String message;
  final int? currentPage;
  final int? totalPages;
  final int? perPage;
  final String? nextPageUrl;
  final List<BankTransferTransaction> transactions;

  const BankPayoutListResponse({
    required this.status,
    required this.message,
    this.currentPage,
    this.totalPages,
    this.perPage,
    this.nextPageUrl,
    this.transactions = const [],
  });

  factory BankPayoutListResponse.fromJson(Map<String, dynamic> json) {
    final data = JsonUtils.asMap(json['data']) ?? {};
    return BankPayoutListResponse(
      status: JsonUtils.asStringRequired(json['status']),
      message: JsonUtils.asStringRequired(json['message']),
      currentPage: JsonUtils.asInt(data['current_page']),
      totalPages: JsonUtils.asInt(data['total_pages']),
      perPage: JsonUtils.asInt(data['per_page']),
      nextPageUrl: JsonUtils.asString(data['next_page_url']),
      transactions: JsonUtils.asList(data['data'])
          .whereType<Map>()
          .map(
            (e) => BankTransferTransaction.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(),
    );
  }
}
