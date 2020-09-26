import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

typedef Widget FundBuilder(
  BuildContext context,
  Currency totalBudget,
  Currency totalSaving,
);

class FundListener extends StatelessWidget {
  final FundBuilder builder;

  FundListener({Key key, @required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Budget.getBox().listenable(),
      builder: (BuildContext context, Box<Budget> budgetBox, Widget widget) {
        final res = Budget.calculateFund();
        return builder(context, res.item1, res.item2);
      },
    );
  }
}
