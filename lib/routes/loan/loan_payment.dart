import 'package:budgeteer/components/budget/loan_item.dart';
import 'package:budgeteer/components/dialog.dart';
import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:flutter/material.dart';

class LoanPaymentRoute extends StatelessWidget {
  static const String routeName = "/loan/payment";
  final Loan loan;
  final LoanPayment loanPayment;

  static Widget routeBuilder(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    if (args != null) {
      if (args is Loan) {
        return LoanPaymentRoute(loan: args);
      }
      if (args is LoanPayment) {
        return LoanPaymentRoute(loanPayment: args);
      }
      throw AssertionError(
          "Argument for $routeName must be a Loan or LoanPayment object");
    }
    return null;
  }

  LoanPaymentRoute({Key key, this.loan, this.loanPayment}) : super(key: key) {
    if (loan == null && loanPayment == null) {
      throw AssertionError("You need either 'loan' or 'loanPayment' specified");
    }
  }

  _handleMakePayment(BuildContext context) => () async {
        bool confirmation = await Dialogs.showConfirmationDialog(
          context: context,
          title: "Confirm",
          content: "Pay for this loan?",
        );
        if (confirmation) {
          LoanPayment payment = loan.makePayment();
          Budget.getBox().add(payment);
          loan.linkPayment(payment);
          Navigator.popUntil(context, ModalRoute.withName(HomeRoute.routeName));
        }
      };

  _handleDeletePayment(BuildContext context) => () async {
        bool confirmation = await Dialogs.showConfirmationDialog(
          context: context,
          title: "Delete",
          content: "Delete this payment?",
        );
        if (confirmation) {
          loanPayment.delete();
          Navigator.popUntil(context, ModalRoute.withName(HomeRoute.routeName));
        }
      };

  @override
  Widget build(BuildContext context) {
    Loan _loan = loan ?? loanPayment?.loan;
    assert(_loan != null, "Loan must not be null");
    LoanPayment _loanPayment = loanPayment ?? loan?.payment;

    return Scaffold(
      appBar: AppBar(
        title: Text("Payment"),
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
