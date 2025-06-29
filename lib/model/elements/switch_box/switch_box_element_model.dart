import 'package:flutter_form_builder/model/elements/element_model.dart';

class SwitchBoxElementModel extends ElementModel {
  SwitchBoxElementModel({
    required super.key,
    required super.label,
    super.value,
    super.required = false,
    super.readOnly = false,
    super.validation,
  }) : super(type: ElementType.switchBox);

  factory SwitchBoxElementModel.fromJson(Map<String, dynamic> json) {
    return SwitchBoxElementModel(
      key: json['key'],
      label: json['label'],
      value: json['value'],
      required: json['required'] ?? false,
      readOnly: json['readOnly'] ?? false,
      validation: json['validation'],
    );
  }
}
