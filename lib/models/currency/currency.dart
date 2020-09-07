import 'package:budgeteer/models/config.dart';
import 'package:hive/hive.dart';

part "currency.p.dart";

@HiveType(typeId: HiveTypeId.Currency)
class Currency {
  @HiveField(0)
  final int amount;

  const Currency(this.amount);

  String representation({bool extended = false}) {
    if (extended) {
      return "$amount₫";
    } else {
      double newAmount = amount / 1000.0;
      return "${newAmount.toStringAsFixed(1)}k ₫";
    }
  }

  static void registerAdapters() {
    Hive.registerAdapter<Currency>(CurrencyAdapter());
  }

  @override
  bool operator ==(Object other) {
    return other is Currency && other.amount == amount;
  }

  @override
  int get hashCode => amount.hashCode;

  Currency operator +(Currency other) {
    return Currency(amount + other.amount);
  }

  Currency operator -(Currency other) {
    return Currency(amount - other.amount);
  }

  Currency operator *(double x) {
    return Currency((amount * x).round());
  }

  Currency operator /(double x) {
    return Currency((amount / x).round());
  }

  bool operator >(Currency other) {
    return amount > other.amount;
  }

  bool operator <(Currency other) {
    return amount < other.amount;
  }

  bool operator >=(Currency other) {
    return amount >= other.amount;
  }

  bool operator <=(Currency other) {
    return amount <= other.amount;
  }
}
