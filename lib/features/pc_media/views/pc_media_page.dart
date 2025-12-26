import 'package:flutter/material.dart';
import 'package:without_remote_client/core/services/socket_service.dart';
import 'package:without_remote_client/features/pc_media/views/ip_popup.dart';
import 'package:without_remote_client/features/remote_gestures/models/gesture_action.dart';
import 'package:without_remote_client/features/remote_gestures/models/gesture_type.dart';
import 'package:without_remote_client/routes/app_routes.dart';
import 'package:without_remote_client/shared/widget/blank_app_bar.dart';

class PcMediaPage extends StatefulWidget {
  const PcMediaPage({super.key});

  @override
  State<PcMediaPage> createState() => _PcMediaPageState();
}

class _PcMediaPageState extends State<PcMediaPage> {
  final _socketService = SocketService();

  void _startGestures(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.remoteGestures,
      // TODO: media controls
      arguments: {
        "actions": <GestureType, GestureAction>{
          GestureType.swipeLeft: GestureAction(
            onUpdate: _socketService.arrowLeft,
          ),
          GestureType.swipeRight: GestureAction(
            onUpdate: _socketService.arrowRight,
          ),
          GestureType.swipeUp: GestureAction(
            onUpdate: _socketService.arrowUp,
          ),
          GestureType.swipeDown: GestureAction(
            onUpdate: _socketService.arrowDown,
          ),
          GestureType.doubleTap: GestureAction(
            onUpdate: _socketService.space,
          ),
        },
      },
    );
  }

  void _showIpPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return IpPopup(
          socketService: _socketService,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // IDEA: ping display
    return Scaffold(
      appBar: BlankAppBar(
        toolbarHeight: null,
        actions: [
          IconButton(
            onPressed: _showIpPopup,
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: GestureDetector(
        onDoubleTap: () => _startGestures(context),
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.computer,
                  size: 50,
                  color: Colors.grey.shade400,
                ),
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
