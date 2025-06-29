import 'package:flutter/material.dart';
import 'package:flutter_form_builder/constants/dimensions.dart';
import 'package:flutter_form_builder/model/elements/camera/camera_element_model.dart';
import 'package:flutter_form_builder/model/elements/check_box/check_box_element_model.dart';
import 'package:flutter_form_builder/model/elements/date_picker/date_picker_element_model.dart';
import 'package:flutter_form_builder/model/elements/doc_scanner/doc_scanner_element_model.dart';
import 'package:flutter_form_builder/model/elements/multi_select_box/multi_select_box_element_model.dart';
import 'package:flutter_form_builder/model/elements/radio_box/radio_box_element_model.dart';
import 'package:flutter_form_builder/model/elements/select_box/select_box_element_model.dart';
import 'package:flutter_form_builder/model/elements/switch_box/switch_box_element_model.dart';
import 'package:flutter_form_builder/model/elements/text_area/text_area_element_model.dart';
import 'package:flutter_form_builder/model/elements/text_box/text_box_element_model.dart';
import 'package:flutter_form_builder/model/elements/upload/file_upload_element_model.dart';
import 'package:flutter_form_builder/model/form_builder_model.dart';
import 'package:flutter_form_builder/provider/form_builder_provider.dart';
import 'package:flutter_form_builder/view/elements/camera/camera_element_view.dart';
import 'package:flutter_form_builder/view/elements/check_box/check_box_element_view.dart';
import 'package:flutter_form_builder/view/elements/date_picker/date_picker_element_view.dart';
import 'package:flutter_form_builder/view/elements/doc_scanner/doc_scanner_element_view.dart';
import 'package:flutter_form_builder/view/elements/multi_select_box/multi_select_box_element_search_field_view.dart';
import 'package:flutter_form_builder/view/elements/radio_box/radio_box_element_view.dart';
import 'package:flutter_form_builder/view/elements/select_box/select_box_element_view.dart';
import 'package:flutter_form_builder/view/elements/switch_box/switch_box_element_view.dart';
import 'package:flutter_form_builder/view/elements/text_area/text_area_element_view.dart';
import 'package:flutter_form_builder/view/elements/file_upload/file_upload_element_view.dart';
import 'package:flutter_form_builder/view/elements/text_box/text_box_element_view.dart';
import 'package:provider/provider.dart';

class FormBuilderView extends StatefulWidget {
  const FormBuilderView({
    super.key,
    required this.form,
    required this.onSubmit,
  });

  final FormBuilderModel form;
  final Future<void> Function({
    Map<String, String> fields,
    Map<String, String> files,
  })
  onSubmit;

  @override
  State<FormBuilderView> createState() => _FormBuilderViewState();
}

class _FormBuilderViewState extends State<FormBuilderView> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FormBuilderProvider>(
      create: (context) => FormBuilderProvider(form: widget.form),
      child: Consumer<FormBuilderProvider>(
        builder: (context, provider, child) {
          return GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: Form(
              key: provider.formKey,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom:
                      MediaQuery.of(context).viewInsets.bottom +
                      Dimensions.spacing,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (provider.title != null)
                      Text(
                        provider.title!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    if (provider.description != null)
                      Text(
                        provider.description!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    const SizedBox(height: Dimensions.spacing),
                    Column(
                      children: [
                        ...provider.elements
                            .map((element) {
                              if (element is TextBoxElementModel) {
                                return TextBoxElementView(
                                  textBoxElement: element,
                                );
                              } else if (element is TextAreaElementModel) {
                                return TextAreaElementView(
                                  textAreaElement: element,
                                );
                              } else if (element is SelectBoxElementModel) {
                                return SelectBoxElementView(
                                  selectBoxElement: element,
                                );
                              } else if (element
                                  is MultiSelectBoxElementModel) {
                                return MultiSelectBoxElementSearchFieldView(
                                  multiSelectBoxElement: element,
                                );
                              } else if (element is RadioBoxElementModel) {
                                return RadioBoxElementView(
                                  radioBoxElement: element,
                                );
                              } else if (element is CheckBoxElementModel) {
                                return CheckBoxElementView(
                                  checkBoxElement: element,
                                );
                              } else if (element is SwitchBoxElementModel) {
                                return SwitchBoxElementView(
                                  switchBoxElement: element,
                                );
                              } else if (element is FileUploadElementModel) {
                                return FileUploadElementView(
                                  uploadElement: element,
                                );
                              } else if (element is DatePickerElementModel) {
                                return DatePickerElementView(
                                  datePickerElement: element,
                                );
                              } else if (element is CameraElementModel) {
                                return CameraElementView(
                                  cameraElement: element,
                                );
                              } else if (element is DocScannerElementModel) {
                                return DocScannerElementView(
                                  docScannerElement: element,
                                );
                              }

                              return const SizedBox();
                            })
                            .map((element) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                  bottom: Dimensions.spacing,
                                ),
                                child: element,
                              );
                            }),
                      ],
                    ),
                    const SizedBox(height: Dimensions.spacing),
                    ElevatedButton(
                      onPressed: _isSubmitting
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();

                              if (provider.validate()) {
                                setState(() {
                                  _isSubmitting = true;
                                });

                                try {
                                  provider.save();

                                  await widget.onSubmit(
                                    fields: provider.fields,
                                    files: provider.files,
                                  );
                                } finally {
                                  setState(() {
                                    _isSubmitting = false;
                                  });
                                }
                              }
                            },
                      child: _isSubmitting
                          ? const CircularProgressIndicator()
                          : Text(provider.submitButtonLabel),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
