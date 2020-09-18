import 'package:budgeteer/components/currency_input.dart';
import 'package:budgeteer/components/ensure_focus.dart';
import 'package:budgeteer/components/type_selector.dart';
import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:budgeteer/utils/editor.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'route.dart';

class AddIncomeRouteState extends State<AddIncomeRoute> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _amountFocusNode = FocusNode();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _typeFocusNode = FocusNode();

  Income income;
  EditMode _editMode;
  String nameError;
  String savingError;

  void initState() {
    super.initState();
    if (widget.income != null) {
      income = widget.income;
      _editMode = EditMode.Update;
    } else {
      income = Income();
      _editMode = EditMode.Create;
    }
  }

  String _validateName(String name) {
    if (name == null || name.isEmpty) {
      return "Input something";
    }
    return null;
  }

  void _handleSaveName(String name) {
    income.name = name ?? "";
  }

  void _handleSaveCurrency(Currency amount) {
    income.amount = amount ?? Currency.zero;
  }

  void _handleSaveType(IncomeType type) {
    income.type = type ?? IncomeType.Salary;
  }

  void _handleSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    switch (_editMode) {
      case EditMode.Update:
        income.save();
        break;
      case EditMode.Create:
        Box<Budget> budgetBox = Budget.getBox();
        budgetBox.add(income);
        break;
    }
    Navigator.popUntil(context, ModalRoute.withName(HomeRoute.routeName));
  }

  Future<void> _handleDelete() async {
    await income.delete();
    Navigator.popUntil(context, ModalRoute.withName(HomeRoute.routeName));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Self made income"),
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
                  initialValue: income.amount,
                ),
                focusNode: _amountFocusNode,
              ),
              EnsureVisibleWhenFocused(
                child: TextFormField(
                  decoration: InputDecoration(
                      labelText: "Name *",
                      icon: Icon(Icons.message),
                      helperText: "A name for this income.",
                      errorText: nameError),
                  onChanged: _handleSaveName,
                  textInputAction: TextInputAction.next,
                  validator: _validateName,
                  onFieldSubmitted: (String input) =>
                      _typeFocusNode.requestFocus(),
                  initialValue: income.name,
                ),
                focusNode: _nameFocusNode,
              ),
              EnsureVisibleWhenFocused(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: TypeSelectorFormField<IncomeType>(
                      onSaved: _handleSaveType,
                      values: IncomeType.values,
                      initialValue: income.type,
                    ),
                  ),
                ),
                focusNode: _typeFocusNode,
              ),
              RaisedButton(
                child: Text(_editMode.name),
                onPressed: _handleSubmit,
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
