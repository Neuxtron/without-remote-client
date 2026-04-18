import 'package:flutter/material.dart';

class RemoteMode {
  final VoidCallback onDoubleTap;
  final IconData icon;
  final String label;

  RemoteMode({
    required this.onDoubleTap,
    required this.icon,
    required this.label,
  });
}
