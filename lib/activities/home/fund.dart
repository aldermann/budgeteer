import 'package:budgeteer/models/budget/budget.dart';
import 'package:budgeteer/utils/fund.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Fund extends StatelessWidget {
  Fund({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Budget.getBox().listenable(),
      builder: (BuildContext context, Box<Budget> budgetBox, Widget widget) {
        var res = FundUtils.calculateFund(budgetBox.values);
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: "Your current fund is: ${res.item1.representation()}",
              style: TextStyle(fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                  text: '\nYour saving is: ${res.item2.representation()}',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
              ]),
        );
      },
    );
  }
}
