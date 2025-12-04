class Currency {
  final String code;
  final String name;
  final String symbol;
  final String locale;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.locale,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency &&
          runtimeType == other.runtimeType &&
          code == other.code;

  @override
  int get hashCode => code.hashCode;
}

class SupportedCurrencies {
  static const List<Currency> all = [
    Currency(
      code: 'USD',
      name: 'US Dollar',
      symbol: '\$',
      locale: 'en_US',
    ),
    Currency(
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
      locale: 'en_EU',
    ),
    Currency(
      code: 'GBP',
      name: 'British Pound',
      symbol: '£',
      locale: 'en_GB',
    ),
    Currency(
      code: 'JPY',
      name: 'Japanese Yen',
      symbol: '¥',
      locale: 'ja_JP',
    ),
    Currency(
      code: 'CNY',
      name: 'Chinese Yuan',
      symbol: '¥',
      locale: 'zh_CN',
    ),
    Currency(
      code: 'HKD',
      name: 'Hong Kong Dollar',
      symbol: 'HK\$',
      locale: 'zh_HK',
    ),
    Currency(
      code: 'SGD',
      name: 'Singapore Dollar',
      symbol: 'S\$',
      locale: 'en_SG',
    ),
    Currency(
      code: 'AUD',
      name: 'Australian Dollar',
      symbol: 'A\$',
      locale: 'en_AU',
    ),
    Currency(
      code: 'CAD',
      name: 'Canadian Dollar',
      symbol: 'C\$',
      locale: 'en_CA',
    ),
    Currency(
      code: 'CHF',
      name: 'Swiss Franc',
      symbol: 'CHF',
      locale: 'de_CH',
    ),
    Currency(
      code: 'INR',
      name: 'Indian Rupee',
      symbol: '₹',
      locale: 'en_IN',
    ),
    Currency(
      code: 'KRW',
      name: 'South Korean Won',
      symbol: '₩',
      locale: 'ko_KR',
    ),
    Currency(
      code: 'MYR',
      name: 'Malaysian Ringgit',
      symbol: 'RM',
      locale: 'ms_MY',
    ),
    Currency(
      code: 'THB',
      name: 'Thai Baht',
      symbol: '฿',
      locale: 'th_TH',
    ),
    Currency(
      code: 'VND',
      name: 'Vietnamese Dong',
      symbol: '₫',
      locale: 'vi_VN',
    ),
  ];

  static Currency getByCode(String code) {
    return all.firstWhere(
      (currency) => currency.code == code,
      orElse: () => all.first, // Default to USD
    );
  }

  static Currency get defaultCurrency => all.first; // USD
}
