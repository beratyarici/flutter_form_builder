import 'package:flutter/material.dart';
import 'package:flutter_form_builder/constants/dimensions.dart';
import 'package:flutter_form_builder/model/elements/element_item_model.dart';

class SelectBoxElementSearchItemView extends StatelessWidget {
  const SelectBoxElementSearchItemView({
    super.key,
    required this.item,
    required this.selected,
    required this.onSelected,
  });

  final ElementItemModel item;
  final bool selected;
  final Function(ElementItemModel) onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Dimensions.selectBoxElementSearchItemHeight,
      child: Material(
        color: Colors.transparent,
        child: ListTile(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Dimensions.borderRadius),
            ),
          ),
          title: Text(
            item.label,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
            style: TextStyle(
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 14,
            ),
          ),
          minTileHeight: Dimensions.selectBoxElementSearchItemHeight,
          onTap: () {
            onSelected(item);
          },
          selected: selected,
          selectedTileColor: Theme.of(
            context,
          ).colorScheme.primary.withValues(alpha: 0.1),
          selectedColor: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
