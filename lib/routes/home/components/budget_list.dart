import 'package:budgeteer/components/budget/budget_item.dart';
import 'package:budgeteer/models/budget/budget.dart';
import 'package:budgeteer/models/month_year.dart';
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
        .toList()
        .reversed
        .toList();

    if (validBudgets.length == 0) {
      return SliverList(
        delegate: SliverChildListDelegate([Text("None")]),
      );
    }

    return SliverFixedExtentList(
      itemExtent: 85.0,
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: BudgetItem.buildItem(
              key: Key(index.toString()),
              budget: validBudgets[index],
            ),
          );
        },
        childCount: validBudgets.length,
      ),
    );
  }
}
