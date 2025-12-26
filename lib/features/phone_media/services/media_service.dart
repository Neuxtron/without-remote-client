import 'package:flutter/services.dart';
import 'package:volume_controller/volume_controller.dart';

class MediaService {
  // OPTIMIZE: store volume in a global variable
  double get _updateAmount => .05;
  static const _channel = MethodChannel('media_control');

  /// Prevents action when device is not responding
  bool _ready = true;

  VolumeController get _controller => VolumeController.instance;

  void volumeUp() {
    _runOnReady(() async {
      final volume = await _controller.getVolume();
      _controller.setVolume(volume + _updateAmount);
    });
  }

  void volumeDown() {
    _runOnReady(() async {
      final volume = await _controller.getVolume();
      _controller.setVolume(volume - _updateAmount);
    });
  }

  void playPause() {
    _runOnReady(() async {
      await _channel.invokeMethod('playPause');
    });
  }

  void playNext() {
    _runOnReady(() async {
      await _channel.invokeMethod('next');
    });
  }

  void playPrevious() {
    _runOnReady(() async {
      await _channel.invokeMethod('previous');
    });
  }

  void _runOnReady(Future Function() func) async {
    if (!_ready) return;
    _ready = false;
    await func();
    _ready = true;
  }
}
