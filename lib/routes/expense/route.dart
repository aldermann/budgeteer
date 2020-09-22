import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';

import 'expense.dart';

class AddExpenseRoute extends StatefulWidget {
  static const String routeName = "/add_expense";

  static Widget routeBuilder(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    if (args != null && !(args is Expense)) {
      throw AssertionError("Argument for $routeName must be an Expense object");
    }
    return AddExpenseRoute(expense: args);
  }

  final Expense expense;

  AddExpenseRoute({this.expense});

  AddExpenseRouteState createState() => AddExpenseRouteState();
}