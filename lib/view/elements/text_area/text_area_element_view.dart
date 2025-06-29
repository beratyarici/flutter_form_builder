import 'package:flutter/material.dart';
import 'package:flutter_form_builder/model/elements/text_area/text_area_element_model.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class TextAreaElementView extends StatefulWidget {
  const TextAreaElementView({super.key, required this.textAreaElement});

  final TextAreaElementModel textAreaElement;

  @override
  State<TextAreaElementView> createState() => _TextAreaElementViewState();
}

class _TextAreaElementViewState extends State<TextAreaElementView> {
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
          labelText: widget.textAreaElement.label,
          hintText: widget.textAreaElement.hint,
        ),
        initialValue: widget.textAreaElement.value,
        readOnly: widget.textAreaElement.readOnly,
        maxLines: 3,
        obscureText: widget.textAreaElement.obscureText,
        validator: (value) {
          if (widget.textAreaElement.required) {
            if (widget.textAreaElement.required && value!.isEmpty) {
              return widget.textAreaElement.validation ??
                  'Bu alan boş bırakılamaz'; // TODO l10n
            }
          }

          return null;
        },
        onSaved: (value) {
          widget.textAreaElement.value = value;
        },
      ),
    );
  }
}
