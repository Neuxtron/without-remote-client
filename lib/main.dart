import 'package:flutter/material.dart';
import 'package:without_remote_client/routes/app_routes.dart';

void main() {
  runApp(const WithoutRemoteApp());
}

class WithoutRemoteApp extends StatelessWidget {
  const WithoutRemoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Without Remote Client",
      // TODO: theme
      initialRoute: "/",
      routes: AppRoutes.routes,
    );
  }
}
