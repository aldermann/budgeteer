import 'package:budgeteer/components/input/currency_input.dart';
import 'package:budgeteer/components/input/ensure_focus.dart';
import 'package:budgeteer/components/input/type_selector.dart';
import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:budgeteer/utils/editor.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'route.dart';

class _SavingType extends BudgetType {
  const _SavingType(String name, IconData icon) : super(name: name, icon: icon);

  static const _SavingType In = const _SavingType("In", Icons.arrow_upward);

  static const _SavingType Out = const _SavingType("Out", Icons.arrow_downward);

  static List<_SavingType> values = [In, Out];
}

class AddSavingRouteState extends State<AddSavingRoute> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _amountFieldFocusNode = FocusNode();
  FocusNode _nameFieldFocusNode = FocusNode();
  Currency _totalFund, _totalSaving;

  Saving saving;
  EditMode _editMode;

  _SavingType _savingType;

  void initState() {
    super.initState();
    if (widget.saving != null) {
      saving = widget.saving;
      _savingType = saving.amount.ge(0) ? _SavingType.In : _SavingType.Out;
      saving.amount = saving.amount.positive;
      _editMode = EditMode.Update;
    } else {
      if (widget.income != null) {
        saving = Saving(amount: widget.income.amount * 0.2);
      } else {
        saving = Saving();
      }
      _savingType = _SavingType.In;
      _editMode = EditMode.Create;
    }

    var res = Budget.calculateFund();
    _totalFund = res.item1;
    _totalSaving = res.item2;
  }

  void _handleSaveAmount(Currency amount) {
    saving.amount = amount;
  }

  String _validateAmount(Currency amount) {
    if (_savingType == _SavingType.In && amount.positive > _totalFund) {
      return "You cannot save more than what you are having";
    }
    if (_savingType == _SavingType.Out && amount.positive > _totalSaving) {
      return "You cannot take out more than what you are saving";
    }
    return null;
  }

  void _handleSaveName(String name) {
    saving.name = name;
  }

  void _handleSaveType(_SavingType type) {
    _savingType = type;
  }

  void _handleChangeType(_SavingType type) {
    setState(() {
      _savingType = type;
    });
  }

  void _handleSubmit() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (_editMode == EditMode.Update) {
      saving.save();
    } else {
      Box<Budget> budgetBox = Budget.getBox();
      budgetBox.add(saving);
    }
    Navigator.pop(context);
  }

  Future<void> _handleDelete() async {
    bool deleted = await saving.deleteWithConfirmation(context);
    if (deleted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AddSavingRoute.config.routeName),
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
                    values: _SavingType.values,
                    initialValue: _SavingType.In,
                    onSaved: _handleSaveType,
                    onChanged: _handleChangeType,
                    onSubmitted: (_SavingType type) {
                      _amountFieldFocusNode.requestFocus();
                    },
                  ),
                ),
              EnsureVisibleWhenFocused(
                child: CurrencyFormField(
                  enabled: _editMode != EditMode.View,
                  sign: _savingType == _SavingType.In
                      ? CurrencyInputSign.Positive
                      : CurrencyInputSign.Negative,
                  initialValue: saving.amount,
                  onSaved: _handleSaveAmount,
                  decoration: InputDecoration(
                    helperText: _savingType == _SavingType.In
                        ? "How much are you saving?"
                        : "How much are you taking out?",
                    labelText: "Amount",
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
                  initialValue: saving.name,
                  onSaved: _handleSaveName,
                  focusNode: _nameFieldFocusNode,
                  decoration: InputDecoration(
                    labelText: "Name",
                    helperText: "Give this saving a name",
                    icon: Icon(Icons.message),
                  ),
                ),
                focusNode: _nameFieldFocusNode,
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
            ],
          ),
        ),
      ),
    );
  }
}
