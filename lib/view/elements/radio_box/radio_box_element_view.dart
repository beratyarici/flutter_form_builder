import 'package:flutter/material.dart';
import 'package:flutter_form_builder/constants/dimensions.dart';
import 'package:flutter_form_builder/model/elements/radio_box/radio_box_element_model.dart';

class RadioBoxElementView extends StatefulWidget {
  const RadioBoxElementView({super.key, required this.radioBoxElement});

  final RadioBoxElementModel radioBoxElement;

  @override
  State<RadioBoxElementView> createState() => _RadioBoxElementViewState();
}

class _RadioBoxElementViewState extends State<RadioBoxElementView> {
  @override
  Widget build(BuildContext context) {
    return FormField(
      initialValue: widget.radioBoxElement.value,
      validator: (value) {
        if (widget.radioBoxElement.required && value == null) {
          return widget.radioBoxElement.validation ??
              'Lütfen bir seçim yapın'; // TODO l10n
        }

        return null;
      },
      onSaved: (value) {
        widget.radioBoxElement.value = value;
      },
      enabled: widget.radioBoxElement.readOnly ? false : true,
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.radioBoxElement.label != null) ...[
            Text(
              widget.radioBoxElement.label!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Dimensions.spacing),
          ],
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: state.hasError
                    ? Theme.of(context).colorScheme.error
                    : Colors.grey.withValues(alpha: 0.5),
                width: state.hasError
                    ? Dimensions.borderWidth
                    : Dimensions.borderWidth / 2,
              ),
              borderRadius: BorderRadius.circular(Dimensions.borderRadius),
            ),
            child: Column(
              children: [
                ...widget.radioBoxElement.items.map((item) {
                  return GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      setState(() {
                        widget.radioBoxElement.value = item.key;
                        state.didChange(item.key);
                      });
                    },
                    child: Row(
                      children: [
                        Radio<String?>(
                          value: item.key,
                          groupValue: widget.radioBoxElement.value,
                          onChanged: (value) {
                            setState(() {
                              widget.radioBoxElement.value = item.key;
                              state.didChange(item.key);
                            });
                          },
                        ),
                        Text(item.label),
                      ],
                    ),
                  );
                }),
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
      ),
    );
  }
}
