import 'package:flutter/material.dart';

class ItemForm extends StatelessWidget {
  final dynamic entity;
  final Function(Map<String, dynamic>) onSubmit;

  ItemForm({
    required this.entity,
    required this.onSubmit,
  });

  final _formKey = GlobalKey<FormState>();

  // Map to hold the controllers for each field
  final Map<String, TextEditingController> _controllers = {};

  String? validateInput(String? value, dynamic initialValue) {
    if (initialValue == null) {
      debugPrint('ERROR: Initial value is null');
      throw 'Initial value cannot be null';
    }
    if (value == null || value.isEmpty) {
      return 'Please enter a value';
    }
    if (initialValue is int && int.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    if (initialValue is double && double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    if (initialValue is bool && value != 'true' && value != 'false') {
      return 'Please enter true or false';
    }
    // if (initialValue is List && (value[0] != '[' || value[value.length - 1] != ']')) {
    //   return 'Please enter a valid list';
    // }
    // if (initialValue is Map && (value[0] != '{' || value[value.length - 1] != '}')) {
    //   return 'Please enter a valid map';
    // }
    // if (initialValue is DateTime && DateTime.tryParse(value) == null) {
    //   return 'Please enter a valid date';
    // }
    return null;
  }

  generateFormFields() {
    Map<String, dynamic> entityMap = entity.toJson();
    List<Widget> formFields = [];
    for (var key in entityMap.keys) {
      if (key == 'id') {
        continue;
      }
      var initialValue = entityMap[key];
      if ((initialValue is int && initialValue == 0) ||
          (initialValue is String && initialValue == '')) {
        initialValue = '';
      }
      
      final textController = TextEditingController(text: initialValue.toString());
      _controllers[key] = textController;

      formFields.add(
        TextFormField(
          controller: textController,
          decoration: InputDecoration(
            labelText: key.toUpperCase(),
          ),
          validator: (value) {
            return validateInput(value, initialValue);
          },
        ),
      );
    }
    return formFields;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> entityMap = entity.toJson();
    List<Widget> formFields = generateFormFields();

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            ...formFields,
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Update the entityMap with controller values
                  _controllers.forEach((key, controller) {
                    entityMap[key] = controller.text;
                  });
                  onSubmit(entityMap);
                }
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
