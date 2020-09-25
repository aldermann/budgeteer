import 'package:budgeteer/components/budget/loan_item.dart';
import 'package:budgeteer/components/dialog.dart';
import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:flutter/material.dart';

import '../config.dart';

class AddLoanPaymentRoute extends StatelessWidget {
  static const RouteConfig config = RouteConfig(
    "/loan/payment",
    "Loan payment",
    Icons.home,
  );
  final Loan loan;
  final LoanPayment loanPayment;

  final Currency _totalFund;

  static Widget routeBuilder(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      if (args is Loan) {
        return AddLoanPaymentRoute(loan: args);
      }
      if (args is LoanPayment) {
        return AddLoanPaymentRoute(loanPayment: args);
      }
      throw AssertionError(
          "Argument for ${config.routePath} must be a Loan or LoanPayment object");
    }
    return null;
  }

  AddLoanPaymentRoute({Key key, this.loan, this.loanPayment})
      : _totalFund = Budget.calculateFund().item1,
        super(key: key) {
    if (loan == null && loanPayment == null) {
      throw AssertionError("You need either 'loan' or 'loanPayment' specified");
    }
  }

  _handleMakePayment(BuildContext context) => () async {
        if (loan.amount.lt(0) && -loan.amount > _totalFund) {
          Dialogs.showAlert(
            context: context,
            title: "Error",
            content: "You cannot pay more than what you are having",
          );
        }
        bool confirmation = await Dialogs.showConfirmationDialog(
          context: context,
          title: "Confirm",
          content: "Pay for this loan?",
        );
        if (confirmation) {
          LoanPayment payment = loan.makePayment();
          Budget.getBox().add(payment);
          loan.linkPayment(payment);
          Navigator.popUntil(
              context, ModalRoute.withName(HomeRoute.config.routePath));
        }
      };

  _handleDeletePayment(BuildContext context) => () async {
        bool deleted = await loanPayment.deleteWithConfirmation(context);
        if (deleted) {
          Navigator.popUntil(
              context, ModalRoute.withName(HomeRoute.config.routePath));
        }
      };

  @override
  Widget build(BuildContext context) {
    Loan _loan = loan ?? loanPayment?.loan;
    assert(_loan != null, "Loan must not be null");
    LoanPayment _loanPayment = loanPayment ?? loan?.payment;

    return Scaffold(
      appBar: AppBar(
        title: Text(AddLoanPaymentRoute.config.routeName),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              LoanItem(loan: _loan, editable: false),
              if (_loanPayment != null)
                LoanPaymentItem(
                  loanPayment: _loanPayment,
                  editable: false,
                ),
              if (_loanPayment == null)
                RaisedButton(
                  child: Text("Make payment"),
                  onPressed: _handleMakePayment(context),
                )
              else
                RaisedButton(
                  child: Text("Delete payment"),
                  onPressed: _handleDeletePayment(context),
                )
            ],
          ),
        ),
      ),
    );
  }
}
