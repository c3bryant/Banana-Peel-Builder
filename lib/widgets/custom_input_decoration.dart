import 'package:flutter/material.dart';

InputDecoration getCustomInputDecoration(
    String labelText, bool isFieldFocused, bool isFieldEmpty) {
  return InputDecoration(
    labelText: isFieldFocused || !isFieldEmpty ? '' : labelText,
    labelStyle: const TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.black, // Black label text
    ),
    fillColor: Colors.white, // White background color
    filled: true, // Enable filling the background color
    contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
    focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded corners
      borderSide: BorderSide(
        color: Colors.white,
        width: 2.0,
      ),
    ),
    disabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
    ),
    enabledBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded corners
      borderSide: BorderSide(
        color: Colors.white,
        width: 1.0,
      ),
    ),
    errorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded corners
      borderSide: BorderSide(
        color: Colors.red,
        width: 2.0,
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)), // Rounded corners
      borderSide: BorderSide(
        color: Colors.white,
        width: 2.0,
      ),
    ),
    // helperStyle: const TextStyle(color: Colors.black),
  );
}
