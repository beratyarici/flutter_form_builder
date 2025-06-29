import 'package:flutter_form_builder/model/elements/element_model.dart';

class CheckBoxElementModel extends ElementModel {
  CheckBoxElementModel({
    required super.label,
    required super.value,
    required super.key,
    super.required = false,
    super.readOnly = false,
    super.validation,
  }) : super(type: ElementType.checkBox);

  factory CheckBoxElementModel.fromJson(Map<String, dynamic> json) {
    return CheckBoxElementModel(
      key: json['key'],
      label: json['label'],
      value: json['value'],
      required: json['required'] ?? false,
      readOnly: json['readOnly'] ?? false,
      validation: json['validation'],
    );
  }
}
