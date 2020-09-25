import 'dart:async';

import 'package:budgeteer/components/dialog.dart';
import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';
import "package:hive/hive.dart";
import 'package:tuple/tuple.dart';

import "income.dart";
export "income.dart";

import "expense.dart";
export "expense.dart";

import "saving.dart";
export "saving.dart";

import "loan.dart";
export "loan.dart";

const String _BUDGET_BOX_NAME = "BUDGET";

abstract class Budget extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  Currency amount;

  @HiveField(2)
  DateTime time;

  Budget({
    this.name = "",
    this.amount = Currency.zero,
    DateTime time,
  }) : this.time = time ?? DateTime.now();

  static Box<Budget> getBox() {
    return Hive.box<Budget>(_BUDGET_BOX_NAME);
  }

  static void register() {
    Hive.registerAdapter<Expense>(ExpenseAdapter());
    Hive.registerAdapter<ExpenseType>(ExpenseTypeAdapter());
    Hive.registerAdapter<Income>(IncomeAdapter());
    Hive.registerAdapter<IncomeType>(IncomeTypeAdapter());
    Hive.registerAdapter<Saving>(SavingTransferAdapter());
    Hive.registerAdapter<Loan>(LoanAdapter());
    Hive.registerAdapter<LoanPayment>(LoanPaymentAdapter());
  }

  static bool _boxModified = true;
  static Currency _totalFund = Currency.zero;
  static Currency _totalSaving = Currency.zero;

  static Future<void> openBox() async {
    final box = await Hive.openBox<Budget>(_BUDGET_BOX_NAME);
    box.watch().listen(
          (BoxEvent event) => scheduleMicrotask(() => _boxModified = true),
        );
  }

  static Tuple2<Currency, Currency> calculateFund() {
    if (_boxModified) {
      final box = getBox();
      _totalFund = Currency.zero;
      _totalSaving = Currency.zero;
      for (Budget budget in box.values) {
        if (budget is Saving) {
          _totalSaving += budget.amount;
          _totalFund -= budget.amount;
        } else {
          _totalFund += budget.amount;
        }
      }
      _boxModified = false;
    }
    return Tuple2(_totalFund, _totalSaving);
  }

  IconData get icon;

  Color get color {
    if (amount.value >= 0) {
      return Colors.green;
    } else {
      return Colors.red;
    }
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

abstract class BudgetType {
  final IconData icon;
  final String name;

  const BudgetType({this.icon, this.name});
}
