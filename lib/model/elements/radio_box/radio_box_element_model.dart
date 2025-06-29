import 'package:flutter_form_builder/model/elements/element_item_model.dart';
import 'package:flutter_form_builder/model/elements/element_model.dart';

class RadioBoxElementModel extends ElementModel {
  final List<ElementItemModel> items;

  RadioBoxElementModel({
    required this.items,
    required super.label,
    required super.key,
    super.value,
    super.required = false,
    super.readOnly = false,
    super.validation,
  }) : super(type: ElementType.radioBox);

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'items': items.map((e) => e.toJson()).toList()};
  }

  factory RadioBoxElementModel.fromJson(Map<String, dynamic> json) {
    return RadioBoxElementModel(
      key: json['key'],
      label: json['label'],
      value: json['value'],
      required: json['required'] ?? false,
      readOnly: json['readOnly'] ?? false,
      validation: json['validation'],
      items: (json['items'] as List)
          .map((e) => ElementItemModel.fromJson(e))
          .toList(),
    );
  }
}
