import 'package:flutter/material.dart';

class PcMediaViewModel extends ChangeNotifier {
  int _pageIndex = 0;
  bool _showIndicators = false;
  int _previewId = 0;

  bool get showIndicators => _showIndicators;
  int get pageIndex => _pageIndex;

  set pageIndex(int value) {
    _pageIndex = value;
    _previewIndicators();
    notifyListeners();
  }

  void _previewIndicators() async {
    _previewId++;
    final id = _previewId;

    _showIndicators = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    if (id != _previewId) return;

    _showIndicators = false;
    _previewId = 0;
    notifyListeners();
  }
}
