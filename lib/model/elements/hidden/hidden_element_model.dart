import 'package:flutter_form_builder/model/elements/element_model.dart';

class HiddenInputElementModel extends ElementModel {
  HiddenInputElementModel({
    required super.label,
    required super.value,
    required super.key,
    super.required = false,
    super.readOnly = false,
    super.validation,
  }) : super(type: ElementType.hidden);

  factory HiddenInputElementModel.fromJson(Map<String, dynamic> json) {
    return HiddenInputElementModel(
      key: json['key'],
      label: json['label'],
      value: json['value'],
      required: json['required'] ?? false,
      readOnly: json['readOnly'] ?? false,
      validation: json['validation'],
    );
  }
}
