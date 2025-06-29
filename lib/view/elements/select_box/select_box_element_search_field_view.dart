import 'package:flutter/material.dart';
import 'package:flutter_form_builder/model/elements/element_item_model.dart';
import 'package:flutter_form_builder/model/elements/select_box/select_box_element_model.dart';
import 'package:flutter_form_builder/view/elements/select_box/select_box_element_search_view.dart';

class SelectBoxElementSearchFieldView extends StatefulWidget {
  const SelectBoxElementSearchFieldView({
    super.key,
    required this.selectBoxElement,
  });

  final SelectBoxElementModel selectBoxElement;

  @override
  State<SelectBoxElementSearchFieldView> createState() =>
      _SelectBoxElementSearchFieldViewState();
}

class _SelectBoxElementSearchFieldViewState
    extends State<SelectBoxElementSearchFieldView> {
  ElementItemModel? _selectedItem;

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        _selectedItem =
            widget.selectBoxElement.items.any(
              (element) => element.key == widget.selectBoxElement.value,
            )
            ? widget.selectBoxElement.items.firstWhere(
                (element) => element.key == widget.selectBoxElement.value,
              )
            : null;

        _controller.text = _selectedItem?.label ?? '';
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: _controller,
      validator: (value) {
        if (widget.selectBoxElement.required && value!.isEmpty) {
          return widget.selectBoxElement.validation ??
              'Lütfen bir seçim yapınız';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: widget.selectBoxElement.label,
        hintText: widget.selectBoxElement.hint,
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          useSafeArea: true,
          scrollControlDisabledMaxHeightRatio: 1,
          builder: (context) {
            return SelectBoxElementSearchView(
              items: widget.selectBoxElement.items,
              selectedItem: _selectedItem,
              onSelected: (item) {
                setState(() {
                  widget.selectBoxElement.value = item.key;

                  _selectedItem = item;

                  _controller.text = item.label;

                  Navigator.pop(context);
                });
              },
            );
          },
        );
      },
    );
  }
}
