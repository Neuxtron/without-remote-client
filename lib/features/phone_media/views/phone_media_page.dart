import 'package:flutter/material.dart';
import 'package:without_remote_client/features/phone_media/services/media_service.dart';
import 'package:without_remote_client/features/remote_gestures/models/gesture_action.dart';
import 'package:without_remote_client/features/remote_gestures/models/gesture_type.dart';
import 'package:without_remote_client/routes/app_routes.dart';
import 'package:without_remote_client/shared/widget/blank_app_bar.dart';

class PhoneMediaPage extends StatelessWidget {
  const PhoneMediaPage({super.key});

  void _startGestures(BuildContext context) {
    final mediaService = MediaService();
    Navigator.pushNamed(
      context,
      AppRoutes.remoteGestures,
      arguments: {
        "actions": <GestureType, GestureAction>{
          GestureType.swipeLeft: GestureAction(
            onEnd: mediaService.playPrevious,
          ),
          GestureType.swipeRight: GestureAction(
            onEnd: mediaService.playNext,
          ),
          GestureType.swipeUp: GestureAction(
            onUpdate: mediaService.volumeUp,
          ),
          GestureType.swipeDown: GestureAction(
            onUpdate: mediaService.volumeDown,
          ),
          GestureType.doubleTap: GestureAction(
            onUpdate: mediaService.playPause,
          ),
        },
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BlankAppBar(),
      body: GestureDetector(
        onDoubleTap: () => _startGestures(context),
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.phone_android,
                  size: 50,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Double tap to start gestures",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
