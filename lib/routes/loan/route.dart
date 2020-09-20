import 'package:budgeteer/models/budget/loan.dart';
import 'package:flutter/material.dart';

import 'loan.dart';
export 'loan_payment.dart';

class LoanRoute extends StatefulWidget {
  static const String routeName = "/loan";
  final Loan loan;

  const LoanRoute({Key key, this.loan}) : super(key: key);

  static Widget routeBuilder(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    if (args != null && !(args is Loan)) {
      throw AssertionError("Argument for $routeName must be an Loan object");
    }
    return LoanRoute(loan: args);
  }

  @override
  LoanRouteState createState() => LoanRouteState();
}

