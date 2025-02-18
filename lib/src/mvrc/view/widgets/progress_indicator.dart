import 'package:flutter/material.dart';

void showLoading(BuildContext context) {
  debugPrint('showLoading');  
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

void hideLoading(BuildContext context) {
  debugPrint('hideLoading');
  Navigator.of(context).pop();
}

void showErrorSnackbar(BuildContext context, String message) {
  debugPrint('showErrorSnackbar');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.red,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

void showSuccessSnackbar(BuildContext context, String message) {
  debugPrint('showSuccessSnackbar');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ),
  );
}