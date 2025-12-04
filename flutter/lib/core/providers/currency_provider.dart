import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cashlens/core/models/currency.dart';
import 'package:cashlens/shared/constants/app_constants.dart';

part 'currency_provider.g.dart';

@riverpod
class CurrencyNotifier extends _$CurrencyNotifier {
  @override
  Future<Currency> build() async {
    final prefs = await SharedPreferences.getInstance();
    final currencyCode = prefs.getString(AppConstants.keyCurrency);
    
    if (currencyCode != null) {
      return SupportedCurrencies.getByCode(currencyCode);
    }
    
    return SupportedCurrencies.defaultCurrency;
  }

  Future<void> setCurrency(Currency currency) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.keyCurrency, currency.code);
    state = AsyncValue.data(currency);
  }
}
