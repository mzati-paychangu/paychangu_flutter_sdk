# PayChangu Flutter SDK

Flutter/Dart client for [PayChangu](https://developer.paychangu.com) — accept payments in Malawi (hosted checkout, mobile money, bank transfer, cards), send payouts, pay bills, and use Connect / US virtual accounts.

**Current version:** `1.0.0`  
**API docs:** [developer.paychangu.com](https://developer.paychangu.com/reference/introduction)

## Install

```yaml
dependencies:
  paychangu_flutter: ^1.0.0
```

```bash
flutter pub get
```

## Before you start

1. Create a merchant account and grab a **sandbox secret key** from [API keys](https://developer.paychangu.com/docs/api-keys).
2. Decide where the secret key lives:
   - **Hosted checkout** — many apps call `POST /payment` from the device (same pattern as this SDK’s WebView).
   - **Payouts, card PAN charges, bills** — call these from **your backend**. Do not ship a live secret key in a production mobile binary for those flows.
3. Always **verify** successful payments with `verifyTransaction` (or your server) before fulfilling an order.

## 5-minute hosted checkout

```dart
import 'package:flutter/material.dart';
import 'package:paychangu_flutter/paychangu_flutter.dart';

final paychangu = PayChangu(
  PayChanguConfig(
    secretKey: const String.fromEnvironment('PAYCHANGU_SECRET_KEY'),
    isTestMode: true,
  ),
);

final request = PaymentRequest(
  txRef: 'order-${DateTime.now().millisecondsSinceEpoch}',
  firstName: 'John',
  lastName: 'Doe',
  email: 'john@example.com',
  currency: Currency.MWK,
  amount: 1000,
  callbackUrl: 'https://your-app.com/callback',
  returnUrl: 'https://your-app.com/return',
  customization: const {
    'title': 'My Shop',
    'description': 'Order #123',
  },
);

// Push a full-screen route:
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: const Text('Pay')),
      body: paychangu.launchPayment(
        request: request,
        autoVerify: true,
        onSuccess: (params) {
          // Redirect query params — still verify on your server
        },
        onError: (error) {},
        onCancel: () {},
        onVerified: (verification) {
          // SDK re-queried GET /verify-payment/{tx_ref}
        },
      ),
    ),
  ),
);
```

### Verify manually

```dart
final verification = await paychangu.verifyTransaction(txRef);

final ok = paychangu.validatePayment(
  verification,
  expectedTxRef: txRef,
  expectedCurrency: 'MWK',
  expectedAmount: 1000,
);
```

## Direct mobile money (no WebView)

```dart
final operators = await paychangu.getMobileMoneyOperators();
final airtel = operators.data.firstWhere((o) => o.shortCode == 'airtel');

final charge = await paychangu.chargeMobileMoney(
  MobileMoneyChargeRequest(
    mobile: '265991234567',
    mobileMoneyOperatorRefId: airtel.refId!,
    amount: '500',
    chargeId: 'charge-${DateTime.now().millisecondsSinceEpoch}',
  ),
);

// Customer approves on their phone, then:
final status = await paychangu.verifyMobileMoneyCharge(charge.data.chargeId!);
```

## Library map

| Need | Use |
|------|-----|
| Hosted checkout | `initiatePayment`, `launchPayment`, `verifyTransaction` |
| Wallet balance | `getBalance` |
| MoMo collect | `getMobileMoneyOperators`, `chargeMobileMoney`, `verifyMobileMoneyCharge` |
| Bank transfer collect | `initializeBankTransfer`, `getBankTransferDetails` |
| Card (+ 3DS UI) | `chargeCard`, `launch3dsAuth`, `verifyCardCharge`, `refundCardCharge` |
| MoMo payout | `initiateMobileMoneyPayout`, `getMobileMoneyPayoutDetails` |
| Bank payout | `getBanks`, `initiateBankPayout`, `getBankPayoutDetails` |
| Bills / airtime | `getBillers`, `validateBill`, `payBill`, `buyAirtime`, … |
| Connect | `createConnectLink`, `getConnectUser`, `revokeConnectToken` |
| US virtual accounts | `createVirtualCustomer`, `createUsAccount`, … |
| Webhooks (Dart server) | `PayChanguWebhooks.verify` |

Namespaced APIs are also available: `paychangu.checkout`, `.mobileMoney`, `.bankTransfer`, `.card`, `.mobileMoneyPayouts`, `.bankPayouts`, `.bills`, `.connect`, `.virtualAccounts`.

## Configuration

```dart
PayChanguConfig(
  secretKey: '…',
  isTestMode: true, // documentation flag; live/sandbox follows the key
  baseUrl: 'https://api.paychangu.com', // override for proxies/mocks
  timeout: Duration(seconds: 30),
);

// Inject a custom http.Client for tests:
PayChangu(config, httpClient: mockClient);
```

## Webhooks

```dart
final valid = PayChanguWebhooks.verify(
  rawBody: rawBodyString,
  signatureHeader: headers['Signature']!,
  webhookSecret: dashboardWebhookSecret,
);
```

## Error handling

```dart
try {
  await paychangu.initiatePayment(request);
} on PayChanguException catch (e) {
  // e.message, e.statusCode, e.details, e.cause
}
```

## Migration from 0.0.x

- Version **1.0.0** is breaking.
- `initiatePayment` returns `PaymentSessionResponse` (not `Map`).
- MoMo payout fields: `mobile`, `mobileMoneyOperatorRefId`, `chargeId` (replaces `phoneNumber` / `provider` / `reference`).
- Prefer `initiateMobileMoneyPayout` over deprecated `initiateMobileMoneyTransfer`.

## Links

- [API introduction](https://developer.paychangu.com/reference/introduction)
- [Standard checkout guide](https://developer.paychangu.com/docs/standard-checkout)
- [Transaction verification](https://developer.paychangu.com/docs/transaction-verification)
- [Webhooks](https://developer.paychangu.com/docs/webhooks)
- [Errors](https://developer.paychangu.com/docs/paychangu-errors)

## License

MIT
