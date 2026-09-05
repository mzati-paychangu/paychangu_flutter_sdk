import '../core/json_utils.dart';
import 'enums.dart';

/// Card charge request (`POST /charge-card/payments`).
///
/// Prefer calling this from your server — card PAN data is PCI-sensitive.
class CardChargeRequest {
  final String cardNumber;
  final String expiry;
  final String cvv;
  final String cardholderName;
  final String amount;
  final Currency currency;
  final String chargeId;
  final String redirectUrl;
  final String? email;

  const CardChargeRequest({
    required this.cardNumber,
    required this.expiry,
    required this.cvv,
    required this.cardholderName,
    required this.amount,
    required this.currency,
    required this.chargeId,
    required this.redirectUrl,
    this.email,
  });

  Map<String, dynamic> toJson() => {
        'card_number': cardNumber,
        'expiry': expiry,
        'cvv': cvv,
        'cardholder_name': cardholderName,
        'amount': amount,
        'currency': currency.apiValue,
        'charge_id': chargeId,
        'redirect_url': redirectUrl,
        if (email != null) 'email': email,
      };
}

class CardChargeResponse {
  final bool success;
  final bool requires3dsAuth;
  final String? orderReference;
  final String? threeDsAuthLink;
  final Map<String, dynamic> raw;

  const CardChargeResponse({
    required this.success,
    required this.requires3dsAuth,
    this.orderReference,
    this.threeDsAuthLink,
    required this.raw,
  });

  factory CardChargeResponse.fromJson(Map<String, dynamic> json) {
    return CardChargeResponse(
      success: JsonUtils.asBool(json['success']) ??
          json['status']?.toString().toLowerCase() == 'success',
      requires3dsAuth: JsonUtils.asBool(json['requires_3ds_auth']) ?? false,
      orderReference: JsonUtils.asString(json['orderReference']) ??
          JsonUtils.asString(json['order_reference']),
      threeDsAuthLink: JsonUtils.asString(json['3ds_auth_link']) ??
          JsonUtils.asString(json['three_ds_auth_link']),
      raw: json,
    );
  }
}
