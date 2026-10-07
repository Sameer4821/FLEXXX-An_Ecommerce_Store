import 'package:intl/intl.dart';

class CurrencyFormatter {
  static final NumberFormat _inrFormatter = NumberFormat.currency(
    locale: 'en_IN',
    symbol: '₹',
    decimalDigits: 0,
  );

  static String format(double amount) {
    return _inrFormatter.format(amount);
  }

  static String formatInt(int amount) {
    return _inrFormatter.format(amount);
  }

  static String calculateDiscount(double price, double originalPrice) {
    if (originalPrice <= price) return '0%';
    final discount = ((originalPrice - price) / originalPrice) * 100;
    return '${discount.round()}% OFF';
  }
}
