import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:without_remote_client/core/services/socket_service.dart';

class RemoteGesturesPage extends StatefulWidget {
  const RemoteGesturesPage({super.key, required this.socketService});
  final SocketService socketService;

  @override
  State<RemoteGesturesPage> createState() => _RemoteGesturesPageState();
}

class _RemoteGesturesPageState extends State<RemoteGesturesPage> {
  double get _swipeThreshold => 75;

  double _brightness = 1.0;
  bool _useMedia = true;
  Offset _startPosition = Offset.zero;
  Offset _endPosition = Offset.zero;

  void _onSwipeUp() {
    if (_useMedia) {
      widget.socketService.volUp();
    } else {
      widget.socketService.arrowUp();
    }
  }

  void _onSwipeDown() {
    if (_useMedia) {
      widget.socketService.volDown();
    } else {
      widget.socketService.arrowDown();
    }
  }

  void _onSwipeLeft() {
    widget.socketService.arrowLeft();
  }

  void _onSwipeRight() {
    widget.socketService.arrowRight();
  }

  void _onDoubleTap() {
    if (_useMedia) {
      widget.socketService.pausePlay();
    } else {
      widget.socketService.space();
    }
  }

  Future<void> _loadBrightness() async {
    _brightness = await ScreenBrightness().application;
    ScreenBrightness().setApplicationScreenBrightness(0);
  }

  @override
  void initState() {
    super.initState();
    _loadBrightness();
  }

  @override
  void dispose() {
    super.dispose();
    ScreenBrightness().setApplicationScreenBrightness(_brightness);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Use desktop's media controls",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Switch(
                value: _useMedia,
                onChanged: (value) => setState(() => _useMedia = !_useMedia),
              ),
            ],
          ),
          Expanded(
            child: GestureDetector(
              // Up / Down gesture (Volume)
              onVerticalDragStart: (details) {
                _startPosition = details.globalPosition;
              },
              onVerticalDragUpdate: (details) {
                _endPosition = details.globalPosition;
                final distance = (_endPosition - _startPosition).distance;
                if (distance > _swipeThreshold) {
                  final isUp = details.delta.dy < 0;
                  isUp ? _onSwipeUp() : _onSwipeDown();
                  _startPosition = _endPosition;
                }
              },

              // Left / Right gesture (Seeking)
              onHorizontalDragStart: (details) {
                _startPosition = details.globalPosition;
              },
              onHorizontalDragUpdate: (details) {
                _endPosition = details.globalPosition;
                final distance = (_endPosition - _startPosition).distance;
                if (distance > _swipeThreshold) {
                  final isLeft = details.delta.dx < 0;
                  isLeft ? _onSwipeLeft() : _onSwipeRight();
                  _startPosition = _endPosition;
                }
              },

              // Pause / Play
              onDoubleTap: _onDoubleTap,
            ),
          ),
        ],
      ),
    );
  }
}
