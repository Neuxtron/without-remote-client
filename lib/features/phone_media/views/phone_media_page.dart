import 'package:flutter/material.dart';
import 'package:without_remote_client/features/phone_media/services/media_service.dart';
import 'package:without_remote_client/features/remote_gestures/models/gesture_action.dart';
import 'package:without_remote_client/features/remote_gestures/models/gesture_type.dart';
import 'package:without_remote_client/routes/app_routes.dart';

class PhoneMediaPage extends StatelessWidget {
  PhoneMediaPage({super.key});

  final _mediaService = MediaService();

  void _startGestures(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.remoteGestures,
      arguments: {
        "actions": <GestureType, GestureAction>{
          GestureType.swipeLeft: GestureAction(
            onEnd: _mediaService.playPrevious,
          ),
          GestureType.swipeRight: GestureAction(
            onEnd: _mediaService.playNext,
          ),
          GestureType.swipeUp: GestureAction(
            onUpdate: _mediaService.volumeUp,
          ),
          GestureType.swipeDown: GestureAction(
            onUpdate: _mediaService.volumeDown,
          ),
          GestureType.doubleTap: GestureAction(
            onUpdate: _mediaService.playPause,
          ),
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => _startGestures(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        child: const Text("Start Gestures"),
      ),
    );
  }
}
