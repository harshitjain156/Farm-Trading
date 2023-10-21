import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

const String apiKey = '58b98b48d2c74d9c94dd5dc296ccf7b6';

void showSuccessToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green, // Set the background color for success toast
    textColor: Colors.white, // Set the text color for success toast
  );
}

void showFailureToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red, // Set the background color for failure toast
    textColor: Colors.white, // Set the text color for failure toast
  );
}