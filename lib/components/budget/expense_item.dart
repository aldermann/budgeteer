import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:flutter/material.dart';

import 'budget_item.dart';

enum _ExpenseAction { Edit, Delete }

class ExpenseItem extends BudgetItem<Expense> {
  ExpenseItem({
    Key key,
    Expense expense,
    bool editable,
  }) : super(
          key: key,
          budget: expense,
          onEdit: _handleEdit,
          popupMenuBuilder: _buildMenuButton,
          editable: editable,
        );

  static void _handleEdit(BuildContext context, Expense expense) {
    Navigator.pushNamed(context, AddExpenseRoute.config.routePath, arguments: expense);
  }

  static void _handleDelete(BuildContext context, Expense expense) {
    expense.deleteWithConfirmation(context);
  }

  static PopupMenuButton _buildMenuButton(
      BuildContext context, Expense expense) {
    return PopupMenuButton<_ExpenseAction>(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext innerContext) {
        return <PopupMenuEntry<_ExpenseAction>>[
          PopupMenuItem<_ExpenseAction>(
            value: _ExpenseAction.Edit,
            child: Text("Edit"),
          ),
          PopupMenuItem<_ExpenseAction>(
            value: _ExpenseAction.Delete,
            child: Text("Delete"),
          ),
        ];
      },
      onSelected: (_ExpenseAction action) {
        switch (action) {
          case _ExpenseAction.Edit:
            _handleEdit(context, expense);
            break;
          case _ExpenseAction.Delete:
            _handleDelete(context, expense);
            break;
        }
      },
    );
  }
}
