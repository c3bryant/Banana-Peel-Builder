import 'package:flutter/material.dart';
import 'package:get/get.dart';

void errorSnack(String message) {
  Get.snackbar(
    'Error',
    '',
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    borderRadius: 20,
    margin: const EdgeInsets.all(10),
    duration: const Duration(seconds: 3),
    messageText: RichText(
      text: TextSpan(
        text: message,
        style:
            const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ),
  );
}
