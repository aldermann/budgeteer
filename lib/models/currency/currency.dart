import 'package:budgeteer/models/config.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

part "currency.g.dart";

abstract class Multiplier {
  static const int G = 1000000000;
  static const int M = 1000000;
  static const int K = 1000;
}

@HiveType(typeId: HiveTypeId.Currency)
class Currency {
  @HiveField(0)
  final int value;

  const Currency(this.value);

  const Currency.withMultiplier(int v, int mult) : this(v * mult);

  static const Currency zero = const Currency(0);

  factory Currency.fromString(String s) {
    try {
      return Currency(int.parse(s));
    } catch (e) {
      return Currency.zero;
    }
  }

  String representation({bool extended = false}) {
    NumberFormat currencyFormat;
    if (extended || value.abs() < 1000) {
      currencyFormat = NumberFormat.simpleCurrency(
        locale: "vi_VN",
        decimalDigits: 0,
      );
    } else {
      currencyFormat = NumberFormat.compactSimpleCurrency(locale: "vi_VN");
    }
    return currencyFormat.format(value);
  }

  String toString() {
    return value.toString();
  }

  static void registerAdapters() {
    Hive.registerAdapter<Currency>(CurrencyAdapter());
  }

  Currency get negative {
    return Currency(-value.abs());
  }

  Currency get positive {
    return Currency(value.abs());
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

  bool gt(int amount) {
    return value > amount;
  }

  bool lt(int amount) {
    return value < amount;
  }

  bool ge(int amount) {
    return value >= amount;
  }

  bool le(int amount) {
    return value <= amount;
  }
}
