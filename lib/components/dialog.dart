import 'dart:async';

import 'package:flutter/material.dart';

abstract class Dialogs {
  static Future<bool> showConfirmationDialog({
    @required BuildContext context,
    @required String title,
    @required String content,
    String confirmString = "Yes",
    String denyString = "No",
  }) {
    Completer<bool> completer = Completer<bool>();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(true);
              },
              child: Text(confirmString),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
                completer.complete(false);
              },
              child: Text(denyString),
            )
          ],
        );
      },
    );
    return completer.future;
  }

  static void showAlert({
    @required BuildContext context,
    @required String title,
    @required String content,
    String confirmString = "OK",
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(confirmString),
            ),
          ],
        );
      },
    );
  }
}
