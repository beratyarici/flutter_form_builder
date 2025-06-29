import 'package:flutter/material.dart';
import 'package:flutter_form_builder/constants/dimensions.dart';
import 'package:flutter_form_builder/model/elements/element_item_model.dart';
import 'package:flutter_form_builder/view/elements/multi_select_box/multi_select_box_element_search_item_view.dart';

class MultiSelectBoxElementSearchView extends StatefulWidget {
  const MultiSelectBoxElementSearchView({
    super.key,
    required this.items,
    required this.selectedItemList,
    required this.onSelected,
  });

  final List<ElementItemModel> items;
  final List<ElementItemModel> selectedItemList;
  final Function(ElementItemModel) onSelected;

  @override
  State<MultiSelectBoxElementSearchView> createState() =>
      _MultiSelectBoxElementSearchViewState();
}

class _MultiSelectBoxElementSearchViewState
    extends State<MultiSelectBoxElementSearchView> {
  String _searchText = '';

  List<ElementItemModel> get _filteredItems {
    final filteredItems = widget.items.where((item) {
      return item.label.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    filteredItems.sort((a, b) {
      final aSelected = widget.selectedItemList.contains(a);
      final bSelected = widget.selectedItemList.contains(b);

      if (aSelected && !bSelected) {
        return -1;
      } else if (!aSelected && bSelected) {
        return 1;
      } else {
        return 0;
      }
    });

    return filteredItems;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: Dimensions.padding,
          right: Dimensions.padding,
          bottom: MediaQuery.of(context).viewInsets.bottom + Dimensions.spacing,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Ara', // TODO l10n
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value;
                });
              },
            ),
            Expanded(
              child: _filteredItems.isEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          color: Colors.grey,
                          size: Dimensions.iconSize * 3,
                        ),
                        Text(
                          'Sonuç Bulunamadı', // TODO l10n
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.padding / 2,
                      ),
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: Dimensions.spacing / 2),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];

                        return MultiSelectBoxElementSearchItemView(
                          item: item,
                          selected: widget.selectedItemList.contains(item),
                          onSelected: (selectedItem) {
                            setState(() {
                              widget.onSelected(selectedItem);
                            });
                          },
                        );
                      },
                    ),
            ),
            const SizedBox(height: Dimensions.spacing),
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Kapat'), // TODO l10n
            ),
          ],
        ),
      ),
    );
  }
}
