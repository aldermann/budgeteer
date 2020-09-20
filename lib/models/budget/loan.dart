import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../config.dart';
import '../models.dart';
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
    _paymentLink = HiveLink<LoanPayment>();
    payment._loanLink = HiveLink<Loan>();
    _paymentLink.item = payment;
    payment._loanLink.item = this;
    payment.save();
    save();
  }

  LoanPayment get payment => _paymentLink?.item;

  @override
  Future<void> delete() {
    _paymentLink?.item?.delete();
    return super.delete();
  }
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
  IconData get icon => Icons.account_balance;

  Loan get loan => _loanLink?.item;
}
