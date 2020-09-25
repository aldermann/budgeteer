import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:flutter/material.dart';

import 'budget_item.dart';

enum _SavingAction {
  Edit,
  Delete,
}

class SavingItem extends BudgetItem<Saving> {
  SavingItem({
    Key key,
    Saving saving,
    bool editable,
  }) : super(
          key: key,
          budget: saving,
          onEdit: _handleEdit,
          popupMenuBuilder: _buildMenuButton,
          editable: editable,
        );

  static void _handleEdit(BuildContext context, Saving saving) {
    Navigator.pushNamed(context, AddSavingRoute.config.routePath, arguments: saving);
  }

  static void _handleDelete(BuildContext context, Saving saving) {
    saving.deleteWithConfirmation(context);
  }

  static PopupMenuButton _buildMenuButton(BuildContext context, Saving saving) {
    return PopupMenuButton<_SavingAction>(
      icon: Icon(Icons.more_vert),
      itemBuilder: (BuildContext innerContext) {
        return <PopupMenuEntry<_SavingAction>>[
          PopupMenuItem<_SavingAction>(
            value: _SavingAction.Edit,
            child: Text("Edit"),
          ),
          PopupMenuItem<_SavingAction>(
            value: _SavingAction.Delete,
            child: Text("Delete"),
          ),
        ];
      },
      onSelected: (_SavingAction action) {
        switch (action) {
          case _SavingAction.Edit:
            _handleEdit(context, saving);
            break;
          case _SavingAction.Delete:
            _handleDelete(context, saving);
            break;
        }
      },
    );
  }
}

