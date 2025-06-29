import 'package:flutter/material.dart';

import 'package:flutter_form_builder/model/elements/element_model.dart';
import 'package:flutter_form_builder/model/elements/upload/file_upload_element_model.dart';

import 'package:flutter_form_builder/model/form_builder_model.dart';

class FormBuilderProvider with ChangeNotifier {
  FormBuilderProvider({required this.form});

  final FormBuilderModel form;

  String? get title => form.title;

  String? get description => form.description;

  String get submitButtonLabel =>
      form.submitButtonLabel ?? 'Gönder'; // TODO l10n

  List<ElementModel> get elements => form.elements;

  final Map<String, String> _fields = {};

  Map<String, String> get fields => _fields;

  final Map<String, String> _files = {};

  Map<String, String> get files => _files;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  bool validate() {
    if (_formKey.currentState!.validate()) {
      return true;
    }
    return false;
  }

  save() {
    _formKey.currentState!.save();

    _fields.clear();
    _files.clear();

    _fields['FormBuilderID'] = form.id.toString();

    for (final element in elements) {
      if (element.value == null) {
        continue;
      }

      if (element is FileUploadElementModel) {
        _files[element.key] = element.value.toString();
        continue;
      }

      _fields[element.key] = element.value.toString();
    }
  }
}
