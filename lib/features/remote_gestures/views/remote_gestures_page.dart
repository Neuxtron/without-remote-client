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

  void _handleUpdateGesture(GestureType type) {
    widget.actions[type]?.onUpdate?.call();
  }

  void _handleEndGesture(GestureType type) {
    widget.actions[type]?.onEnd?.call();
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
        //
        //-----------/ Up / Down gesture /-----------//
        onVerticalDragStart: (details) {
          _startPosition = details.globalPosition;
        },
        onVerticalDragUpdate: (details) {
          _endPosition = details.globalPosition;
          final distance = (_endPosition - _startPosition).distance;
          if (distance > _swipeThreshold) {
            final isUp = details.delta.dy < 0;
            isUp
                ? _handleUpdateGesture(GestureType.swipeUp)
                : _handleUpdateGesture(GestureType.swipeDown);
            _startPosition = _endPosition;
          }
        },
        onVerticalDragEnd: (details) {
          _endPosition = details.globalPosition;
          final distance = (_endPosition - _startPosition).distance;
          if (distance > _swipeThreshold) {
            final velocity = details.primaryVelocity ?? 0;
            final isUp = velocity < 0;
            isUp
                ? _handleEndGesture(GestureType.swipeUp)
                : _handleEndGesture(GestureType.swipeDown);
          }
          _startPosition = _endPosition;
        },

        //-----------/ Left / Right gesture /-----------//
        onHorizontalDragStart: (details) {
          _startPosition = details.globalPosition;
        },
        onHorizontalDragUpdate: (details) {
          _endPosition = details.globalPosition;
          final distance = (_endPosition - _startPosition).distance;
          if (distance > _swipeThreshold) {
            final isLeft = details.delta.dx < 0;
            isLeft
                ? _handleUpdateGesture(GestureType.swipeLeft)
                : _handleUpdateGesture(GestureType.swipeRight);
            _startPosition = _endPosition;
          }
        },
        onHorizontalDragEnd: (details) {
          _endPosition = details.globalPosition;
          final distance = (_endPosition - _startPosition).distance;
          if (distance > _swipeThreshold) {
            // OPTIMIZE: move to drag update
            final velocity = details.primaryVelocity ?? 0;
            final isLeft = velocity < 0;
            isLeft
                ? _handleEndGesture(GestureType.swipeLeft)
                : _handleEndGesture(GestureType.swipeRight);
          }
          _startPosition = _endPosition;
        },

        //-----------/ Double Tap /-----------//
        onDoubleTap: () {
          _handleUpdateGesture(GestureType.doubleTap);
          _handleEndGesture(GestureType.doubleTap);
        },

        //-----------/ Long Press (Hold) /-----------//
        onLongPress: () {
          _handleUpdateGesture(GestureType.longPress);
          _handleEndGesture(GestureType.longPress);
        },
      ),
    );
  }
}
