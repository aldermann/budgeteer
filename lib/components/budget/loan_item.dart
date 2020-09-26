import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:flutter/material.dart';

import 'budget_item.dart';

enum _LoanAction { Edit, Delete, MakePayment }

class CompoundLoanItem extends StatelessWidget {
  final Loan loan;
  final bool editable;

  const CompoundLoanItem({
    Key key,
    @required this.loan,
    this.editable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (loan.payment == null) {
      return LoanItem(loan: loan, editable: editable);
    }
    return Column(
      children: [
        LoanItem(
          loan: loan,
          editable: editable,
        ),
        LoanPaymentItem(
          loanPayment: loan.payment,
          editable: editable,
        ),
      ],
    );
  }
}

class LoanItem extends BudgetItem<Loan> {
  LoanItem({
    Key key,
    Loan loan,
    bool editable,
  }) : super(
          key: key,
          budget: loan,
          onEdit: _handleEdit,
          popupMenuBuilder: _buildMenuButton,
          editable: editable,
        );

  static void _handleEdit(BuildContext context, Loan loan) {
    Navigator.pushNamed(context, AddLoanRoute.config.routePath,
        arguments: loan);
  }

  static void _handleMakePayment(BuildContext context, Loan loan) {
    Navigator.pushNamed(context, AddLoanPaymentRoute.config.routePath,
        arguments: loan);
  }

  static Future<void> _handleDelete(BuildContext context, Loan loan) async {
    loan.deleteWithConfirmation(context);
  }

  static PopupMenuButton _buildMenuButton(BuildContext context, Loan loan) {
    return PopupMenuButton<_LoanAction>(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext innerContext) {
        return <PopupMenuEntry<_LoanAction>>[
          PopupMenuItem<_LoanAction>(
            value: _LoanAction.Edit,
            child: Text("Edit"),
          ),
          PopupMenuItem<_LoanAction>(
            value: _LoanAction.Delete,
            child: Text("Delete"),
          ),
          if (loan.payment == null)
            PopupMenuItem<_LoanAction>(
              value: _LoanAction.MakePayment,
              child: Text("Make Payment"),
            ),
        ];
      },
      onSelected: (_LoanAction action) {
        switch (action) {
          case _LoanAction.Edit:
            _handleEdit(context, loan);
            break;
          case _LoanAction.Delete:
            _handleDelete(context, loan);
            break;
          case _LoanAction.MakePayment:
            _handleMakePayment(context, loan);
            break;
        }
      },
    );
  }
}

class LoanPaymentItem extends BudgetItem<LoanPayment> {
  LoanPaymentItem({
    Key key,
    LoanPayment loanPayment,
    bool editable,
  }) : super(
          key: key,
          budget: loanPayment,
          onEdit: _handleEdit,
          popupMenuBuilder: _buildMenuButton,
          editable: editable,
        );

  static void _handleEdit(BuildContext context, LoanPayment loanPayment) {
    Navigator.pushNamed(context, AddLoanPaymentRoute.config.routePath,
        arguments: loanPayment);
  }

  static void _handleDelete(BuildContext context, LoanPayment loanPayment) {
    loanPayment.delete();
  }

  static PopupMenuButton _buildMenuButton(
      BuildContext context, LoanPayment loanPayment) {
    return PopupMenuButton<_LoanAction>(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext innerContext) {
        return <PopupMenuEntry<_LoanAction>>[
          PopupMenuItem<_LoanAction>(
            value: _LoanAction.Delete,
            child: Text("Delete"),
          ),
        ];
      },
      onSelected: (_LoanAction action) {
        if (action == _LoanAction.Delete) {
          _handleDelete(context, loanPayment);
        }
      },
    );
  }
}
