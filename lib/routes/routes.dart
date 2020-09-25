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
  HomeRoute.config.routePath: HomeRoute.routeBuilder,
  AddIncomeRoute.config.routePath: AddIncomeRoute.routeBuilder,
  AddLoanRoute.config.routePath: AddLoanRoute.routeBuilder,
  AddLoanPaymentRoute.config.routePath: AddLoanPaymentRoute.routeBuilder,
  AddExpenseRoute.config.routePath: AddExpenseRoute.routeBuilder,
  AddSavingRoute.config.routePath: AddSavingRoute.routeBuilder,
};
