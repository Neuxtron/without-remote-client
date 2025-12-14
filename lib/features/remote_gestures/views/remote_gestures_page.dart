import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:without_remote_client/features/remote_gestures/models/gesture_action.dart';
import 'package:without_remote_client/features/remote_gestures/models/gesture_type.dart';

class RemoteGesturesPage extends StatefulWidget {
  const RemoteGesturesPage({super.key, required this.actions});
  final Map<GestureType, GestureAction> actions;

  @override
  State<RemoteGesturesPage> createState() => _RemoteGesturesPageState();
}

class _RemoteGesturesPageState extends State<RemoteGesturesPage> {
  double get _swipeThreshold => 50;

  // bool _useMedia = true;
  Offset _startPosition = Offset.zero;
  Offset _endPosition = Offset.zero;

  void _onSwipeLeft() {
    widget.actions[GestureType.swipeLeft]?.onUpdate?.call();
  }

  void _onSwipeLeftEnd() {
    widget.actions[GestureType.swipeLeft]?.onEnd?.call();
  }

  void _onSwipeRight() {
    widget.actions[GestureType.swipeRight]?.onUpdate?.call();
  }

  void _onSwipeRightEnd() {
    widget.actions[GestureType.swipeRight]?.onEnd?.call();
  }

  void _onSwipeUp() {
    widget.actions[GestureType.swipeUp]?.onUpdate?.call();
  }

  void _onSwipeUpEnd() {
    widget.actions[GestureType.swipeUp]?.onEnd?.call();
  }

  void _onSwipeDown() {
    widget.actions[GestureType.swipeDown]?.onUpdate?.call();
  }

  void _onSwipeDownEnd() {
    widget.actions[GestureType.swipeDown]?.onEnd?.call();
  }

  void _onDoubleTap() {
    widget.actions[GestureType.doubleTap]?.onUpdate?.call();
    widget.actions[GestureType.doubleTap]?.onEnd?.call();
  }

  Future<void> _loadBrightness() async {
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
    ScreenBrightness().resetApplicationScreenBrightness();
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
      // TODO: media controls
      // Row(
      //   children: [
      //     const Expanded(
      //       child: Text(
      //         "Use desktop's media controls",
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     ),
      //     Switch(
      //       value: _useMedia,
      //       onChanged: (value) => setState(() => _useMedia = !_useMedia),
      //     ),
      //   ],
      // ),
      body: GestureDetector(
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
        onVerticalDragEnd: (details) {
          _endPosition = details.globalPosition;
          final distance = (_endPosition - _startPosition).distance;
          if (distance > _swipeThreshold) {
            final velocity = details.primaryVelocity ?? 0;
            final isUp = velocity < 0;
            isUp ? _onSwipeUpEnd() : _onSwipeDownEnd();
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
        onHorizontalDragEnd: (details) {
          _endPosition = details.globalPosition;
          // OPTIMIZE: move to drag update
          final velocity = details.primaryVelocity ?? 0;
          final isLeft = velocity < 0;
          isLeft ? _onSwipeLeftEnd() : _onSwipeRightEnd();
          _startPosition = _endPosition;
        },

        // Pause / Play
        onDoubleTap: _onDoubleTap,
      ),
    );
  }
}
