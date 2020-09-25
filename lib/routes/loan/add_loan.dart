import 'package:budgeteer/components/budget/loan_item.dart';
import 'package:budgeteer/components/input/currency_input.dart';
import 'package:budgeteer/components/input/ensure_focus.dart';
import 'package:budgeteer/components/input/type_selector.dart';
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

class AddLoanRouteState extends State<AddLoanRoute> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _amountFieldFocusNode = FocusNode();
  FocusNode _nameFieldFocusNode = FocusNode();
  Currency _totalFund;
  Loan loan;
  _LoanType _loanType;
  EditMode _editMode;

  void initState() {
    super.initState();
    if (widget.loan != null) {
      loan = widget.loan;
      _loanType = loan.amount.gt(0) ? _LoanType.Get : _LoanType.Give;
      loan.amount = loan.amount.positive;
      if (loan.payment != null) {
        _editMode = EditMode.View;
      } else {
        _editMode = EditMode.Update;
      }
    } else {
      loan = Loan();
      _loanType = _LoanType.Give;
      _editMode = EditMode.Create;
    }
    _totalFund = Budget.calculateFund().item1;
  }

  void _handleSaveAmount(Currency amount) {
    loan.amount = amount;
  }

  String _validateAmount(Currency amount) {
    if (_loanType == _LoanType.Give && amount.positive > _totalFund) {
      return "You cannot give more than what you are having";
    }
    return null;
  }

  void _handleSaveName(String name) {
    loan.name = name;
  }

  String _validateName(String name) {
    if (name == null || name.isEmpty) {
      return "Please input something";
    }
    return null;
  }

  void _handleSaveType(_LoanType type) {
    _loanType = type;
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
    Navigator.popUntil(
        context, ModalRoute.withName(HomeRoute.config.routePath));
  }

  Future<void> _handleDelete() async {
    bool deleted = await loan.deleteWithConfirmation(context);
    if (deleted) {
      Navigator.popUntil(
          context, ModalRoute.withName(HomeRoute.config.routePath));
    }
  }

  void _handleChangeType(_LoanType type) {
    setState(() {
      _loanType = type;
    });
  }

  void _handleMakePayment() {
    Navigator.pushNamed(context, AddLoanPaymentRoute.config.routePath,
        arguments: loan);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AddLoanRoute.config.routeName),
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
                    initialValue: _loanType,
                    iconMap: _LoanIconMap,
                    nameMap: _LoanNameMap,
                    onSaved: _handleSaveType,
                    onChanged: _handleChangeType,
                    onSubmitted: (_LoanType type) {
                      _amountFieldFocusNode.requestFocus();
                    },
                  ),
                ),
              EnsureVisibleWhenFocused(
                child: CurrencyFormField(
                  enabled: _editMode != EditMode.View,
                  sign: _loanType == _LoanType.Give
                      ? CurrencyInputSign.Negative
                      : CurrencyInputSign.Positive,
                  initialValue: loan.amount,
                  onSaved: _handleSaveAmount,
                  decoration: InputDecoration(
                    helperText: _loanType == _LoanType.Give
                        ? "How much are you lending?"
                        : "How much are you borrowing?",
                    labelText: "Amount *",
                  ),
                  textInputAction: TextInputAction.next,
                  onSubmitted: (Currency currency) {
                    _nameFieldFocusNode.requestFocus();
                  },
                  validator: _validateAmount,
                ),
                focusNode: _amountFieldFocusNode,
              ),
              EnsureVisibleWhenFocused(
                child: TextFormField(
                  enabled: _editMode != EditMode.View,
                  initialValue: loan.name,
                  onSaved: _handleSaveName,
                  focusNode: _nameFieldFocusNode,
                  decoration: InputDecoration(
                    labelText: "Name *",
                    helperText: _loanType == _LoanType.Give
                        ? "Who are you lending?"
                        : "Who are you borrowing from?",
                    icon: Icon(Icons.message),
                  ),
                  validator: _validateName,
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
