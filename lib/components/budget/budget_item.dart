import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/utils/date_time.dart';
import 'package:flutter/material.dart';

import 'expense_item.dart';
import 'income_item.dart';
import 'loan_item.dart';
import 'saving_item.dart';

typedef void CallbackWithBudget<T extends Budget>(BuildContext context, T b);
typedef PopupMenuButton PopupMenuBuilder<T extends Budget>(
  BuildContext context,
  T b,
);

class BudgetItem<T extends Budget> extends StatelessWidget {
  final T budget;
  final CallbackWithBudget<T> onEdit;
  final PopupMenuBuilder<T> popupMenuBuilder;
  final bool editable;

  BudgetItem({
    Key key,
    this.budget,
    this.onEdit,
    this.popupMenuBuilder,
    this.editable: true,
  }) : super(key: key);

  static Widget buildItem(
      {Key key, Budget budget, bool editable: true, bool compoundLoan: false}) {
    if (budget is Income) {
      return IncomeItem(key: key, income: budget, editable: editable);
    } else if (budget is Loan) {
      if (compoundLoan) {
        return CompoundLoanItem(key: key, loan: budget, editable: editable);
      }
      return LoanItem(key: key, loan: budget, editable: editable);
    } else if (budget is Expense) {
      return ExpenseItem(key: key, expense: budget, editable: editable);
    } else if (budget is LoanPayment) {
      return LoanPaymentItem(key: key, loanPayment: budget, editable: editable);
    } else if (budget is Saving) {
      return SavingItem(key: key, saving: budget, editable: editable);
    }
    return BudgetItem(key: key, budget: budget, editable: editable);
  }

  editBudget(BuildContext context) => () {
        if (onEdit != null) {
          onEdit(context, budget);
        }
      };

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
      trailing: editable && popupMenuBuilder != null
          ? popupMenuBuilder(context, budget)
          : null,
      isThreeLine: true,
      onLongPress: editable ? editBudget(context) : null,
    );
  }
}
