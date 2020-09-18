class MonthYear {
  int month;
  int year;

  MonthYear({this.year, this.month});

  MonthYear.fromDateTime(DateTime d) : this(month: d.month, year: d.year);

  MonthYear.now() : this.fromDateTime(DateTime.now());

  MonthYear.firstOfYear(year) : this(month: 1, year: year);

  MonthYear.lastOfYear(year) : this(month: 12, year: year);

  DateTime toDateTime() {
    return DateTime(year, month, 1);
  }

  MonthYear previousMonth() {
    int prevMonth = month - 1;
    int prevYear = year;
    if (prevMonth == 0) {
      prevMonth = 12;
      --prevYear;
    }
    return MonthYear(year: prevYear, month: prevMonth);
  }

  MonthYear nextMonth() {
    int nextMonth = month + 1;
    int nextYear = year;
    if (nextMonth == 13) {
      nextMonth = 1;
      ++nextYear;
    }
    return MonthYear(year: nextYear, month: nextMonth);
  }

  bool operator >(MonthYear other) {
    return this.toDateTime().isAfter(other.toDateTime());
  }

  bool operator <(MonthYear other) {
    return this.toDateTime().isBefore(other.toDateTime());
  }

  bool operator >=(MonthYear other) {
    return this == other || this > other;
  }

  bool operator <=(MonthYear other) {
    return this == other || this < other;
  }

  @override
  int get hashCode {
    return year.hashCode ^ month.hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other is MonthYear && month == other.month && year == other.year;
  }

  String toString() {
    return "$month/$year";
  }

  bool hasDateTime(DateTime d) {
    return this == MonthYear.fromDateTime(d);
  }
}