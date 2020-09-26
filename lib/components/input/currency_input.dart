import 'dart:async';

import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'controlled_text_field.dart';

enum CurrencyInputSign { Positive, Negative }

Currency _convertToCurrency(String input, CurrencyInputSign sign) {
  switch (sign) {
    case CurrencyInputSign.Positive:
      return Currency.fromString(input).positive;
    case CurrencyInputSign.Negative:
      return Currency.fromString(input).negative;
    default:
      return Currency.fromString(input);
  }
}

class CurrencyInput extends StatefulWidget {
  final FormFieldSetter<Currency> onChanged;
  final ValueChanged<Currency> onSubmitted;
  final InputDecoration decoration;
  final TextEditingController controller;
  final String errorText;
  final Currency value;
  final bool enabled;
  final TextInputAction textInputAction;
  final CurrencyInputSign sign;

  CurrencyInput({
    Key key,
    @required this.value,
    @required this.onChanged,
    this.decoration,
    this.controller,
    this.errorText,
    this.enabled,
    this.textInputAction,
    this.onSubmitted,
    this.sign = CurrencyInputSign.Positive,
  }) : super(key: key);

  @override
  _CurrencyInputState createState() => _CurrencyInputState();
}

class _CurrencyInputState extends State<CurrencyInput> {
  @override
  void didUpdateWidget(covariant CurrencyInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.sign != widget.sign) {
      if (widget.sign == CurrencyInputSign.Positive) {
        scheduleMicrotask(() => widget.onChanged(widget.value.positive));
      } else {
        scheduleMicrotask(() => widget.onChanged(widget.value.negative));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String valueString = widget.value?.positive.toString();
    Icon icon = widget.sign == CurrencyInputSign.Positive
        ? Icon(Icons.add, color: Colors.green)
        : Icon(Icons.remove, color: Colors.red);
    return ControlledTextField(
      enabled: widget.enabled,
      value: valueString == "0" ? "" : valueString,
      decoration: widget.decoration.copyWith(icon: icon),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onChanged: (String input) =>
          this.widget.onChanged(_convertToCurrency(input, widget.sign)),
      onSubmitted: (String input) => this.widget.onSubmitted?.call(
            _convertToCurrency(input, widget.sign),
          ),
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
    CurrencyInputSign sign = CurrencyInputSign.Positive,
    bool enabled = true,
  }) : super(
            onSaved: onSaved,
            enabled: enabled,
            validator: validator,
            autovalidate: autovalidate,
            initialValue: initialValue,
            builder: (FormFieldState<Currency> state) {
              return CurrencyInput(
                enabled: enabled,
                value: state?.value,
                sign: sign,
                decoration: decoration.copyWith(
                  errorText: state.errorText,
                ),
                onChanged: state.didChange,
                textInputAction: textInputAction,
                onSubmitted: onSubmitted,
              );
            });
}
