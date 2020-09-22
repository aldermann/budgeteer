import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';

import 'saving.dart';

class SavingRoute extends StatefulWidget {
  static const String routeName = "/saving";
  final SavingTransfer saving;

  const SavingRoute({Key key, this.saving}) : super(key: key);

  static Widget routeBuilder(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    if (args != null && !(args is SavingTransfer)) {
      throw AssertionError("Argument for $routeName must be a SavingTransfer object");
    }
    return SavingRoute(saving: args);
  }

  @override
  SavingRouteState createState() => SavingRouteState();
}

