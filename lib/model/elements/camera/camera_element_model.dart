import 'package:flutter_form_builder/model/elements/element_model.dart';

enum CameraType { front, rear }

extension CameraTypeExtension on CameraType {
  String get name => toString().split('.').last;
}

class CameraElementModel extends ElementModel {
  final CameraType cameraType;

  CameraElementModel({
    required this.cameraType,
    required super.label,
    required super.key,
    super.hint,
    super.value,
    super.required = false,
  }) : super(type: ElementType.camera);

  @override
  Map<String, dynamic> toJson() {
    return {...super.toJson(), 'cameraType': cameraType.name};
  }

  factory CameraElementModel.fromJson(Map<String, dynamic> json) {
    return CameraElementModel(
      key: json['key'],
      label: json['label'],
      hint: json['hint'],
      value: json['value'],
      required: json['required'] ?? false,
      cameraType: CameraType.values.firstWhere(
        (element) => element.name == json['cameraType'],
        orElse: () => CameraType.rear,
      ),
    );
  }
}
