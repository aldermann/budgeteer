import 'package:budgeteer/components/budget/loan_item.dart';
import 'package:budgeteer/components/currency_input.dart';
import 'package:budgeteer/components/dialog.dart';
import 'package:budgeteer/components/ensure_focus.dart';
import 'package:budgeteer/components/type_selector.dart';
import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:budgeteer/utils/editor.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'route.dart';

enum _LoanType { Give, Get }

const Map<_LoanType, IconData> _LoanIconMap = {
  _LoanType.Give: Icons.arrow_upward,
  _LoanType.Get: Icons.arrow_downward,
};

const Map<_LoanType, String> _LoanNameMap = {
  _LoanType.Give: "Give",
  _LoanType.Get: "Get",
};

class LoanRouteState extends State<LoanRoute> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _amountFieldFocusNode = FocusNode();
  FocusNode _nameFieldFocusNode = FocusNode();

  Loan loan;
  _LoanType _loanType;
  EditMode _editMode;

  void initState() {
    super.initState();
    if (widget.loan != null) {
      loan = widget.loan;
      _loanType = loan.amount.value > 0 ? _LoanType.Get : _LoanType.Give;
      loan.amount = Currency(loan.amount.value.abs());
      if (loan.payment != null) {
        _editMode = EditMode.View;
      } else {
        _editMode = EditMode.Update;
      }
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

  void _handleChangeType(_LoanType type) {
    _loanType = type;
  }

  void _handleSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    switch (_loanType) {
      case _LoanType.Give:
        loan.amount = Currency(-loan.amount.value.abs());
        break;
      case _LoanType.Get:
        loan.amount = Currency(loan.amount.value.abs());
        break;
    }
    if (_editMode == EditMode.Update) {
      loan.save();
    } else {
      Box<Budget> budgetBox = Budget.getBox();
      budgetBox.add(loan);
    }
    Navigator.popUntil(context, ModalRoute.withName(HomeRoute.routeName));
  }

  Future<void> _handleDelete() async {
    String message = "Are you sure you want to delete this loan?";
    if (loan.payment != null) {
      message += "\nThis action will also delete it's payment";
    }
    bool confirmation = await Dialogs.showConfirmationDialog(
        context: context, title: "Delete loan", content: message);
    if (confirmation) {
      await loan.delete();
      Navigator.popUntil(context, ModalRoute.withName(HomeRoute.routeName));
    } else {
      return;
    }
  }

  void _handleMakePayment() {
    Navigator.pushNamed(context, LoanPaymentRoute.routeName, arguments: loan);
  }

  @override
  Widget build(BuildContext context) {
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
              if (_editMode == EditMode.Create)
                Center(
                  child: TypeSelectorFormField(
                    values: _LoanType.values,
                    initialValue: _LoanType.Get,
                    iconMap: _LoanIconMap,
                    nameMap: _LoanNameMap,
                    onSaved: _handleChangeType,
                    onSubmitted: (_LoanType type) {
                      _amountFieldFocusNode.requestFocus();
                    },
                  ),
                ),
              EnsureVisibleWhenFocused(
                child: CurrencyFormField(
                  enabled: _editMode != EditMode.View,
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
                  enabled: _editMode != EditMode.View,
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
              if (loan.payment != null)
                LoanPaymentItem(
                  loanPayment: loan.payment,
                  editable: false,
                ),
              if (_editMode != EditMode.View)
                RaisedButton(
                  child: Text(_editMode.name),
                  onPressed: _handleSubmit,
                ),
              if (_editMode != EditMode.Create)
                RaisedButton(
                  child: Text("Delete"),
                  onPressed: _handleDelete,
                ),
              if (_editMode == EditMode.Update)
                RaisedButton(
                  child: Text("Make Payment"),
                  onPressed: _handleMakePayment,
                )
            ],
          ),
        ),
      ),
    );
  }
}
