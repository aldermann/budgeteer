import 'package:budgeteer/components/budget/budget_list.dart';
import 'package:budgeteer/components/drawer.dart';
import 'package:budgeteer/components/input/month_pick.dart';
import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';

import 'route.dart';

class IncomeRouteState extends State<IncomeRoute> {
  MonthYear currentMonth = MonthYear.now();

  void _handleMonthSelected(MonthYear newMonth) {
    setState(() {
      currentMonth = newMonth;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(IncomeRoute.config.routeName)),
      drawer: RouteDrawer.defaultDrawer(IncomeRoute.config.routePath),
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
                predicate: (Budget b) => b is Income,
              ),
            ),
            RaisedButton(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text(AddIncomeRoute.config.routeName),
                ),
              ),
              onPressed: () {
                Navigator.pushNamed(context, AddIncomeRoute.config.routePath);
              },
            )
          ],
        ),
      ),
    );
  }
}
