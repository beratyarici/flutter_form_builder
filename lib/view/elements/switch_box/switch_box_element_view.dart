import 'package:flutter/material.dart';
import 'package:flutter_form_builder/constants/dimensions.dart';
import 'package:flutter_form_builder/model/elements/switch_box/switch_box_element_model.dart';

class SwitchBoxElementView extends StatefulWidget {
  const SwitchBoxElementView({super.key, required this.switchBoxElement});

  final SwitchBoxElementModel switchBoxElement;

  @override
  State<SwitchBoxElementView> createState() => _SwitchBoxElementViewState();
}

class _SwitchBoxElementViewState extends State<SwitchBoxElementView> {
  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: widget.switchBoxElement.value,
      validator: (value) {
        if (widget.switchBoxElement.required && value == null) {
          return widget.switchBoxElement.validation ??
              'Bu alan boş bırakılamaz'; // TODO l10n
        }

        return null;
      },
      onSaved: (value) {
        widget.switchBoxElement.value = value;
      },
      builder: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  widget.switchBoxElement.value =
                      !(widget.switchBoxElement.value ?? false);

                  state.didChange(widget.switchBoxElement.value);
                });
              },
              child: Row(
                children: [
                  Switch(
                    value: widget.switchBoxElement.value ?? false,
                    onChanged: (value) {
                      setState(() {
                        widget.switchBoxElement.value = value;

                        state.didChange(widget.switchBoxElement.value);
                      });
                    },
                  ),
                  if (widget.switchBoxElement.label != null)
                    Text(widget.switchBoxElement.label!),
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
