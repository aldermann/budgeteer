import 'package:budgeteer/models/currency/currency.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../config.dart';

part "wish_item.g.dart";

@HiveType(typeId: HiveTypeId.WishItem)
class WishItem extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  List<String> pros;
  @HiveField(2)
  List<String> cons;
  @HiveField(3)
  Currency price;
  @HiveField(4)
  DateTime considerationEnd;

  static Duration calculateWaitTime(Currency price) {
    if (price > Currency.withMultiplier(2, Multiplier.M)) {
      return Duration(days: 5);
    }
    if (price > Currency.withMultiplier(1, Multiplier.M)) {
      return Duration(days: 2);
    }
    if (price > Currency.withMultiplier(500, Multiplier.K)) {
      return Duration(days: 1);
    }
    if (price > Currency.withMultiplier(200, Multiplier.K)) {
      return Duration(hours: 2);
    }
    return Duration(hours: 1);
  }

  WishItem({
    @required this.name,
    @required this.pros,
    @required this.cons,
    @required this.price,
    @required this.considerationEnd,
  });

  WishItem.autoCalculated({
    @required this.name,
    @required this.pros,
    @required this.cons,
    @required this.price,
  }) : considerationEnd = DateTime.now().add(calculateWaitTime(price));

  Duration get remainingTime {
    return considerationEnd.difference(DateTime.now());
  }
}
