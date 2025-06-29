import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/constants/dimensions.dart';
import 'package:flutter_form_builder/model/elements/date_picker/date_picker_element_model.dart';
import 'package:intl/intl.dart';

class DatePickerElementView extends StatefulWidget {
  const DatePickerElementView({super.key, required this.datePickerElement});

  final DatePickerElementModel datePickerElement;

  @override
  State<DatePickerElementView> createState() => _DatePickerElementViewState();
}

class _DatePickerElementViewState extends State<DatePickerElementView> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.text =
          widget.datePickerElement.value != null &&
              (widget.datePickerElement.value is String &&
                  (widget.datePickerElement.value! as String).isNotEmpty)
          ? _formatDate(
              DateTime.parse(widget.datePickerElement.value!),
              context,
            )
          : '';
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: widget.datePickerElement.label,
        suffixIcon: widget.datePickerElement.readOnly == true
            ? null
            : widget.datePickerElement.value != null &&
                  (widget.datePickerElement.value is String &&
                      (widget.datePickerElement.value! as String).isNotEmpty)
            ? Padding(
                padding: const EdgeInsets.only(right: Dimensions.padding / 2),
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _controller.clear();
                      widget.datePickerElement.value = null;
                    });
                  },
                ),
              )
            : null,
      ),
      onTap: () {
        if (widget.datePickerElement.readOnly == true) {
          return;
        }

        _showDatePicker(context);
      },
      onSaved: (value) {
        if (value == null || value.isEmpty) {
          widget.datePickerElement.value = null;
          return;
        }

        widget.datePickerElement.value = DateFormat.yMMMMd(
          Localizations.localeOf(context).languageCode,
        ).parse(value).toIso8601String();
      },
      validator: (value) {
        if (widget.datePickerElement.required) {
          if (value == null || value.isEmpty) {
            return widget.datePickerElement.validation ??
                'Bu alan boş bırakılamaz!'; // TODO l10n
          }
        }
        return null;
      },
    );
  }

  void _showDatePicker(BuildContext context) {
    final DateTime initialDate =
        widget.datePickerElement.value != null &&
            (widget.datePickerElement.value is String &&
                (widget.datePickerElement.value! as String).isNotEmpty)
        ? DateTime.parse(widget.datePickerElement.value!)
        : DateTime.now();

    showCupertinoModalPopup(
      context: context,
      builder: (_) => Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(
              vertical: Dimensions.padding / 4,
              horizontal: Dimensions.padding,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Material(
                  color: Colors.transparent,
                  child: Text(
                    'Tarih Seçin', // TODO l10n
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Tamam'), // TODO l10n
                ),
              ],
            ),
          ),
          Container(
            height: Dimensions.datePickerElementHeight,
            color: Colors.white,
            child: SafeArea(
              top: false,
              child: CupertinoDatePicker(
                backgroundColor: Colors.white,
                initialDateTime: initialDate,
                mode: CupertinoDatePickerMode.date,
                use24hFormat: true,
                showDayOfWeek: false,
                onDateTimeChanged: (DateTime pickedDate) {
                  setState(() {
                    _controller.text = _formatDate(pickedDate, context);
                    widget.datePickerElement.value = pickedDate
                        .toIso8601String();
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _controller.text = _formatDate(initialDate, context);
        widget.datePickerElement.value = initialDate.toIso8601String();
      });
    });
  }

  String _formatDate(DateTime date, BuildContext context) {
    return DateFormat.yMMMMd(
      Localizations.localeOf(context).languageCode,
    ).format(date);
  }
}
