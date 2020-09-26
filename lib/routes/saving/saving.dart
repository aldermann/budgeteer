import 'package:budgeteer/components/budget/budget_list.dart';
import 'package:budgeteer/components/drawer.dart';
import 'package:budgeteer/components/fund.dart';
import 'package:budgeteer/components/input/month_pick.dart';
import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';

import "route.dart";

class SavingRouteState extends State<SavingRoute> {
  MonthYear currentMonth = MonthYear.now();

  void _handleMonthSelected(MonthYear newMonth) {
    setState(() {
      currentMonth = newMonth;
    });
  }

  Widget fundBuilder(
    BuildContext context,
    Currency totalBudget,
    Currency totalSaving,
  ) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        text: "Current saving:",
        style: TextStyle(fontSize: 20),
        children: <TextSpan>[
          TextSpan(
            text: '\n${totalSaving.representation(extended: true)}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: RouteDrawer.defaultDrawer(SavingRoute.config.routePath),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              physics: ClampingScrollPhysics(),
              slivers: <Widget>[
                SliverAppBar(
                  stretch: true,
                  floating: true,
                  pinned: true,
                  expandedHeight: 300.0,
                  collapsedHeight: 100,
                  flexibleSpace: FlexibleSpaceBar(
                    stretchModes: <StretchMode>[
                      StretchMode.zoomBackground,
                      StretchMode.fadeTitle,
                    ],
                    centerTitle: true,
                    title: FundListener(builder: fundBuilder),
                    background: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MonthPick(
                          currentMonth: currentMonth,
                          handleMonthSelected: _handleMonthSelected,
                        ),
                      ],
                    ),
                  ),
                ),
                BudgetList.sliver(
                  currentMonth: currentMonth,
                  predicate: (Budget b) => b is Saving,
                ),
              ],
            ),
          ),
          RaisedButton(
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: Center(
                child: Text(AddSavingRoute.config.routeName),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, AddSavingRoute.config.routePath);
            },
          )
        ],
      ),
    );
  }
}
