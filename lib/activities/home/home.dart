import 'package:budgeteer/activities/home/budget_list.dart';
import 'package:budgeteer/components/month_pick.dart';
import 'package:budgeteer/config.dart' as config;
import 'package:budgeteer/models/budget/budget.dart';
import 'package:budgeteer/models/currency/currency.dart';
import 'package:budgeteer/utils/date_time.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';

import 'fund.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  MonthYear currentMonth;
  Box<Budget> box;

  HomePageState() : currentMonth = MonthYear.now();

  @override
  void initState() {
    super.initState();
    box = Budget.getBox();
  }

  void setMonth(MonthYear month) {
    setState(() {
      currentMonth = month;
    });
  }

  void handleClearFund() {
    box.clear();
  }

  void handleAddMoney() {
    DateTime t = DateTime.now();
    var salary = Income(
      name: "salary",
      type: IncomeType.Salary,
      amount: Currency(100000),
      saving: Currency(20000),
      time: t,
    );
    box.add(salary);
  }

  void handleRemoveMoney() {
    DateTime t = DateTime.now();
    var cash = Expense(
        name: "drug",
        type: ExpenseType.SelfImprovement,
        amount: Currency(100000),
        time: t);
    box.add(cash);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 22.0),
        curve: Curves.easeIn,
        animationSpeed: 300,
        children: [
          SpeedDialChild(
            child: Icon(Icons.clear),
            backgroundColor: Colors.blue,
            label: 'Clear fund',
            onTap: handleClearFund,
          ),
          SpeedDialChild(
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
            label: 'Add fund',
            onTap: handleAddMoney,
          ),
          SpeedDialChild(
            child: Icon(Icons.remove),
            backgroundColor: Colors.red,
            label: 'Remove fund',
            onTap: handleRemoveMoney,
          ),
        ],
      ),
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
