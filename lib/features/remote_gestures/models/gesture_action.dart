import 'package:flutter/material.dart';

class GestureAction {
  final VoidCallback? onUpdate;
  final VoidCallback? onEnd;

  GestureAction({
    this.onUpdate,
    this.onEnd,
  });
}
