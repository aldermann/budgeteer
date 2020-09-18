extension DateTimeFormatter on DateTime {
  String get ddmmyy {
    return "$day/$month/$year";
  }

  String get hhmmss {
    return "$hour:$minute:$second";
  }

  String get hhmm {
    return "$hour:$minute";
  }

  String get dmyhm {
    return "$ddmmyy $hhmm";
  }
}


