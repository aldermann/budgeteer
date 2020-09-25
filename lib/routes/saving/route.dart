import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import 'add_saving.dart';

class AddSavingRoute extends StatefulWidget {
  static const RouteConfig config = RouteConfig(
    "/saving/add",
    "Add Saving",
    Icons.account_balance,
  );
  final Saving saving;
  final Income income;

  const AddSavingRoute({Key key, this.saving, this.income}) : super(key: key);

  static Widget routeBuilder(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    if (args == null) {
      return AddSavingRoute();
    }
    if (args is Saving) {
      return AddSavingRoute(saving: args);
    }
    if (args is Income) {
      return AddSavingRoute(income: args);
    }
    if (args != null && !(args is Saving || args is Income)) {
      throw AssertionError(
          "Argument for ${config.routePath} must be a SavingTransfer or Income object");
    }
    return AddSavingRoute(saving: args);
  }

  @override
  SavingRouteState createState() => SavingRouteState();
}
