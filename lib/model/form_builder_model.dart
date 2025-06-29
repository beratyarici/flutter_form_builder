import 'package:flutter_form_builder/model/elements/camera/camera_element_model.dart';
import 'package:flutter_form_builder/model/elements/check_box/check_box_element_model.dart';
import 'package:flutter_form_builder/model/elements/date_picker/date_picker_element_model.dart';
import 'package:flutter_form_builder/model/elements/doc_scanner/doc_scanner_element_model.dart';
import 'package:flutter_form_builder/model/elements/element_model.dart';
import 'package:flutter_form_builder/model/elements/hidden/hidden_element_model.dart';
import 'package:flutter_form_builder/model/elements/multi_select_box/multi_select_box_element_model.dart';
import 'package:flutter_form_builder/model/elements/radio_box/radio_box_element_model.dart';
import 'package:flutter_form_builder/model/elements/select_box/select_box_element_model.dart';
import 'package:flutter_form_builder/model/elements/switch_box/switch_box_element_model.dart';
import 'package:flutter_form_builder/model/elements/text_area/text_area_element_model.dart';
import 'package:flutter_form_builder/model/elements/text_box/text_box_element_model.dart';
import 'package:flutter_form_builder/model/elements/upload/file_upload_element_model.dart';

class FormBuilderModel {
  final int id;
  final String? title;
  final String? description;
  final String? submitButtonLabel;
  final List<ElementModel> elements;

  FormBuilderModel({
    required this.id,
    this.title,
    this.description,
    this.submitButtonLabel,
    required this.elements,
  });

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'title': title,
      'description': description,
      'submitButtonLabel': submitButtonLabel,
      'elements': elements.map((element) => element.toJson()).toList(),
    };
  }

  factory FormBuilderModel.fromJson(Map<String, dynamic> json) {
    return FormBuilderModel(
      id: json['ID'] is int ? json['ID'] : int.parse(json['ID']),
      title: json['title'],
      description: json['description'],
      submitButtonLabel: json['submitButtonLabel'],
      elements: (json['elements'] as List).map((element) {
        if (element['type'] == ElementType.textBox.name) {
          return TextBoxElementModel.fromJson(element);
        } else if (element['type'] == ElementType.textArea.name) {
          return TextAreaElementModel.fromJson(element);
        } else if (element['type'] == ElementType.selectBox.name) {
          return SelectBoxElementModel.fromJson(element);
        } else if (element['type'] == ElementType.multiSelectBox.name) {
          return MultiSelectBoxElementModel.fromJson(element);
        } else if (element['type'] == ElementType.radioBox.name) {
          return RadioBoxElementModel.fromJson(element);
        } else if (element['type'] == ElementType.checkBox.name) {
          return CheckBoxElementModel.fromJson(element);
        } else if (element['type'] == ElementType.switchBox.name) {
          return SwitchBoxElementModel.fromJson(element);
        } else if (element['type'] == ElementType.fileUpload.name) {
          return FileUploadElementModel.fromJson(element);
        } else if (element['type'] == ElementType.datePicker.name) {
          return DatePickerElementModel.fromJson(element);
        } else if (element['type'] == ElementType.camera.name) {
          return CameraElementModel.fromJson(element);
        } else if (element['type'] == ElementType.docScanner.name) {
          return DocScannerElementModel.fromJson(element);
        } else if (element['type'] == ElementType.hidden.name) {
          return HiddenInputElementModel.fromJson(element);
        } else {
          return ElementModel.fromJson(element);
        }
      }).toList(),
    );
  }
}
