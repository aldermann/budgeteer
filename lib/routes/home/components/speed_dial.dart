import 'package:budgeteer/models/budget/budget.dart';
import 'package:budgeteer/models/currency/currency.dart';
import 'package:budgeteer/routes/income/route.dart';
import 'package:budgeteer/routes/loan/route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';

class CustomSpeedDial extends StatelessWidget {
  final Box<Budget> box;

  CustomSpeedDial() : box = Budget.getBox();

  void handleClearFund() {
    box.clear();
  }

  void handleRemoveMoney() {
    DateTime t = DateTime.now();
    var cash = Expense(
      name: "drug",
      type: ExpenseType.SelfImprovement,
      amount: Currency(100000),
      time: t,
    );
    box.add(cash);
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      curve: Curves.easeInOut,
      animationSpeed: 300,
      overlayColor: Colors.grey.shade900.withAlpha(50),
      children: [
        SpeedDialChild(
          child: Icon(Icons.clear),
          backgroundColor: Colors.blue,
          label: 'Clear fund',
          onTap: handleClearFund,
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Colors.green,
          label: 'Income',
          onTap: () => Navigator.pushNamed(context, AddIncomeRoute.routeName),
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: Icon(Icons.account_balance),
          backgroundColor: Colors.yellow,
          label: 'Loan',
          onTap: () => Navigator.pushNamed(context, LoanRoute.routeName),
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: Icon(Icons.remove),
          backgroundColor: Colors.red,
          label: 'Remove fund',
          onTap: handleRemoveMoney,
          labelBackgroundColor: Colors.black,
        ),
      ],
    );
  }
}
