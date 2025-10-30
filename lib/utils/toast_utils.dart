import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastUtils {
  static void success(String message) {
    toastification.show(
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 2),
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      title: Text(message),
      closeOnClick: true,
    );
  }

  static void error(String message) {
    toastification.show(
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 2),
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      title: Text(message),
      closeOnClick: true,
    );
  }
}
