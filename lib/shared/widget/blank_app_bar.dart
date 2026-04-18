import 'package:flutter/material.dart';

class BlankAppBar extends AppBar {
  BlankAppBar({
    super.key,
    super.actions,
    super.toolbarHeight = 0,
    super.backgroundColor = Colors.white,
    super.foregroundColor = Colors.black,
  });

  @override
  double? get elevation => 0;

  @override
  Color? get shadowColor => Colors.transparent;

  @override
  Color? get surfaceTintColor => Colors.transparent;
}
