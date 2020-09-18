import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:flutter/material.dart';

import 'budget_item.dart';

enum _LoanAction {
  Edit,
  Delete,
}

class LoanItem extends BudgetItem<Loan> {
  static void _handleEdit(BuildContext context, Loan loan) {
    Navigator.pushNamed(context, LoanRoute.routeName, arguments: loan);
  }

  static void _handleDelete(BuildContext context, Loan loan) {
    loan.delete();
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
        }
      },
    );
  }

  LoanItem({Key key, Loan loan})
      : super(
          key: key,
          budget: loan,
          onEdit: _handleEdit,
          popupMenuBuilder: _buildMenuButton,
        );
}
