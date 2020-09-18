import 'dart:ui';

import 'package:budgeteer/models/currency/currency.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../config.dart';
import 'budget.dart';

part "saving.g.dart";

@HiveType(typeId: HiveTypeId.SavingTransfer)
class SavingTransfer extends Budget {
  SavingTransfer({String name, Currency amount, DateTime time})
      : super(name: name, amount: amount, time: time);

  @override
  Color get color {
    return Colors.yellow.shade600;
  }

  @override
  IconData get icon {
    return Icons.account_balance_wallet;
  }
}
