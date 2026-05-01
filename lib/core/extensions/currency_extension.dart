import 'package:intl/intl.dart';

extension CurrencyFormatter on num {
  /// Converts a number into a formatted currency string.
  /// Example: 100.formatCurrency('USD') -> $100.00
  String formatCurrency(String currencyCode, {String? customSymbol}) {
    final format = NumberFormat.simpleCurrency(
      locale: 'en_US',    // Set to 'en_US' or null for system default
      name: currencyCode,  // ISO currency code (e.g., 'USD', 'MYR')
    );
    
    // The intl package automatically determines the symbol based on the currencyCode.
    // If you need to force a custom symbol, you would typically use NumberFormat.currency().
    return format.format(this);
  }
}