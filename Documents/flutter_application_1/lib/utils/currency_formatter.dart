
import 'package:intl/intl.dart';
String formatCurrency(dynamic amount) {
  final formatter = NumberFormat('#,##0.00', 'fr_FR');
  
  double value = 0.0;
  
  if (amount == null) {
    value = 0.0;
  } else if (amount is double) {
    value = amount;
  } else if (amount is int) {
    value = amount.toDouble();
  } else if (amount is String) {
    // Nettoyer le string (enlever espaces, remplacer virgule par point)
    String cleanValue = amount.trim().replaceAll(' ', '').replaceAll(',', '.');
    value = double.tryParse(cleanValue) ?? 0.0;
  } else {
    // Pour tout autre type, essayer de le convertir en string puis en double
    value = double.tryParse(amount.toString()) ?? 0.0;
  }
  
  return 'XOF ${formatter.format(value)}';
}