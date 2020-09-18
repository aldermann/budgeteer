import 'package:budgeteer/models/meta/meta.dart';
import 'package:budgeteer/models/month_year.dart';
import 'package:flutter/material.dart';

class MonthPick extends StatelessWidget {
  final void Function(MonthYear newMonth) handleMonthSelected;

  final MonthYear currentMonth;

  final bool disabled;

  MonthPick(
      {Key key,
      this.currentMonth,
      this.handleMonthSelected,
      this.disabled = false})
      : super(key: key);

  bool _isMinMonth() {
    Metadata meta = Metadata();
    return currentMonth <= MonthYear.fromDateTime(meta.installationDate);
  }

  bool _isMaxMonth() {
    return currentMonth >= MonthYear.now();
  }

  void handlePreviousMonth() {
    this.handleMonthSelected(currentMonth.previousMonth());
  }

  void handleNextMonth() {
    this.handleMonthSelected(currentMonth.nextMonth());
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.all(Radius.circular(15)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(Icons.navigate_before),
            onPressed: (disabled || _isMinMonth()) ? null : handlePreviousMonth,
          ),
          Text(currentMonth.toString()),
          IconButton(
              icon: Icon(Icons.navigate_next),
              onPressed: (disabled || _isMaxMonth()) ? null : handleNextMonth),
        ],
      ),
    );
  }
}
