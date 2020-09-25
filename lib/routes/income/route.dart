import 'package:budgeteer/models/budget/budget.dart';
import 'package:flutter/material.dart';
import '../config.dart';
import "add_income.dart";

class AddIncomeRoute extends StatefulWidget {
  static const RouteConfig config = RouteConfig("/income/add", "Add Income", Icons.monetization_on);
  static Widget routeBuilder(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    if (args != null && !(args is Income)) {
      throw AssertionError("Argument for ${config.routePath} must be an Income object");
    }
    return AddIncomeRoute(income: args);
  }

  final Income income;

  AddIncomeRoute({this.income});

  AddIncomeRouteState createState() => AddIncomeRouteState();
}
