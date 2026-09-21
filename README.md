# PayChangu Flutter SDK

Flutter/Dart client for the [PayChangu API](https://developer.paychangu.com/reference/introduction).
Accept payments in Malawi via hosted checkout, direct mobile money, bank transfer,
and cards; send payouts; pay bills; use Connect and US virtual accounts.

[![pub package](https://img.shields.io/pub/v/paychangu_flutter.svg)](https://pub.dev/packages/paychangu_flutter)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Features

- Hosted checkout WebView with callback / return handling and optional auto-verify
- Typed clients for the full PayChangu REST surface
- Injectable HTTP client for tests and proxies
- Webhook HMAC-SHA256 verification helper
- Direct MoMo charge, operators, and wallet balance
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

```dart
import 'package:paychangu_flutter/paychangu_flutter.dart';
```

## Security

- Hosted checkout may use a secret key from the app for `POST /payment`.
- **Do not** ship secret keys in production apps for payouts, card PAN charges,
  or bill payments — call those from your backend.
- Always re-verify successful payments with `verifyTransaction` (or your server)
  before fulfilling orders.
- Verify webhooks with `PayChanguWebhooks.verify`.

## Quick start — hosted checkout

```dart
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

paychangu.launchPayment(
  request: request,
  autoVerify: true,
  onSuccess: (params) {},
  onError: (error) {},
  onCancel: () {},
  onVerified: (verification) {},
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
| Mobile money | `getMobileMoneyOperators`, `chargeMobileMoney`, `verifyMobileMoneyCharge` |
| Bank transfer | `initializeBankTransfer`, `getBankTransferDetails` |
| Card | `chargeCard`, `verifyCardCharge`, `refundCardCharge`, `launch3dsAuth` |
| MoMo payout | `initiateMobileMoneyPayout`, `getMobileMoneyPayoutDetails` |
| Bank payout | `getBanks`, `initiateBankPayout`, `getBankPayoutDetails`, `listBankPayouts` |
| Bills | `getBillers`, `validateBill`, `payBill`, `buyAirtime`, … |
| Connect | `createConnectLink`, `getConnectUser`, `revokeConnectToken` |
| Virtual accounts | `createVirtualCustomer`, `createUsAccount`, … |
| Webhooks | `PayChanguWebhooks.verify` |

Namespaced APIs: `paychangu.checkout`, `.mobileMoney`, `.bankTransfer`, `.card`,
`.mobileMoneyPayouts`, `.bankPayouts`, `.bills`, `.connect`, `.virtualAccounts`.

## Example

A minimal demo lives in [`example/`](example/):

```bash
cd example
flutter run --dart-define=PAYCHANGU_SECRET_KEY=your_sandbox_secret
```

## Migration from 0.0.x

- Version **1.0.0** is breaking.
- `initiatePayment` returns `PaymentSessionResponse` instead of `Map`.
- MoMo payout fields: `mobile`, `mobileMoneyOperatorRefId`, `chargeId`.
- Prefer `initiateMobileMoneyPayout` over deprecated `initiateMobileMoneyTransfer`.

## Documentation

- [API reference](https://developer.paychangu.com/reference/introduction)
- [Standard checkout](https://developer.paychangu.com/docs/standard-checkout)
- [Webhooks](https://developer.paychangu.com/docs/webhooks)
- [Errors](https://developer.paychangu.com/docs/paychangu-errors)

## License

MIT
