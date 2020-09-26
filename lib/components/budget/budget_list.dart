import 'package:budgeteer/components/budget/budget_item.dart';
import 'package:budgeteer/models/budget/budget.dart';
import 'package:budgeteer/models/month_year.dart';
import "package:flutter/material.dart";
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

typedef bool BudgetFilterPredicate(Budget budget);
typedef Widget BudgetListBuilder(BuildContext context, List<Budget> budgets);

bool _defaultBudgetFilter(Budget _) => true;

Widget _emptySliverBuilder(BuildContext context) {
  return SliverList(
    delegate: SliverChildListDelegate([Text("None")]),
  );
}

Widget _emptyListBuilder(BuildContext context) {
  return Text("None");
}

BudgetListBuilder _sliverBudgetBuilder({bool compoundLoan: false}) =>
    (BuildContext context, List<Budget> budgets) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Card(
                child: BudgetItem.buildItem(
                  key: Key(index.toString()),
                  budget: budgets[index],
                  compoundLoan: compoundLoan,
                ),
              ),
            );
          },
          childCount: budgets.length,
        ),
      );
    };

BudgetListBuilder _listBudgetBuilder({bool compoundLoan: false}) =>
    (BuildContext context, List<Budget> budgets) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Card(
              child: BudgetItem.buildItem(
                key: Key(index.toString()),
                budget: budgets[index],
                compoundLoan: compoundLoan,
              ),
            ),
          );
        },
        itemCount: budgets.length,
      );
    };

class BudgetList extends StatelessWidget {
  final MonthYear currentMonth;
  final BudgetFilterPredicate predicate;
  final WidgetBuilder emptyBuilder;
  final BudgetListBuilder budgetListBuilder;
  final bool compoundLoan;

  BudgetList._internal({
    Key key,
    this.currentMonth,
    @required this.predicate,
    @required this.emptyBuilder,
    @required this.budgetListBuilder,
    this.compoundLoan,
  }) : super(key: key);

  BudgetList.sliver({
    Key key,
    MonthYear currentMonth,
    BudgetFilterPredicate predicate,
    bool compoundLoan: false,
  }) : this._internal(
          key: key,
          currentMonth: currentMonth,
          predicate: predicate ?? _defaultBudgetFilter,
          emptyBuilder: _emptySliverBuilder,
          budgetListBuilder: _sliverBudgetBuilder(compoundLoan: compoundLoan),
          compoundLoan: compoundLoan,
        );

  BudgetList.listView({
    Key key,
    MonthYear currentMonth,
    BudgetFilterPredicate predicate,
    bool compoundLoan: false,
  }) : this._internal(
          key: key,
          currentMonth: currentMonth,
          predicate: predicate ?? _defaultBudgetFilter,
          emptyBuilder: _emptyListBuilder,
          budgetListBuilder: _listBudgetBuilder(compoundLoan: compoundLoan),
          compoundLoan: compoundLoan,
        );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Budget.getBox().listenable(),
      builder: (BuildContext context, Box<Budget> box, Widget widget) {
        List<Budget> validBudgets = box.values
            .where((Budget b) {
              return currentMonth.hasDateTime(b.time) &&
                  !(compoundLoan && b is LoanPayment);
            })
            .where(predicate)
            .toList()
            .reversed
            .toList();
        if (validBudgets.length == 0) {
          return emptyBuilder(context);
        }
        return budgetListBuilder(context, validBudgets);
      },
    );
  }
}
