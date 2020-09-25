import 'package:budgeteer/models/models.dart';
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
        final res = Budget.calculateFund();
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
              text: "Current fund:",
              style: TextStyle(fontSize: 20),
              children: <TextSpan>[
                TextSpan(
                  text: '\n${res.item1.representation(extended: true)}',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ]),
        );
      },
    );
  }
}
