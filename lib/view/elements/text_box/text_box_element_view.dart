import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/model/elements/text_box/text_box_element_model.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class TextBoxElementView extends StatefulWidget {
  const TextBoxElementView({super.key, required this.textBoxElement});

  final TextBoxElementModel textBoxElement;

  @override
  State<TextBoxElementView> createState() => _TextBoxElementViewState();
}

class _TextBoxElementViewState extends State<TextBoxElementView> {
  final FocusNode _node = FocusNode();

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      defaultDoneWidget: Text(
        'Tamam', // TODO l10n
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor: Colors.grey[200],
      actions: [
        KeyboardActionsItem(
          focusNode: _node,
          displayDoneButton: true,
          displayArrows: false,
          onTapAction: () {
            _node.unfocus();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardActions(
      autoScroll: false,
      disableScroll: true,
      config: _buildConfig(context),
      child: TextFormField(
        focusNode: _node,
        decoration: InputDecoration(
          labelText: widget.textBoxElement.label,
          hintText: widget.textBoxElement.hint,
        ),
        initialValue: widget.textBoxElement.value?.toString(),
        enabled: !widget.textBoxElement.readOnly,
        readOnly: widget.textBoxElement.readOnly,
        keyboardType: widget.textBoxElement.keyboardType == KeyboardType.number
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        obscureText: widget.textBoxElement.obscureText,
        textInputAction: TextInputAction.done,
        inputFormatters: [
          if (widget.textBoxElement.keyboardType == KeyboardType.number)
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\,?\d{0,2}')),
        ],
        validator: (value) {
          if (widget.textBoxElement.required) {
            if (widget.textBoxElement.required && value!.isEmpty) {
              return widget.textBoxElement.validation ??
                  'Bu alan boş bırakılamaz'; // TODO l10n
            }
          }

          return null;
        },
        onSaved: (value) {
          widget.textBoxElement.value = value;
        },
      ),
    );
  }
}
