import 'package:budgeteer/components/budget/budget_list.dart';
import 'package:budgeteer/components/drawer.dart';
import 'package:budgeteer/components/input/month_pick.dart';
import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';

import 'route.dart';

class ExpenseRouteState extends State<ExpenseRoute> {
  MonthYear currentMonth = MonthYear.now();

  void _handleMonthSelected(MonthYear newMonth) {
    setState(() {
      currentMonth = newMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(ExpenseRoute.config.routeName)),
      drawer: RouteDrawer.defaultDrawer(ExpenseRoute.config.routePath),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            MonthPick(
              currentMonth: currentMonth,
              handleMonthSelected: _handleMonthSelected,
            ),
            Expanded(
              child: BudgetList.listView(
                currentMonth: currentMonth,
                predicate: (Budget b) => b is Expense,
              ),
            ),
            RaisedButton(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text(AddExpenseRoute.config.routeName),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, AddExpenseRoute.config.routePath);
              },
            )
          ],
        ),
      ),
    );
  }
}
