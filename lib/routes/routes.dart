import 'package:flutter/material.dart';

import "home/route.dart";
import "income/route.dart";
import "loan/route.dart";
import "expense/route.dart";
import "saving/route.dart";

export "home/route.dart";
export "income/route.dart";
export "loan/route.dart";
export "expense/route.dart";
export "saving/route.dart";

Map<String, WidgetBuilder> routes = {
  HomeRoute.routeName: HomeRoute.routeBuilder,
  AddIncomeRoute.routeName: AddIncomeRoute.routeBuilder,
  LoanRoute.routeName: LoanRoute.routeBuilder,
  LoanPaymentRoute.routeName: LoanPaymentRoute.routeBuilder,
  AddExpenseRoute.routeName: AddExpenseRoute.routeBuilder,
  SavingRoute.routeName: SavingRoute.routeBuilder,
};
