import 'package:budgeteer/models/budget/budget.dart';
import 'package:budgeteer/utils/date_time.dart';
import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class BudgetList extends StatelessWidget {
  final MonthYear currentMonth;

  BudgetList({Key key, this.currentMonth}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Budget.getBox().listenable(),
      builder: (BuildContext context, Box<Budget> box, Widget widget) {
        return _BudgetListDisplay(
          budgetBox: box,
          currentMonth: currentMonth,
        );
      },
    );
  }
}

class _BudgetListDisplay extends StatelessWidget {
  final Box<Budget> budgetBox;
  final MonthYear currentMonth;

  _BudgetListDisplay({Key key, this.budgetBox, this.currentMonth})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Budget> validBudgets = budgetBox.values
        .where((Budget b) {
          return currentMonth.hasDateTime(b.time);
        })
        .toList().reversed.toList();

    if (validBudgets.length == 0) {
      return SliverList(
        delegate: SliverChildListDelegate([Text("None")]),
      );
    }

    return SliverFixedExtentList(
      itemExtent: 85.0,
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: BudgetItem(
            key: Key(index.toString()),
            budget: validBudgets[index],
          ),
        );
      }, childCount: validBudgets.length),
    );
  }
}

class BudgetItem extends StatelessWidget {
  final Budget budget;

  BudgetItem({Key key, this.budget}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color priceColor;
    IconData icon;
    if (budget is Income) {
      Income income = budget;
      priceColor = Colors.green;
      switch (income.type) {
        case IncomeType.Salary:
          icon = Icons.attach_money;
          break;
        case IncomeType.Loan:
          icon = Icons.account_balance;
      }
    } else if (budget is Expense) {
      Expense expense = budget;
      priceColor = Colors.red;
      switch (expense.type) {
        case ExpenseType.Necessity:
          icon = Icons.fastfood;
          break;
        case ExpenseType.SelfImprovement:
          icon = Icons.mood;
          break;
        case ExpenseType.Entertainment:
          icon = Icons.games;
          break;
      }
    }
    return ListTile(
      leading: Icon(icon, size: 30),
      title: Text(
        budget.name,
      ),
      subtitle: Text(DateTimeFormatter.dmyhm(budget.time)),
      trailing: Text(
        budget.amount.representation(),
        style: theme.textTheme.bodyText1.copyWith(color: priceColor),
      ),
    );
  }
}
