import 'package:budgeteer/models/budget/budget.dart';
import 'package:budgeteer/models/currency/currency.dart';
import 'package:tuple/tuple.dart';

class FundUtils {
  static Tuple2<Currency, Currency> calculateFund(Iterable<Budget> budgets) {
    Currency totalFund = Currency(0);
    Currency totalSaving = Currency(0);
    for (Budget budget in budgets) {
      if (budget is Income) {
        totalFund += budget.amount;
        totalSaving += budget.saving;
      } else {
        totalFund -= budget.amount;
      }
    }
    return Tuple2(totalFund, totalSaving);
  }
}