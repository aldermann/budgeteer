import 'package:budgeteer/models/budget/budget.dart';
import 'package:flutter/material.dart';
import "income.dart";

class AddIncomeRoute extends StatefulWidget {
  static const String routeName = "/add_income";

  static Widget routeBuilder(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    if (args != null && !(args is Income)) {
      throw AssertionError("Argument for $routeName must be an Income object");
    }
    return AddIncomeRoute(income: args);
  }

  final Income income;

  AddIncomeRoute({this.income});

  AddIncomeRouteState createState() => AddIncomeRouteState();
}
