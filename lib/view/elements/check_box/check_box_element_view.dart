import 'package:flutter/material.dart';
import 'package:flutter_form_builder/constants/dimensions.dart';
import 'package:flutter_form_builder/model/elements/check_box/check_box_element_model.dart';

class CheckBoxElementView extends StatefulWidget {
  const CheckBoxElementView({super.key, required this.checkBoxElement});

  final CheckBoxElementModel checkBoxElement;

  @override
  State<CheckBoxElementView> createState() => _CheckBoxElementViewState();
}

class _CheckBoxElementViewState extends State<CheckBoxElementView> {
  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: widget.checkBoxElement.value,
      validator: (value) {
        if (widget.checkBoxElement.required && value == null) {
          return widget.checkBoxElement.validation ??
              'Bu alan boş bırakılamaz!'; // TODO l10n
        }

        return null;
      },
      onSaved: (value) {
        widget.checkBoxElement.value = value;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  widget.checkBoxElement.value =
                      !(widget.checkBoxElement.value ?? false);

                  state.didChange(widget.checkBoxElement.value);
                });
              },
              child: Row(
                children: [
                  Checkbox(
                    value: widget.checkBoxElement.value ?? false,
                    onChanged: (value) {
                      setState(() {
                        widget.checkBoxElement.value = value;

                        state.didChange(value);
                      });
                    },
                  ),
                  if (widget.checkBoxElement.label != null)
                    Text(widget.checkBoxElement.label!),
                ],
              ),
            ),
            if (state.hasError)
              Padding(
                padding: const EdgeInsets.only(
                  top: Dimensions.padding / 3,
                  left: Dimensions.padding,
                ),
                child: Text(
                  state.errorText ?? '',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
