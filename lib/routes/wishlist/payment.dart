import 'package:budgeteer/components/budget/budget_item.dart';
import 'package:budgeteer/components/dialog.dart';
import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/expense/route.dart';
import 'package:budgeteer/routes/home/route.dart';
import 'package:flutter/material.dart';

import '../config.dart';

class AddWishPaymentRoute extends StatelessWidget {
  static const RouteConfig config = RouteConfig(
    "/wishlist/pay",
    "Buy Wishlist Item",
    Icons.home,
  );
  final WishItem wishItem;
  final Expense expense;
  final Currency _totalFund;

  AddWishPaymentRoute({Key key, this.wishItem})
      : _totalFund = Budget.calculateFund().item1,
        expense = wishItem.makeExpense(),
        super(key: key);

  static Widget routeBuilder(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    if (args != null && !(args is WishItem)) {
      throw AssertionError(
          "Argument for ${config.routePath} must be a WishItem object");
    }
    return AddWishPaymentRoute(wishItem: args);
  }

  _handlePay(BuildContext context) => () async {
        if (_totalFund < expense.amount.positive) {
          return Dialogs.showAlert(
            context: context,
            title: "Insufficient fund",
            content: "You don't have enough budget to pay for this.",
          );
        }
        bool confirmation = await Dialogs.showConfirmationDialog(
          context: context,
          title: "Are you sure?",
          content: "Are you sure you want to go through with this payment?\n"
              "You will be left with ${(_totalFund + expense.amount).representation(extended: true)} after this purchase",
        );
        if (confirmation) {
          Budget.getBox().add(expense);
          wishItem.delete();
          Navigator.popUntil(
            context,
            ModalRoute.withName(HomeRoute.config.routePath),
          );
          Navigator.pushNamed(context, ExpenseRoute.config.routePath);
        }
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(config.routeName)),
      body: Column(
        children: [
          BudgetItem.buildItem(budget: expense, editable: false),
          RaisedButton(
            child: Text("Pay"),
            onPressed: _handlePay(context),
          )
        ],
      ),
    );
  }
}
