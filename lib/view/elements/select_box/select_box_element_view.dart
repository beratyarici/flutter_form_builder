import 'package:flutter/material.dart';
import 'package:flutter_form_builder/model/elements/select_box/select_box_element_model.dart';
import 'package:flutter_form_builder/view/elements/select_box/select_box_element_search_field_view.dart';

class SelectBoxElementView extends StatelessWidget {
  const SelectBoxElementView({super.key, required this.selectBoxElement});

  final SelectBoxElementModel selectBoxElement;

  @override
  Widget build(BuildContext context) {
    return SelectBoxElementSearchFieldView(selectBoxElement: selectBoxElement);
  }
}
