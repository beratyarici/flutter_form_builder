import 'package:flutter_form_builder/model/elements/element_model.dart';

class DocScannerElementModel extends ElementModel {
  DocScannerElementModel({
    required super.label,
    required super.key,
    super.hint,
    super.value,
    super.required = false,
  }) : super(type: ElementType.docScanner);

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson()};
  }

  factory DocScannerElementModel.fromJson(Map<String, dynamic> json) {
    return DocScannerElementModel(
      key: json['key'],
      label: json['label'],
      hint: json['hint'],
      value: json['value'],
      required: json['required'] ?? false,
    );
  }
}
