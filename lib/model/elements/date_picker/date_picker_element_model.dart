import 'package:flutter_form_builder/model/elements/element_model.dart';

class DatePickerElementModel extends ElementModel {
  DatePickerElementModel({
    required super.key,
    super.label,
    super.required = false,
    super.readOnly = false,
    super.value,
  }) : super(type: ElementType.datePicker);

  factory DatePickerElementModel.fromJson(Map<String, dynamic> json) {
    return DatePickerElementModel(
      key: json['key'],
      label: json['label'],
      required: json['required'] ?? false,
      readOnly: json['readOnly'] ?? false,
      value: json['value'],
    );
  }
}
