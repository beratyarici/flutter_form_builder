enum ElementType {
  textBox,
  textArea,
  selectBox,
  multiSelectBox,
  radioBox,
  checkBox,
  switchBox,
  datePicker,
  fileUpload,
  camera,
  docScanner,
  hidden,
}

extension ElementTypeExtension on ElementType {
  String get name => toString().split('.').last;
}

class ElementModel {
  String key;
  ElementType type;
  String? label;
  String? hint;
  dynamic value;
  bool required;
  bool readOnly;
  bool obscureText;
  String? validation;

  ElementModel({
    required this.key,
    required this.type,
    this.label,
    this.hint,
    this.value,
    this.required = false,
    this.readOnly = false,
    this.obscureText = false,
    this.validation,
  });

  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'type': type.name,
      'label': label,
      'hint': hint,
      'value': value,
      'required': required,
      'readOnly': readOnly,
      'obscureText': obscureText,
      'validation': validation,
    };
  }

  factory ElementModel.fromJson(Map<String, dynamic> json) {
    return ElementModel(
      key: json['key'],
      type: ElementType.values.firstWhere((e) => e.name == json['type']),
      label: json['label'],
      hint: json['hint'],
      value: json['value'],
      required: json['required'],
      readOnly: json['readOnly'],
      obscureText: json['obscureText'] ?? false,
      validation: json['validation'],
    );
  }

  dynamic get typedValue {
    switch (type) {
      case ElementType.textBox:
        return value as String?;
      case ElementType.textArea:
        return value as String?;
      case ElementType.radioBox:
        return value as String?;
      case ElementType.checkBox:
        return value as bool?;
      case ElementType.switchBox:
        return value as bool?;
      case ElementType.selectBox:
        return value as String?;
      case ElementType.multiSelectBox:
        return value as List<String>?;
      case ElementType.datePicker:
        return value as DateTime?;
      case ElementType.fileUpload:
        return value as String?;
      case ElementType.camera:
        return value as String?;
      case ElementType.docScanner:
        return value as String?;
      case ElementType.hidden:
        return value;
    }
  }
}
