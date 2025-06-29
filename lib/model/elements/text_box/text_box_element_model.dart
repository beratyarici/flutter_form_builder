import 'package:flutter_form_builder/model/elements/element_model.dart';

enum KeyboardType { text, number }

extension KeyboardTypeExtension on KeyboardType {
  String get name => toString().split('.').last;
}

class TextBoxElementModel extends ElementModel {
  final KeyboardType keyboardType;

  TextBoxElementModel({
    required super.key,
    required super.label,
    super.hint,
    super.value,
    super.required = false,
    super.readOnly = false,
    super.obscureText = false,
    this.keyboardType = KeyboardType.text,
    super.validation,
  }) : super(type: ElementType.textBox);

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'keyboardType': keyboardType.name};
  }

  factory TextBoxElementModel.fromJson(Map<String, dynamic> json) {
    return TextBoxElementModel(
      key: json['key'],
      label: json['label'],
      hint: json['hint'],
      value: json['value'],
      required: json['required'] ?? false,
      readOnly: json['readOnly'] ?? false,
      obscureText: json['obscureText'] ?? false,
      validation: json['validation'],
      keyboardType: KeyboardType.values.firstWhere(
        (e) => e.name == json['keyboardType'],
        orElse: () => KeyboardType.text,
      ),
    );
  }
}
