import 'package:flutter_form_builder/model/elements/element_model.dart';

class TextAreaElementModel extends ElementModel {
  TextAreaElementModel({
    required super.key,
    required super.label,
    super.hint,
    super.value,
    super.required = false,
    super.readOnly = false,
    super.obscureText = false,
    super.validation,
  }) : super(type: ElementType.textArea);

  factory TextAreaElementModel.fromJson(Map<String, dynamic> json) {
    return TextAreaElementModel(
      key: json['key'],
      label: json['label'],
      hint: json['hint'],
      value: json['value'],
      required: json['required'] ?? false,
      readOnly: json['readOnly'] ?? false,
      obscureText: json['obscureText'] ?? false,
      validation: json['validation'],
    );
  }
}
