import 'package:flutter/material.dart';
import 'package:without_remote_client/features/home/views/home_page.dart';
import 'package:without_remote_client/features/remote_gestures/remote_gestures_page.dart';

class AppRoutes {
  static String home = "/";
  static String remoteGestures = "/remote_gestures";

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
    remoteGestures: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return RemoteGesturesPage(socketService: args["socketService"]);
    },
  };
}
