import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  late io.Socket socket;
  final socketUrl = "http://192.168.0.2:3000";

  void connect() {
    log("Connecting...");
    socket = io.io(
      socketUrl,
      io.OptionBuilder().setTransports(["websocket"]).build(),
    );
    socket.connect();

    socket.onConnect((data) {
      log("Connected to socket");
    });
  }
}
