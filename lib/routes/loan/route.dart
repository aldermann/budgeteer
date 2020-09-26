import 'package:budgeteer/models/budget/loan.dart';
import 'package:flutter/material.dart';

import '../config.dart';
import 'add_loan.dart';
import 'loan.dart';
export 'add_loan_payment.dart';

class AddLoanRoute extends StatefulWidget {
  static const RouteConfig config = RouteConfig(
    "/loan/add",
    "Add Loan",
    Icons.attach_money,
  );
  final Loan loan;

  const AddLoanRoute({Key key, this.loan}) : super(key: key);

  static Widget routeBuilder(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    if (args != null && !(args is Loan)) {
      throw AssertionError(
          "Argument for ${config.routePath} must be an Loan object");
    }
    return AddLoanRoute(loan: args);
  }

  @override
  AddLoanRouteState createState() => AddLoanRouteState();
}

class LoanRoute extends StatefulWidget {
  static const RouteConfig config = RouteConfig(
    "/loan",
    "Loan",
    Icons.assignment,
  );

  const LoanRoute({Key key}) : super(key: key);

  static Widget routeBuilder(BuildContext context) {
    return LoanRoute();
  }

  @override
  LoanRouteState createState() => LoanRouteState();
}
