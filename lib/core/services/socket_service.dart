import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:without_remote_client/core/utils/app_constants.dart';

class SocketService {
  late io.Socket socket;
  BuildContext? context;

  void connect({String? ipAddress}) async {
    final messenger = context != null ? ScaffoldMessenger.of(context!) : null;
    final prefs = await SharedPreferences.getInstance();
    final storedIp = prefs.getString(AppConstants.ipAddressKey);
    final usedIp = ipAddress ?? storedIp;
    if (usedIp == null) return;

    socket = io.io(
      "http://$usedIp:3000",
      io.OptionBuilder().setTransports(["websocket"]).build(),
    );
    socket.connect();

    socket.onConnect((data) {
      log("Connected to socket");
      messenger?.clearSnackBars();
      messenger?.showSnackBar(
        const SnackBar(
          content: Text(
            "Connected",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.green,
        ),
      );
    });
  }

  void disconnect() {
    socket.disconnect();
  }

  VoidCallback onEmit(String emitKey) {
    return () => emit(emitKey);
  }

  void emit(String emitKey) {
    socket.volatile.emit(emitKey);
  }
}
