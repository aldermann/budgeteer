import 'package:budgeteer/components/currency_input.dart';
import 'package:budgeteer/components/ensure_focus.dart';
import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:budgeteer/utils/editor.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'route.dart';

class LoanIncomeRouteState extends State<LoanRoute> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _amountFieldFocusNode = FocusNode();
  FocusNode _nameFieldFocusNode = FocusNode();

  Loan loan;
  EditMode _editMode;

  void initState() {
    super.initState();
    if (widget.loan != null) {
      loan = widget.loan;
      _editMode = EditMode.Update;
    } else {
      loan = Loan();
      _editMode = EditMode.Create;
    }
  }

  void _handleChangeAmount(Currency amount) {
    loan.amount = amount;
  }

  void _handleChangeName(String name) {
    loan.name = name;
  }

  void _handleSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (_editMode == EditMode.Update) {
      loan.save();
    } else {
      Box<Budget> budgetBox = Budget.getBox();
      budgetBox.add(loan);
    }
    Navigator.popUntil(context, ModalRoute.withName(HomeRoute.routeName));
  }

  Future<void> _handleDelete() async {
    await loan.delete();
    Navigator.popUntil(context, ModalRoute.withName(HomeRoute.routeName));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Loan"),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              EnsureVisibleWhenFocused(
                child: CurrencyFormField(
                  initialValue: loan.amount,
                  onSaved: _handleChangeAmount,
                  decoration: InputDecoration(
                    helperText: "How much are you borrowing?",
                    labelText: "Amount",
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (Currency currency) {
                    _nameFieldFocusNode.requestFocus();
                  },
                ),
                focusNode: _amountFieldFocusNode,
              ),
              EnsureVisibleWhenFocused(
                child: TextFormField(
                  initialValue: loan.name,
                  onSaved: _handleChangeName,
                  focusNode: _nameFieldFocusNode,
                  decoration: InputDecoration(
                    labelText: "Name",
                    helperText: "Who are you borrowing from?",
                  ),
                ),
                focusNode: _nameFieldFocusNode,
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
