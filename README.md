# PayChangu Flutter SDK

Flutter/Dart client for the [PayChangu API](https://developer.paychangu.com/reference/introduction). Accept payments in Malawi via hosted checkout, direct mobile money, bank transfer, and cards; send payouts; pay bills; use Connect and US virtual accounts.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- Hosted checkout WebView with callback / return handling and optional auto-verify
- Typed clients for the full PayChangu REST surface (collections, payouts, bills, Connect, virtual accounts)
- Injectable HTTP client for tests and proxies
- Webhook HMAC-SHA256 verification helper
- Direct MoMo charge + operators + wallet balance
- Bank transfer collection and bank / MoMo payouts
- Card charge with 3DS WebView helper

## Installation

```yaml
dependencies:
  paychangu_flutter: ^1.0.0
```

```bash
flutter pub get
```

## Security

- Hosted checkout may use a secret key from the app for `POST /payment` (common pattern).
- **Do not** ship secret keys in production apps for payouts, card PAN charges, or bill payments. Call those APIs from your backend and have the Flutter app talk to your server.
- Always re-verify successful payments with `verifyTransaction` (or your server) before fulfilling orders.
- Verify webhooks with `PayChanguWebhooks.verify` using your dashboard webhook secret.

## Quick start — hosted checkout

```dart
import 'package:paychangu_flutter/paychangu_flutter.dart';

final paychangu = PayChangu(
  PayChanguConfig(
    secretKey: 'your_secret_key',
    isTestMode: true,
  ),
);

final request = PaymentRequest(
  txRef: 'unique-tx-ref',
  firstName: 'John',
  lastName: 'Doe',
  email: 'john@example.com',
  currency: Currency.MWK,
  amount: 1000,
  callbackUrl: 'https://your-domain.com/callback',
  returnUrl: 'https://your-domain.com/return',
);

// In a widget:
paychangu.launchPayment(
  request: request,
  autoVerify: true,
  onSuccess: (params) { /* query params from redirect */ },
  onError: (error) {},
  onCancel: () {},
  onVerified: (verification) {
    // Prefer trusting this after server-side verify as well
  },
);
```

### Verify a transaction

```dart
final verification = await paychangu.verifyTransaction('unique-tx-ref');
final ok = paychangu.validatePayment(
  verification,
  expectedTxRef: 'unique-tx-ref',
  expectedCurrency: 'MWK',
  expectedAmount: 1000,
);
```

## API overview

| Area | Entry points |
|------|----------------|
| Checkout | `initiatePayment`, `verifyTransaction`, `launchPayment` |
| Balance | `getBalance` |
| Mobile money collect | `getMobileMoneyOperators`, `chargeMobileMoney`, `verifyMobileMoneyCharge`, `getMobileMoneyChargeDetails` |
| Bank transfer | `initializeBankTransfer`, `getBankTransferDetails` |
| Card | `chargeCard`, `verifyCardCharge`, `refundCardCharge`, `launch3dsAuth` |
| MoMo payout | `initiateMobileMoneyPayout`, `getMobileMoneyPayoutDetails` |
| Bank payout | `getBanks`, `initiateBankPayout`, `getBankPayoutDetails`, `listBankPayouts` |
| Bills | `getBillers`, `getBillerDetails`, `validateBill`, `payBill`, `buyAirtime`, `getBillTransaction`, `getBillStatistics` |
| Connect | `createConnectLink`, `getConnectUser`, `revokeConnectToken` |
| Virtual accounts | `createVirtualCustomer`, `listVirtualCustomers`, `getVirtualCustomer`, `updateVirtualCustomer`, `deleteVirtualCustomer`, `createUsAccount`, `deactivateUsAccount`, `reactivateUsAccount`, `getUsAccountActivity` |
| Webhooks | `PayChanguWebhooks.verify` |

Domain namespaces are also available: `paychangu.checkout`, `paychangu.mobileMoney`, `paychangu.bankTransfer`, `paychangu.card`, `paychangu.mobileMoneyPayouts`, `paychangu.bankPayouts`, `paychangu.bills`, `paychangu.connect`, `paychangu.virtualAccounts`.

### Direct mobile money charge

```dart
final operators = await paychangu.getMobileMoneyOperators();
final airtel = operators.data.firstWhere((o) => o.shortCode == 'airtel');

final charge = await paychangu.chargeMobileMoney(
  MobileMoneyChargeRequest(
    mobile: '+265991234567',
    mobileMoneyOperatorRefId: airtel.refId!,
    amount: '500',
    chargeId: 'charge-unique-id',
  ),
);

final verified = await paychangu.verifyMobileMoneyCharge(charge.data.chargeId!);
```

### MoMo payout (server recommended)

```dart
final payout = await paychangu.initiateMobileMoneyPayout(
  MobileMoneyPayoutRequest(
    mobile: '+265991234567',
    mobileMoneyOperatorRefId: airtel.refId!,
    amount: '500',
    chargeId: 'payout-unique-id',
  ),
);
```

### Webhook verification

```dart
final ok = PayChanguWebhooks.verify(
  rawBody: rawRequestBody,
  signatureHeader: requestHeaders['Signature']!,
  webhookSecret: 'your_webhook_secret',
);
```

## Example app

```bash
cd example
flutter run --dart-define=PAYCHANGU_SECRET_KEY=your_sandbox_secret
```

## Migration from 0.0.x

- Package version is **1.0.0** (breaking).
- `initiatePayment` now returns `PaymentSessionResponse` instead of `Map`.
- MoMo payout request fields are now `mobile`, `mobileMoneyOperatorRefId`, `chargeId` (not `phoneNumber` / `provider` / `reference`).
- `Currency.MWK` / `Currency.USD` still work; serialization uses `.apiValue`.
- Prefer `initiateMobileMoneyPayout` over deprecated `initiateMobileMoneyTransfer`.

## Documentation

- API reference: https://developer.paychangu.com/reference/introduction
- Guides: https://developer.paychangu.com/docs/welcome
- Errors: https://developer.paychangu.com/docs/paychangu-errors

## License

MIT
