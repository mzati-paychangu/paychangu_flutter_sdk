import '../core/paychangu_client.dart';
import '../models/checkout.dart';
import '../models/payment_request.dart';

/// Hosted checkout APIs.
class CheckoutApi {
  final PayChanguClient _client;

  CheckoutApi(this._client);

  /// `POST /payment`
  Future<PaymentSessionResponse> initiatePayment(PaymentRequest request) async {
    final json = await _client.post('/payment', body: request.toJson());
    return PaymentSessionResponse.fromJson(json);
  }

  /// `GET /verify-payment/{tx_ref}`
  Future<PaymentVerificationResponse> verifyTransaction(String txRef) async {
    final json = await _client.get('/verify-payment/$txRef');
    return PaymentVerificationResponse.fromJson(json);
  }

  /// Client-side sanity check after verification.
  bool validatePayment(
    PaymentVerificationResponse verification, {
    required String expectedTxRef,
    required String expectedCurrency,
    required num expectedAmount,
  }) {
    final data = verification.data;
    final amount = data.amount ?? 0;
    return data.status == 'success' &&
        data.txRef == expectedTxRef &&
        (data.currency?.toUpperCase() == expectedCurrency.toUpperCase() ||
            (expectedCurrency.toUpperCase() == 'MWK' &&
                data.currency?.toUpperCase() == 'MK')) &&
        amount >= expectedAmount;
  }
}
