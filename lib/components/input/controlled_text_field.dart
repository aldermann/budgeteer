import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ControlledTextField extends StatefulWidget {
  final String value;
  final void Function(String text) onChanged;
  final InputDecoration decoration;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;
  final TextInputAction textInputAction;
  final ValueChanged<String> onSubmitted;
  final bool enabled;

  const ControlledTextField({
    Key key,
    this.value,
    this.decoration,
    this.keyboardType,
    this.inputFormatters,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
    this.enabled,
  }) : super(key: key);

  @override
  _ControlledTextFieldState createState() => _ControlledTextFieldState();
}

class _ControlledTextFieldState extends State<ControlledTextField> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.value =
        _textEditingController.value.copyWith(text: widget.value);
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ControlledTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget != this.widget) {
      if (this._textEditingController.text != this.widget.value) {
        this._textEditingController.value =
            _textEditingController.value.copyWith(text: this.widget.value);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textEditingController,
      onChanged: this.widget.onChanged,
      decoration: this.widget.decoration,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      enabled: widget.enabled,
    );
  }
}
