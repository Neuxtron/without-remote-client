import 'package:flutter/material.dart';
import 'package:without_remote_client/core/layouts/main_layout.dart';
import 'package:without_remote_client/features/remote_gestures/views/remote_gestures_page.dart';

class AppRoutes {
  static String main = "/";
  static String remoteGestures = "/remote_gestures";

  static Map<String, WidgetBuilder> routes = {
    main: (context) => const MainLayout(),
    remoteGestures: (context) {
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      return RemoteGesturesPage(actions: args["actions"]);
    },
  };
}
