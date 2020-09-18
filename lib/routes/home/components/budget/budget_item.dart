import 'package:budgeteer/models/budget/budget.dart';
import 'package:budgeteer/utils/date_time.dart';
import 'package:flutter/material.dart';

import 'income_item.dart';
import 'loan_item.dart';

typedef void CallbackWithBudget<T extends Budget>(BuildContext context, T b);
typedef PopupMenuButton PopupMenuBuilder<T extends Budget>(
  BuildContext context,
  T b,
);

abstract class BudgetItem<T extends Budget> extends StatelessWidget {
  final T budget;
  final CallbackWithBudget<T> onEdit;
  final PopupMenuBuilder<T> popupMenuBuilder;

  BudgetItem({
    Key key,
    this.budget,
    @required this.onEdit,
    @required this.popupMenuBuilder,
  }) : super(key: key);

  static BudgetItem buildItem({Key key, Budget budget}) {
    if (budget is Income) {
      return IncomeItem(key: key, income: budget);
    } else if (budget is Loan) {
      return LoanItem(key: key, loan: budget);
    }
    return null;
  }

  editBudget(BuildContext context) => () => onEdit(context, budget);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListTile(
      leading: Icon(budget.icon, size: 30),
      title: Text(
        budget.name,
      ),
      subtitle: RichText(
        text: TextSpan(
          text: budget.amount.representation(),
          style: theme.textTheme.subtitle1.copyWith(color: budget.color),
          children: [
            TextSpan(text: "\n"),
            TextSpan(
              text: budget.time.dmyhm,
              style: theme.textTheme.bodyText1,
            ),
          ],
        ),
      ),
      trailing: popupMenuBuilder?.call(context, budget),
      isThreeLine: true,
      onLongPress: editBudget(context),
    );
  }
}
