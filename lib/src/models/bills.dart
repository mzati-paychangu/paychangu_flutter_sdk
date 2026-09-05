import '../core/json_utils.dart';
import 'common.dart';

/// Bill payment / airtime request models and resilient responses.

class ValidateBillRequest {
  final String biller;
  final String account;
  final String? accountType;
  final String? amount;

  const ValidateBillRequest({
    required this.biller,
    required this.account,
    this.accountType,
    this.amount,
  });

  Map<String, dynamic> toJson() => {
        'biller': biller,
        'account': account,
        if (accountType != null) 'account_type': accountType,
        if (amount != null) 'amount': amount,
      };
}

class PayBillRequest {
  final String biller;
  final String account;
  final String? amount;
  final String? customerName;
  final String? accountType;
  final String? reference;

  const PayBillRequest({
    required this.biller,
    required this.account,
    this.amount,
    this.customerName,
    this.accountType,
    this.reference,
  });

  Map<String, dynamic> toJson() => {
        'biller': biller,
        'account': account,
        if (amount != null) 'amount': amount,
        if (customerName != null) 'customer_name': customerName,
        if (accountType != null) 'account_type': accountType,
        if (reference != null) 'reference': reference,
      };
}

class AirtimeRechargeRequest {
  final String phone;
  final String amount;
  final String? reference;

  const AirtimeRechargeRequest({
    required this.phone,
    required this.amount,
    this.reference,
  });

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'amount': amount,
        if (reference != null) 'reference': reference,
      };
}

/// Generic bills envelope — official schemas are sparse.
class BillsApiResponse {
  final String status;
  final String message;
  final dynamic data;
  final Map<String, dynamic> raw;

  const BillsApiResponse({
    required this.status,
    required this.message,
    this.data,
    required this.raw,
  });

  factory BillsApiResponse.fromJson(Map<String, dynamic> json) {
    return BillsApiResponse(
      status: JsonUtils.asStringRequired(json['status'], 'success'),
      message: JsonUtils.asStringRequired(json['message']),
      data: json['data'] ?? json,
      raw: json,
    );
  }

  Map<String, dynamic>? get dataAsMap => JsonUtils.asMap(data);

  List<dynamic> get dataAsList => JsonUtils.asList(data);
}

/// Re-export helper for consumers that only import bills models.
typedef GenericApiResponse = ApiResponse;
