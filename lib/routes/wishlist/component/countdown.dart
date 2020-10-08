import 'dart:async';

import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';

typedef Widget DurationBuilder(
  BuildContext context,
  Duration duration,
);

Widget _defaultBuilder(BuildContext context, Duration duration) {
  int days = duration.inDays;
  int hours = duration.inHours.remainder(Duration.hoursPerDay);
  int minutes = duration.inMinutes.remainder(Duration.minutesPerHour);
  int seconds = duration.inSeconds.remainder(Duration.secondsPerMinute);
  Widget buildDigit(String s, String name) {
    return SizedBox(
      width: 50,
      height: 50,
      child: Material(
        child: Column(
          children: [
            Text(name),
            Center(
              child: Text(
                s,
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }

  return Padding(
    padding: const EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildDigit(days.toString(), "Day"),
        buildDigit(hours.toString(), "Hour"),
        buildDigit(minutes.toString(), "Minute"),
        buildDigit(seconds.toString(), "Second"),
      ],
    ),
  );
}

class Countdown extends StatefulWidget {
  final WishItem item;
  final DurationBuilder builder;

  const Countdown({Key key, this.item, this.builder}) : super(key: key);

  const Countdown.defaultCountDown({Key key, this.item})
      : builder = _defaultBuilder;

  @override
  CountdownState createState() => CountdownState();
}

class CountdownState extends State<Countdown> {
  Timer _timer;
  Duration duration = Duration();

  void _updateCountdown(Timer timer) {
    setState(() {
      duration = widget.item.remainingTime;
    });
  }

  @override
  void initState() {
    super.initState();
    duration = widget.item.remainingTime;
    _timer = new Timer.periodic(Duration(seconds: 1), _updateCountdown);
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, duration);
  }
}
