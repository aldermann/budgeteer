import 'package:budgeteer/components/dialog.dart';
import 'package:budgeteer/models/currency/currency.dart';
import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../config.dart';

part "wish_item.g.dart";

@HiveType(typeId: HiveTypeId.WishItem)
class WishItem extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String description;
  @HiveField(3)
  Currency price;
  @HiveField(4)
  DateTime considerationEnd;
  @HiveField(5)
  ExpenseType type;

  static Duration _calculateWaitTime(Currency price) {
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
    this.name = "",
    this.price = Currency.zero,
    this.description = "",
    this.considerationEnd,
    this.type,
  });

  Duration get remainingTime {
    if (considerationEnd == null || DateTime.now().isAfter(considerationEnd)) {
      return Duration();
    }
    return considerationEnd.difference(DateTime.now());
  }

  bool get isReady {
    return considerationEnd.isBefore(DateTime.now());
  }

  void setRemainingTime() {
    considerationEnd = DateTime.now().add(_calculateWaitTime(price));
  }

  void increaseRemainingTime(Currency previousPrice) {
    Duration previousWaitTime = _calculateWaitTime(previousPrice);
    DateTime creationDate = DateTime.now().subtract(previousWaitTime);
    considerationEnd = creationDate.add(_calculateWaitTime(price));
  }

  Expense makeExpense() {
    return Expense(name: name, amount: price, type: type);
  }

  Future<bool> deleteWithConfirmation(BuildContext context) async {
    bool confirmation = await Dialogs.showConfirmationDialog(
      context: context,
      title: "Deletion",
      content: "Are you sure you want to delete this item?",
    );
    if (confirmation) {
      await delete();
    }
    return confirmation;
  }
}
