import 'package:flutter/material.dart';
import 'package:flutter_form_builder/model/elements/multi_select_box/multi_select_box_element_model.dart';
import 'package:flutter_form_builder/view/elements/multi_select_box/multi_select_box_element_search_field_view.dart';

class MultiSelectBoxElementView extends StatelessWidget {
  const MultiSelectBoxElementView({
    super.key,
    required this.multiSelectBoxElement,
  });

  final MultiSelectBoxElementModel multiSelectBoxElement;

  @override
  Widget build(BuildContext context) {
    return MultiSelectBoxElementSearchFieldView(
      multiSelectBoxElement: multiSelectBoxElement,
    );
  }
}
