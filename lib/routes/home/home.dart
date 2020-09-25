import 'package:budgeteer/components/drawer.dart';
import 'package:budgeteer/components/month_pick.dart';
import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';

import 'components/budget_list.dart';
import 'components/fund.dart';
import 'components/speed_dial.dart';
import 'route.dart';

class HomeRouteState extends State<HomeRoute> {
  MonthYear currentMonth;

  HomeRouteState() : currentMonth = MonthYear.now();

  @override
  void initState() {
    super.initState();
  }

  void setMonth(MonthYear month) {
    setState(() {
      currentMonth = month;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomSpeedDial(),
      drawer: DrawerWidget.defaultDrawer(HomeRoute.config.routePath),
      body: CustomScrollView(
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
              title: Fund(),
              background: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MonthPick(
                      currentMonth: currentMonth,
                      handleMonthSelected: setMonth,
                    ),
                  ]),
            ),
          ),
          BudgetList(currentMonth: currentMonth),
        ],
      ),
    );
  }
}
