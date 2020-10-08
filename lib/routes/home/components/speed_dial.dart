import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hive/hive.dart';

class CustomSpeedDial extends StatelessWidget {

  CustomSpeedDial();

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon: AnimatedIcons.menu_close,
      animatedIconTheme: IconThemeData(size: 22.0),
      curve: Curves.easeInOut,
      animationSpeed: 300,
      overlayColor: Colors.grey.shade900.withAlpha(50),
      children: [
        SpeedDialChild(
          child: Icon(AddIncomeRoute.config.icon),
          backgroundColor: Colors.green,
          label: AddIncomeRoute.config.routeName,
          onTap: () =>
              Navigator.pushNamed(context, AddIncomeRoute.config.routePath),
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: Icon(AddLoanRoute.config.icon),
          backgroundColor: Colors.yellow,
          label: AddLoanRoute.config.routeName,
          onTap: () =>
              Navigator.pushNamed(context, AddLoanRoute.config.routePath),
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: Icon(AddExpenseRoute.config.icon),
          backgroundColor: Colors.red,
          label: AddExpenseRoute.config.routeName,
          onTap: () =>
              Navigator.pushNamed(context, AddExpenseRoute.config.routePath),
          labelBackgroundColor: Colors.black,
        ),
        SpeedDialChild(
          child: Icon(AddSavingRoute.config.icon),
          backgroundColor: Colors.blue,
          label: AddSavingRoute.config.routeName,
          onTap: () =>
              Navigator.pushNamed(context, AddSavingRoute.config.routePath),
          labelBackgroundColor: Colors.black,
        ),
      ],
    );
  }
}
