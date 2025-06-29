import 'package:flutter_form_builder/model/elements/element_model.dart';

class FileUploadElementModel extends ElementModel {
  FileUploadElementModel({
    required super.key,
    required super.label,
    super.value,
    super.required = false,
  }) : super(type: ElementType.fileUpload);

  factory FileUploadElementModel.fromJson(Map<String, dynamic> json) {
    return FileUploadElementModel(
      key: json['key'],
      label: json['label'],
      value: json['value'],
      required: json['required'] ?? false,
    );
  }
}
