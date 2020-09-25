import 'package:budgeteer/components/currency_input.dart';
import 'package:budgeteer/components/ensure_focus.dart';
import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:budgeteer/utils/editor.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'route.dart';

class AddExpenseRouteState extends State<AddExpenseRoute> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _finishFocusNode = FocusNode();
  Currency _totalFund;
  Expense expense;
  EditMode _editMode;
  String nameError;
  String savingError;

  void initState() {
    super.initState();
    _totalFund = Budget.calculateFund().item1;
    if (widget.expense != null) {
      expense = widget.expense;
      _editMode = EditMode.Update;
    } else {
      expense = Expense(type: ExpenseType.Necessity);
      _editMode = EditMode.Create;
    }
  }

  String _validateName(String name) {
    if (name == null || name.isEmpty) {
      return "Input something.";
    }
    return null;
  }

  String _validateAmount(Currency amount) {
    if (amount.positive > _totalFund) {
      return "You are spending more than what you have.";
    }
    return null;
  }

  void _handleSaveName(String name) {
    expense.name = name ?? "";
  }

  void _handleSaveCurrency(Currency amount) {
    expense.amount = amount ?? Currency.zero;
  }

  void _handleSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    switch (_editMode) {
      case EditMode.Update:
        expense.save();
        break;
      case EditMode.Create:
        Box<Budget> budgetBox = Budget.getBox();
        budgetBox.add(expense);
        break;
      default:
        break;
    }
    Navigator.popUntil(context, ModalRoute.withName(HomeRoute.config.routePath));
  }

  Future<void> _handleDelete() async {
    bool deleted = await expense.deleteWithConfirmation(context);
    if (deleted) {
      Navigator.popUntil(context, ModalRoute.withName(HomeRoute.config.routePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AddExpenseRoute.config.routeName),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              EnsureVisibleWhenFocused(
                child: CurrencyFormField(
                  decoration: const InputDecoration(
                    labelText: "Amount *",
                    icon: Icon(Icons.attach_money),
                    helperText: "How much did you get?",
                  ),
                  onSaved: _handleSaveCurrency,
                  textInputAction: TextInputAction.next,
                  onSubmitted: (Currency amount) =>
                      _nameFocusNode.requestFocus(),
                  initialValue: expense.amount,
                  validator: _validateAmount,
                  sign: CurrencyInputSign.Negative,
                ),
                focusNode: _amountFocusNode,
              ),
              EnsureVisibleWhenFocused(
                child: TextFormField(
                  decoration: InputDecoration(
                    labelText: "Name *",
                    icon: Icon(Icons.message),
                    helperText: "A name for this expense.",
                    errorText: nameError,
                  ),
                  onSaved: _handleSaveName,
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                  onFieldSubmitted: (String input) =>
                      _finishFocusNode.requestFocus(),
                  initialValue: expense.name,
                ),
                focusNode: _nameFocusNode,
              ),
              ListTile(
                title: Text(expense.type.name),
                trailing: Icon(expense.type.icon),
              ),
              RaisedButton(
                child: Text(_editMode.name),
                onPressed: _handleSubmit,
                focusNode: _finishFocusNode,
              ),
              if (_editMode == EditMode.Update)
                RaisedButton(
                  child: Text("Delete"),
                  onPressed: _handleDelete,
                )
            ],
          ),
        ),
      ),
    );
  }
}
