import 'package:budgeteer/models/currency/currency.dart';
import 'package:budgeteer/utils/hive_link/hive_link.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../config.dart';
import 'budget.dart';

part "loan.g.dart";

@HiveType(typeId: HiveTypeId.Loan)
class Loan extends Budget {
  @HiveField(3)
  HiveLink<LoanPayment> _paymentLink;

  Loan({
    String name = "",
    Currency amount = Currency.zero,
    DateTime time,
  }) : super(name: name, amount: amount, time: time);

  @override
  IconData get icon => Icons.account_balance;

  LoanPayment makePayment() {
    return LoanPayment(name: "Payment for $name", amount: -amount);
  }

  void linkPayment(LoanPayment payment) {
    _paymentLink.item = payment;
    payment._loanLink.item = this;
  }

  LoanPayment get payment => _paymentLink.item;
}

@HiveType(typeId: HiveTypeId.LoanPayment)
class LoanPayment extends Budget {
  @HiveField(3)
  HiveLink<Loan> _loanLink;

  LoanPayment({
    String name,
    Currency amount,
    DateTime time,
  }) : super(name: name, amount: amount, time: time);

  @override
  IconData get icon => throw UnimplementedError();

  Loan get loan => _loanLink.item;
}
