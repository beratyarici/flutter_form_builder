# Flutter Form Builder

Flutter Form Builder is a Flutter package that allows you to dynamically generate forms based on JSON configurations. It supports validation, various input types, and is designed for flexibility, scalability, and reusability in enterprise or modular applications.

## Features

- Dynamic form creation using JSON schema
- Built-in validation
- Various field types:
  - Text Box
  - Text Area
  - Select Box
  - Multi Select Box
  - Switch Box
  - Check Box
  - Date Picker
  - Camera
  - Document Scanner
  - Hidden Field
  - Radio Box
  - Upload File
- Supports required/optional and read-only fields

## Getting started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_form_builder:
    git:
      url: https://github.com/beratyarici/flutter_form_builder.git
      ref: main
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/model/form_builder_model.dart';
import 'package:form_builder/view/form_builder_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Example form data
    final formData = {
      "title": "User Information",
      "description": "Please fill in your details",
      "submitButtonLabel": "Save",
      "elements": [
        {
          "type": "textBox",
          "key": "userName",
          "label": "Name",
          "keyboardType": "text",
          "required": true,
        },
        {
          "type": "textBox",
          "key": "userSurname",
          "label": "Surname",
          "keyboardType": "text",
          "required": true,
        },
      ],
    };

    // Create a FormBuilderModel instance with the form data
    final form = FormBuilderModel.fromJson(formData);

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('Form Builder Example')),
        body: FormBuilderView(
          form: form,
          onSubmit: (fields, files) async {
            // Handle form submission
          },
        ),
      ),
    );
  }
}
```

## Contact
For any questions or issues, please open an issue on the [GitHub repository](https://github.com/beratyarici/flutter_form_builder/issues).