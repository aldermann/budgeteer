import 'package:budgeteer/models/currency/currency.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controlled_text_field.dart';

class CurrencyInput extends StatelessWidget {
  final FormFieldSetter<Currency> onChanged;
  final InputDecoration decoration;
  final TextEditingController controller;
  final String errorText;
  final Currency value;

  CurrencyInput({
    Key key,
    this.value,
    this.onChanged,
    this.decoration,
    this.controller,
    this.errorText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String valueString = value.toString();
    return ControlledTextField(
      value: valueString == "0" ? "" : valueString,
      decoration: decoration,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (String input) => this.onChanged(Currency.fromString(input)),
    );
  }
}

class CurrencyFormField extends FormField<Currency> {
  CurrencyFormField({
    FormFieldSetter<Currency> onSaved,
    FormFieldValidator<Currency> validator,
    Currency initialValue = Currency.zero,
    bool autovalidate = false,
    InputDecoration decoration,
    TextInputAction textInputAction,
    ValueChanged<Currency> onSubmitted,
  }) : super(
            onSaved: onSaved,
            validator: validator,
            autovalidate: autovalidate,
            initialValue: initialValue,
            builder: (FormFieldState<Currency> state) {
              return ControlledTextField(
                value: state.value.toString(),
                decoration: decoration.copyWith(
                  errorText: state.errorText,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (String input) => state.didChange(
                  Currency.fromString(input),
                ),
                textInputAction: textInputAction,
                onSubmitted: (String input) => onSubmitted(
                  Currency.fromString(input),
                ),
              );
            });
}
