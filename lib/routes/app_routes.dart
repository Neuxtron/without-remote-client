import 'package:flutter/material.dart';
import 'package:without_remote_client/features/home/views/home_page.dart';

class AppRoutes {
  static String home = "/";

  static Map<String, WidgetBuilder> routes = {
    home: (context) => const HomePage(),
  };
}
