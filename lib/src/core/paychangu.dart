import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../api/bank_transfer_api.dart';
import '../api/bills_api.dart';
import '../api/card_api.dart';
import '../api/checkout_api.dart';
import '../api/connect_api.dart';
import '../api/mobile_money_api.dart';
import '../api/payouts_api.dart';
import '../api/virtual_accounts_api.dart';
import '../config/paychangu_config.dart';
import '../models/balance.dart';
import '../models/bank.dart';
import '../models/card.dart';
import '../models/checkout.dart';
import '../models/common.dart';
import '../models/connect_virtual.dart';
import '../models/enums.dart';
import '../models/mobile_money.dart';
import '../models/payment_request.dart';
import '../models/bills.dart';
import '../widgets/paychangu_webview.dart';
import 'paychangu_client.dart';

/// Main PayChangu SDK facade.
///
/// Domain APIs are also available as properties (`checkout`, `mobileMoney`, …)
/// for clearer namespacing.
class PayChangu {
  final PayChanguConfig config;
  late final PayChanguClient _client;

  late final CheckoutApi checkout;
  late final MobileMoneyApi mobileMoney;
  late final BankTransferApi bankTransfer;
  late final CardApi card;
  late final MobileMoneyPayoutApi mobileMoneyPayouts;
  late final PayoutsApi bankPayouts;
  late final BillsApi bills;
  late final ConnectApi connect;
  late final VirtualAccountsApi virtualAccounts;

  PayChangu(
    this.config, {
    http.Client? httpClient,
  }) {
    _client = PayChanguClient(config: config, httpClient: httpClient);
    checkout = CheckoutApi(_client);
    mobileMoney = MobileMoneyApi(_client);
    bankTransfer = BankTransferApi(_client);
    card = CardApi(_client);
    mobileMoneyPayouts = MobileMoneyPayoutApi(_client);
    bankPayouts = PayoutsApi(_client);
    bills = BillsApi(_client);
    connect = ConnectApi(_client);
    virtualAccounts = VirtualAccountsApi(_client);
  }

  // --- Checkout convenience methods ---

  Future<PaymentSessionResponse> initiatePayment(PaymentRequest request) =>
      checkout.initiatePayment(request);

  Future<PaymentVerificationResponse> verifyTransaction(String txRef) =>
      checkout.verifyTransaction(txRef);

  bool validatePayment(
    PaymentVerificationResponse verification, {
    required String expectedTxRef,
    required String expectedCurrency,
    required num expectedAmount,
  }) =>
      checkout.validatePayment(
        verification,
        expectedTxRef: expectedTxRef,
        expectedCurrency: expectedCurrency,
        expectedAmount: expectedAmount,
      );

  /// Hosted checkout WebView widget.
  Widget launchPayment({
    required PaymentRequest request,
    required void Function(Map<String, dynamic> params) onSuccess,
    required void Function(String error) onError,
    required void Function() onCancel,
    bool autoVerify = false,
    void Function(PaymentVerificationResponse verification)? onVerified,
  }) {
    return PayChanguWebView(
      request: request,
      paychangu: this,
      onSuccess: onSuccess,
      onError: onError,
      onCancel: onCancel,
      autoVerify: autoVerify,
      onVerified: onVerified,
    );
  }

  /// 3DS authentication WebView for card charges that require it.
  Widget launch3dsAuth({
    required String authUrl,
    required String redirectUrl,
    required void Function(Map<String, dynamic> params) onComplete,
    required void Function(String error) onError,
  }) {
    return PayChangu3dsWebView(
      authUrl: authUrl,
      redirectUrl: redirectUrl,
      onComplete: onComplete,
      onError: onError,
    );
  }

  // --- Mobile money ---

  Future<MobileMoneyOperatorsResponse> getMobileMoneyOperators() =>
      mobileMoney.getOperators();

  Future<MobileMoneyTransactionResponse> chargeMobileMoney(
    MobileMoneyChargeRequest request,
  ) =>
      mobileMoney.charge(request);

  Future<MobileMoneyTransactionResponse> verifyMobileMoneyCharge(
    String chargeId,
  ) =>
      mobileMoney.verifyCharge(chargeId);

  Future<MobileMoneyTransactionResponse> getMobileMoneyChargeDetails(
    String chargeId,
  ) =>
      mobileMoney.getChargeDetails(chargeId);

  Future<WalletBalanceResponse> getBalance({Currency currency = Currency.MWK}) =>
      mobileMoney.getBalance(currency: currency);

  // --- Bank transfer ---

  Future<BankTransferInitResponse> initializeBankTransfer(
    BankTransferChargeRequest request,
  ) =>
      bankTransfer.initialize(request);

  Future<BankTransferDetailsResponse> getBankTransferDetails(String chargeId) =>
      bankTransfer.getDetails(chargeId);

  // --- Card ---

  Future<CardChargeResponse> chargeCard(CardChargeRequest request) =>
      card.charge(request);

  Future<ApiResponse> verifyCardCharge(String chargeId) => card.verify(chargeId);

  Future<ApiResponse> refundCardCharge(String chargeId) => card.refund(chargeId);

  // --- MoMo payouts ---

  Future<MobileMoneyTransactionResponse> initiateMobileMoneyPayout(
    MobileMoneyPayoutRequest request,
  ) =>
      mobileMoneyPayouts.initialize(request);

  /// Deprecated name kept for migration from 0.0.x.
  @Deprecated('Use initiateMobileMoneyPayout')
  Future<MobileMoneyTransactionResponse> initiateMobileMoneyTransfer(
    MobileMoneyPayoutRequest request,
  ) =>
      initiateMobileMoneyPayout(request);

  Future<MobileMoneyTransactionResponse> getMobileMoneyPayoutDetails(
    String chargeId,
  ) =>
      mobileMoneyPayouts.getDetails(chargeId);

  /// Deprecated name kept for migration from 0.0.x.
  @Deprecated('Use getMobileMoneyPayoutDetails')
  Future<MobileMoneyTransactionResponse> getTransferStatus(String chargeId) =>
      getMobileMoneyPayoutDetails(chargeId);

  // --- Bank payouts ---

  Future<BanksResponse> getBanks({Currency currency = Currency.MWK}) =>
      bankPayouts.getBanks(currency: currency);

  Future<BankPayoutResponse> initiateBankPayout(BankPayoutRequest request) =>
      bankPayouts.initializeBankPayout(request);

  Future<BankPayoutResponse> getBankPayoutDetails(String chargeId) =>
      bankPayouts.getBankPayoutDetails(chargeId);

  Future<BankPayoutListResponse> listBankPayouts() =>
      bankPayouts.listBankPayouts();

  // --- Bills ---

  Future<BillsApiResponse> getBillers() => bills.getBillers();

  Future<BillsApiResponse> getBillerDetails(String billerId) =>
      bills.getBillerDetails(billerId);

  Future<BillsApiResponse> validateBill(ValidateBillRequest request) =>
      bills.validateBill(request);

  Future<BillsApiResponse> payBill(PayBillRequest request) =>
      bills.payBill(request);

  Future<BillsApiResponse> buyAirtime(AirtimeRechargeRequest request) =>
      bills.buyAirtime(request);

  Future<BillsApiResponse> getBillTransaction(String reference) =>
      bills.getBillTransaction(reference);

  Future<BillsApiResponse> getBillStatistics() => bills.getStatistics();

  // --- Connect ---

  Future<ConnectAuthorizeResponse> createConnectLink(
    ConnectAuthorizeRequest request,
  ) =>
      connect.createAuthorizeLink(request);

  Future<ConnectUserResponse> getConnectUser({String? accessToken}) =>
      connect.getUser(accessToken: accessToken);

  Future<ApiResponse> revokeConnectToken(String token) =>
      connect.revokeToken(token);

  // --- Virtual accounts ---

  Future<VirtualCustomerResponse> createVirtualCustomer(
    VirtualCustomerRequest request,
  ) =>
      virtualAccounts.createCustomer(request);

  Future<ApiResponse> listVirtualCustomers({int? page, int? perPage}) =>
      virtualAccounts.listCustomers(page: page, perPage: perPage);

  Future<VirtualCustomerResponse> getVirtualCustomer(String customerId) =>
      virtualAccounts.getCustomer(customerId);

  Future<VirtualCustomerResponse> updateVirtualCustomer(
    String customerId,
    VirtualCustomerRequest request,
  ) =>
      virtualAccounts.updateCustomer(customerId, request);

  Future<ApiResponse> deleteVirtualCustomer(String customerId) =>
      virtualAccounts.deleteCustomer(customerId);

  Future<ApiResponse> createUsAccount(String customerId) =>
      virtualAccounts.createUsAccount(customerId);

  Future<ApiResponse> deactivateUsAccount(String customerId) =>
      virtualAccounts.deactivateUsAccount(customerId);

  Future<ApiResponse> reactivateUsAccount(String customerId) =>
      virtualAccounts.reactivateUsAccount(customerId);

  Future<ApiResponse> getUsAccountActivity(String customerId) =>
      virtualAccounts.getUsAccountActivity(customerId);

  void close() => _client.close();
}
