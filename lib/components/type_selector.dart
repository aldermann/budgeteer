import 'package:budgeteer/models/budget/budget.dart';
import 'package:flutter/material.dart';

class TypeSelector<T extends BudgetType> extends StatelessWidget {
  final T currentValue;
  final FormFieldSetter<T> onChanged;
  final List<T> values;

  TypeSelector({this.onChanged, this.currentValue, @required this.values});

  @override
  Widget build(BuildContext context) {
    return ToggleButtons(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      children: values
          .map((T v) => Container(
                width: 50,
                margin: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Icon(v.icon),
                    Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(v.name)),
                  ],
                ),
              ))
          .toList(),
      isSelected: values.map((T v) => currentValue == v).toList(),
      onPressed: (index) {
        onChanged(values[index]);
      },
    );
  }
}

class TypeSelectorFormField<T extends BudgetType> extends FormField<T> {
  TypeSelectorFormField({
    @required List<T> values,
    FormFieldSetter<T> onSaved,
    T initialValue,
    ValueChanged<T> onSubmitted,
  }) : super(
          onSaved: onSaved,
          initialValue: initialValue ?? values.first,
          builder: (FormFieldState<T> state) {
            return TypeSelector<T>(
              onChanged: state.didChange,
              currentValue: state.value,
              values: values,
            );
          },
        );
}
