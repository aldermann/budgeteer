import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:flutter/material.dart';

import 'budget_item.dart';

enum _IncomeAction { Edit, Delete, MakeSaving }

class IncomeItem extends BudgetItem<Income> {
  IncomeItem({
    Key key,
    Income income,
    bool editable,
  }) : super(
            key: key,
            budget: income,
            onEdit: _handleEdit,
            popupMenuBuilder: _buildMenuButton,
            editable: editable);

  static void _handleEdit(BuildContext context, Income income) {
    Navigator.pushNamed(context, AddIncomeRoute.routeName, arguments: income);
  }

  static void _handleDelete(BuildContext context, Income income) {
    income.delete();
  }

  static PopupMenuButton _buildMenuButton(BuildContext context, Income income) {
    return PopupMenuButton<_IncomeAction>(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext innerContext) {
        return <PopupMenuEntry<_IncomeAction>>[
          PopupMenuItem<_IncomeAction>(
            value: _IncomeAction.Edit,
            child: Text("Edit"),
          ),
          PopupMenuItem<_IncomeAction>(
            value: _IncomeAction.Delete,
            child: Text("Delete"),
          ),
          PopupMenuItem<_IncomeAction>(
            value: _IncomeAction.MakeSaving,
            child: Text("Make Saving"),
          ),
        ];
      },
      onSelected: (_IncomeAction action) {
        switch (action) {
          case _IncomeAction.Edit:
            _handleEdit(context, income);
            break;
          case _IncomeAction.Delete:
            _handleDelete(context, income);
            break;
          case _IncomeAction.MakeSaving:
            break;
        }
      },
    );
  }
}
