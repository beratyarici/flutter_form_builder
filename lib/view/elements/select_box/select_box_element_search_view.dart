import 'package:flutter/material.dart';
import 'package:flutter_form_builder/constants/dimensions.dart';
import 'package:flutter_form_builder/model/elements/element_item_model.dart';
import 'package:flutter_form_builder/view/elements/select_box/select_box_element_search_item_view.dart';

class SelectBoxElementSearchView extends StatefulWidget {
  const SelectBoxElementSearchView({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.onSelected,
  });

  final List<ElementItemModel> items;
  final ElementItemModel? selectedItem;
  final Function(ElementItemModel) onSelected;

  @override
  State<SelectBoxElementSearchView> createState() =>
      _SelectBoxElementSearchViewState();
}

class _SelectBoxElementSearchViewState
    extends State<SelectBoxElementSearchView> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToItem(int index) {
    if (_scrollController.hasClients) {
      final double position =
          index * Dimensions.selectBoxElementSearchItemHeight;

      _scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  String _searchText = '';

  List<ElementItemModel> get _filteredItems {
    return widget.items.where((item) {
      return item.label.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.selectedItem != null) {
        final index = _filteredItems.indexWhere(
          (element) => element.key == widget.selectedItem!.key,
        );

        if (index != -1) {
          _scrollToItem(index);
        }
      }
    });
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
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimensions.padding / 2,
                      ),
                      itemCount: _filteredItems.length,
                      itemBuilder: (context, index) {
                        final item = _filteredItems[index];

                        return SelectBoxElementSearchItemView(
                          item: item,
                          selected: widget.selectedItem?.key == item.key,
                          onSelected: widget.onSelected,
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
