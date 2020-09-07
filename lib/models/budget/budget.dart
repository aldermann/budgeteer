import 'package:budgeteer/models/config.dart';
import 'package:budgeteer/models/currency/currency.dart';
import "package:hive/hive.dart";

part 'budget.p.dart';

const String _BUDGET_BOX_NAME = "BUDGET";

@HiveType(typeId: HiveTypeId.ExpenseType)
enum ExpenseType {
  @HiveField(0)
  Necessity,
  @HiveField(1)
  SelfImprovement,
  @HiveField(2)
  Entertainment
}

@HiveType(typeId: HiveTypeId.IncomeType)
enum IncomeType {
  @HiveField(0)
  Salary,
  @HiveField(1)
  Loan,
  @HiveField(2)
  Misc
}

abstract class Budget extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final Currency amount;

  @HiveField(2)
  final DateTime time;

  Budget({this.name, this.amount, DateTime time})
      : this.time = time ?? DateTime.now();

  static Box<Budget> getBox() {
    return Hive.box<Budget>(_BUDGET_BOX_NAME);
  }

  static void registerAdapters() {
    Hive.registerAdapter<Expense>(ExpenseAdapter());
    Hive.registerAdapter<ExpenseType>(ExpenseTypeAdapter());
    Hive.registerAdapter<Income>(IncomeAdapter());
    Hive.registerAdapter<IncomeType>(IncomeTypeAdapter());
  }

  static Future<void> openBox() async {
    await Hive.openBox<Budget>(_BUDGET_BOX_NAME);
  }
}

@HiveType(typeId: HiveTypeId.Expense)
class Expense extends Budget {
  @HiveField(3)
  ExpenseType type;

  Expense({String name, Currency amount, DateTime time, this.type})
      : super(name: name, amount: amount, time: time);
}

@HiveType(typeId: HiveTypeId.Income)
class Income extends Budget {
  @HiveField(3)
  IncomeType type;
  @HiveField(4)
  Currency saving;

  Income({String name, Currency amount, this.saving = const Currency(0), DateTime time, this.type})
      : super(name: name, amount: amount, time: time);
}
