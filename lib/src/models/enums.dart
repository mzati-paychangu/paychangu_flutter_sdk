/// PayChangu payment status values used across APIs.
enum PaymentStatus {
  pending,
  success,
  failed,
  cancelled,
}

/// Supported charge currencies.
enum Currency {
  /// Malawian Kwacha
  // ignore: constant_identifier_names
  MWK,

  /// US Dollar
  // ignore: constant_identifier_names
  USD;

  /// API wire value (`MWK`, `USD`).
  String get apiValue => name;

  static Currency fromApi(String? value) {
    switch (value?.toUpperCase()) {
      case 'USD':
        return Currency.USD;
      case 'MWK':
      case 'MK':
      default:
        return Currency.MWK;
    }
  }
}
