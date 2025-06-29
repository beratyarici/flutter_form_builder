import 'package:flutter_form_builder/model/elements/element_item_model.dart';
import 'package:flutter_form_builder/model/elements/element_model.dart';

class MultiSelectBoxElementModel extends ElementModel {
  final List<ElementItemModel> items;

  MultiSelectBoxElementModel({
    required super.key,
    required super.label,
    super.value,
    super.required = false,
    super.readOnly = false,
    required this.items,
    super.validation,
  }) : super(type: ElementType.selectBox);

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'items': items.map((e) => e.toJson()).toList()};
  }

  factory MultiSelectBoxElementModel.fromJson(Map<String, dynamic> json) {
    return MultiSelectBoxElementModel(
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
