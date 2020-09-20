import 'package:flutter/material.dart';

class TypeSelector<T extends dynamic> extends StatelessWidget {
  final T currentValue;
  final FormFieldSetter<T> onChanged;
  final List<T> values;
  final Map<T, IconData> iconMap;
  final Map<T, String> nameMap;

  TypeSelector({
    this.onChanged,
    this.currentValue,
    @required this.values,
    Map<T, IconData> iconMap,
    Map<T, String> nameMap,
  })  : this.nameMap = nameMap ?? Map<T, String>(),
        this.iconMap = iconMap ?? Map<T, IconData>() {
    try {
      if (this.nameMap.length == 0) {
        this.values.forEach((element) => this.nameMap[element] = element?.name);
      }
    } on NoSuchMethodError {
      if (iconMap == null) {
        throw AssertionError(
          "Your values don't have a 'name' getter so please specify a 'nameMap'",
        );
      }
    }

    try {
      if (this.iconMap.length == 0) {
        this.values.forEach((element) => this.iconMap[element] = element?.icon);
      }
    } on NoSuchMethodError {
      if (iconMap == null) {
        throw AssertionError(
          "Your values don't have a 'icon' getter so please specify a 'iconMap'",
        );
      }
    }
  }

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
                    Icon(iconMap[v]),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(nameMap[v]),
                    ),
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

class TypeSelectorFormField<T extends dynamic> extends FormField<T> {
  TypeSelectorFormField({
    @required List<T> values,
    FormFieldSetter<T> onSaved,
    T initialValue,
    ValueChanged<T> onSubmitted,
    Map<T, IconData> iconMap,
    Map<T, String> nameMap,
  }) : super(
          onSaved: onSaved,
          initialValue: initialValue ?? values.first,
          builder: (FormFieldState<T> state) {
            return TypeSelector<T>(
              onChanged: state.didChange,
              currentValue: state.value,
              values: values,
              iconMap: iconMap,
              nameMap: nameMap,
            );
          },
        );
}
