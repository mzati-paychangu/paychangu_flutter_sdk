## 1.0.0

- Full rewrite aligned with current PayChangu API (developer.paychangu.com).
- Typed HTTP client with injectable `http.Client`, timeouts, and richer exceptions.
- Hosted checkout: typed session response, improved WebView loading/error UI, failed return handling, optional auto-verify.
- Direct mobile money charge, verify, details, and operators.
- Bank transfer collection; bank and MoMo payouts with correct request models.
- Card charge / verify / refund and 3DS WebView helper.
- Wallet balance, bills/airtime, Connect, and US virtual account APIs.
- Webhook HMAC-SHA256 verification helper.
- Unit tests and CI workflow.
- **Breaking:** MoMo payout field names, typed `initiatePayment` response, modular public API.

## 0.0.2

- Package version bump (undocumented relative to 0.0.1).

## 0.0.1

- Initial hosted checkout + verify + early MoMo transfer helpers.
