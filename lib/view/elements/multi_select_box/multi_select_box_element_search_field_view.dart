import 'package:flutter/material.dart';
import 'package:flutter_form_builder/model/elements/element_item_model.dart';
import 'package:flutter_form_builder/model/elements/multi_select_box/multi_select_box_element_model.dart';
import 'package:flutter_form_builder/view/elements/multi_select_box/multi_select_box_element_search_view.dart';

class MultiSelectBoxElementSearchFieldView extends StatefulWidget {
  const MultiSelectBoxElementSearchFieldView({
    super.key,
    required this.multiSelectBoxElement,
  });

  final MultiSelectBoxElementModel multiSelectBoxElement;

  @override
  State<MultiSelectBoxElementSearchFieldView> createState() =>
      _MultiSelectBoxElementSearchFieldViewState();
}

class _MultiSelectBoxElementSearchFieldViewState
    extends State<MultiSelectBoxElementSearchFieldView> {
  final List<ElementItemModel> _selectedItemList = [];

  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        if (widget.multiSelectBoxElement.value != null) {
          final selectedItems = widget.multiSelectBoxElement.items
              .where(
                (element) =>
                    (widget.multiSelectBoxElement.value as List<dynamic>)
                        .contains(element.key),
              )
              .toList();

          _selectedItemList.addAll(selectedItems);

          _controller.text = selectedItems.map((e) => e.label).join(', ');
        }
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      controller: _controller,
      validator: (value) {
        if (widget.multiSelectBoxElement.required && value!.isEmpty) {
          return widget.multiSelectBoxElement.validation ??
              'Lütfen bir seçim yapın'; // TODO l10n
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: widget.multiSelectBoxElement.label,
        hintText: widget.multiSelectBoxElement.hint,
      ),
      onTap: () {
        showModalBottomSheet(
          context: context,
          showDragHandle: true,
          useSafeArea: true,
          scrollControlDisabledMaxHeightRatio: 1,
          builder: (context) {
            return MultiSelectBoxElementSearchView(
              items: widget.multiSelectBoxElement.items,
              selectedItemList: _selectedItemList,
              onSelected: (item) {
                setState(() {
                  widget.multiSelectBoxElement.value ??= [];

                  if (!(widget.multiSelectBoxElement.value as List<dynamic>)
                      .contains(item.key)) {
                    (widget.multiSelectBoxElement.value as List<dynamic>).add(
                      item.key,
                    );

                    _selectedItemList.add(item);
                  } else {
                    (widget.multiSelectBoxElement.value as List<dynamic>)
                        .remove(item.key);

                    _selectedItemList.remove(item);
                  }

                  _controller.text = _selectedItemList
                      .map((e) => e.label)
                      .join(', ');
                });
              },
            );
          },
        );
      },
    );
  }
}
