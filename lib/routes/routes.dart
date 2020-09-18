import 'package:flutter/material.dart';

import 'home/route.dart';
import "income/route.dart";
import 'loan/route.dart';

export 'home/route.dart';
export "income/route.dart";
export 'loan/route.dart';

Map<String, WidgetBuilder> routes = {
  HomeRoute.routeName: HomeRoute.routeBuilder,
  AddIncomeRoute.routeName: AddIncomeRoute.routeBuilder,
  LoanRoute.routeName: LoanRoute.routeBuilder,
};
