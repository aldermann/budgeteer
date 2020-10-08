import 'package:budgeteer/components/dialog.dart';
import 'package:budgeteer/components/input/currency_input.dart';
import 'package:budgeteer/components/input/ensure_focus.dart';
import 'package:budgeteer/components/input/type_selector.dart';
import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/routes.dart';
import 'package:budgeteer/utils/editor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

import 'component/countdown.dart';
import 'route.dart';

class AddWishItemRouteState extends State<AddWishItemRoute> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode _priceFieldFocusNode = FocusNode();
  FocusNode _nameFieldFocusNode = FocusNode();
  FocusNode _descriptionFieldFocusNode = FocusNode();

  WishItem wishItem;
  EditMode _editMode;
  Currency previousPrice;

  void initState() {
    super.initState();
    if (widget.wishItem != null) {
      wishItem = widget.wishItem;
      previousPrice = wishItem.price;
      _editMode = EditMode.Update;
    } else {
      wishItem = WishItem();
      _editMode = EditMode.Create;
    }
  }

  void _handleSavePrice(Currency price) {
    wishItem.price = price;
  }

  void _handleSaveName(String name) {
    wishItem.name = name;
  }

  void _handleSaveDescription(String description) {
    wishItem.description = description;
  }

  String _validateName(String name) {
    if (name == null || name.isEmpty) {
      return "Please input a name";
    }
    return null;
  }

  void _handleSaveType(ExpenseType type) {
    wishItem.type = type;
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (_editMode == EditMode.Update) {
      if (previousPrice < wishItem.price) {
        bool confirmation = await Dialogs.showConfirmationDialog(
          context: context,
          title: "Are you sure?",
          content:
              "You have increased the price. The wait time will be recalculated",
        );
        if (!confirmation) {
          return;
        }
        wishItem.increaseRemainingTime(previousPrice);
      }
      wishItem.save();
    } else {
      wishItem.setRemainingTime();
      WishList.add(wishItem);
    }
    Navigator.pop(context);
  }

  void _handleGoToPayment() {
    Navigator.pushNamed(
      context,
      AddWishPaymentRoute.config.routePath,
      arguments: wishItem,
    );
  }

  Future<void> _handleDelete() async {
    bool deleted = await wishItem.deleteWithConfirmation(context);
    if (deleted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AddWishItemRoute.config.routeName),
      ),
      body: Container(
        margin: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    if (_editMode == EditMode.Create)
                      Center(
                        child: TypeSelectorFormField<ExpenseType>(
                          values: [
                            ExpenseType.SelfImprovement,
                            ExpenseType.Entertainment,
                          ],
                          initialValue: ExpenseType.SelfImprovement,
                          onSaved: _handleSaveType,
                          onSubmitted: (ExpenseType type) =>
                              _priceFieldFocusNode.requestFocus(),
                        ),
                      ),
                    EnsureVisibleWhenFocused(
                      child: CurrencyFormField(
                        enabled: _editMode != EditMode.View,
                        sign: CurrencyInputSign.Positive,
                        initialValue: wishItem.price,
                        onSaved: _handleSavePrice,
                        decoration: InputDecoration(
                          helperText: "How much is this going to cost?",
                          labelText: "Amount",
                        ),
                        textInputAction: TextInputAction.next,
                        onSubmitted: (Currency price) {
                          _nameFieldFocusNode.requestFocus();
                        },
                      ),
                      focusNode: _priceFieldFocusNode,
                    ),
                    EnsureVisibleWhenFocused(
                      child: TextFormField(
                        enabled: _editMode != EditMode.View,
                        initialValue: wishItem.name,
                        onSaved: _handleSaveName,
                        decoration: InputDecoration(
                          labelText: "Name *",
                          helperText: "Give this wish item a name",
                          icon: Icon(Icons.message),
                        ),
                        onEditingComplete:
                            _descriptionFieldFocusNode.requestFocus,
                        validator: _validateName,
                      ),
                      focusNode: _nameFieldFocusNode,
                    ),
                    EnsureVisibleWhenFocused(
                      child: TextFormField(
                        enabled: _editMode != EditMode.View,
                        initialValue: wishItem.description,
                        keyboardType: TextInputType.multiline,
                        minLines: 5,
                        maxLines: null,
                        onSaved: _handleSaveDescription,
                        decoration: InputDecoration(
                          labelText: "Description",
                          helperText: "Give some description",
                          icon: Icon(Icons.assignment),
                        ),
                      ),
                      focusNode: _descriptionFieldFocusNode,
                    ),
                    if (_editMode != EditMode.Create)
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                        child: Column(
                          children: [
                            Text(
                              "Remaining time for decision",
                              style: theme.textTheme.headline5,
                            ),
                            Countdown.defaultCountDown(item: wishItem),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (_editMode != EditMode.Create && wishItem.isReady)
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Buy this"),
                    onPressed: _handleGoToPayment,
                  ),
                ),
              if (_editMode != EditMode.View)
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text(_editMode.name),
                    onPressed: _handleSubmit,
                  ),
                ),
              if (_editMode != EditMode.Create)
                SizedBox(
                  width: double.infinity,
                  child: RaisedButton(
                    child: Text("Delete"),
                    onPressed: _handleDelete,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
