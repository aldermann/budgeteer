import 'package:budgeteer/models/config.dart';
import 'package:hive/hive.dart';

part "currency.g.dart";

@HiveType(typeId: HiveTypeId.Currency)
class Currency {
  @HiveField(0)
  final int value;

  const Currency(this.value);
  static const Currency zero = const Currency(0);
  factory Currency.fromString(String s) {
    try {
      return Currency(int.parse(s));
    } catch (e) {
      return Currency.zero;
    }
  }

  String representation({bool extended = false}) {
    if (extended || value < 1000) {
      return "$value ₫";
    } else {
      double newAmount = value / 1000.0;
      return "${newAmount.toStringAsFixed(1)}k ₫";
    }
  }

  String toString() {
    return value.toString();
  }

  static void registerAdapters() {
    Hive.registerAdapter<Currency>(CurrencyAdapter());
  }

  @override
  bool operator ==(Object other) {
    return other is Currency && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  Currency operator +(Currency other) {
    return Currency(value + other.value);
  }

  Currency operator -(Currency other) {
    return Currency(value - other.value);
  }

  Currency operator -() {
    return Currency(-value);
  }

  Currency operator *(double x) {
    return Currency((value * x).round());
  }

  Currency operator /(double x) {
    return Currency((value / x).round());
  }

  bool operator >(Currency other) {
    return value > other.value;
  }

  bool operator <(Currency other) {
    return value < other.value;
  }

  bool operator >=(Currency other) {
    return value >= other.value;
  }

  bool operator <=(Currency other) {
    return value <= other.value;
  }
}
