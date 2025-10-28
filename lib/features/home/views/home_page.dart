import 'package:flutter/material.dart';
import 'package:without_remote_client/core/services/socket_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _socketService = SocketService();

  @override
  void initState() {
    super.initState();
    _socketService.connect();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold();
  }
}
