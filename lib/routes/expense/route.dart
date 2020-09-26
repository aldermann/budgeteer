import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import 'add_expense.dart';
import "expense.dart";

class AddExpenseRoute extends StatefulWidget {
  static const RouteConfig config = RouteConfig(
    "/expense/add",
    "Add Expense",
    Icons.fastfood,
  );

  static Widget routeBuilder(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    if (args != null && !(args is Expense)) {
      throw AssertionError(
        "Argument for ${config.routePath} must be an Expense object",
      );
    }
    return AddExpenseRoute(expense: args);
  }

  final Expense expense;

  AddExpenseRoute({this.expense});

  AddExpenseRouteState createState() => AddExpenseRouteState();
}

class ExpenseRoute extends StatefulWidget {
  static const RouteConfig config = RouteConfig(
    "/expense",
    " Expenses",
    Icons.money_off,
  );

  static Widget routeBuilder(BuildContext context) {
    return ExpenseRoute();
  }

  ExpenseRoute();

  ExpenseRouteState createState() => ExpenseRouteState();
}
