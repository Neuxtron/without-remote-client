import 'dart:developer';

import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  late io.Socket socket;
  final socketUrl = "http://192.168.42.26:3000";

  void connect() {
    socket = io.io(
      socketUrl,
      io.OptionBuilder().setTransports(["websocket"]).build(),
    );
    socket.connect();

    socket.onConnect((data) {
      log("Connected to socket");
    });
  }

  void volUp() {
    socket.volatile.emit("vol_up");
  }

  void volDown() {
    socket.volatile.emit("vol_down");
  }

  void arrowUp() {
    socket.volatile.emit("arrow_up");
  }

  void arrowDown() {
    socket.volatile.emit("arrow_down");
  }

  void arrowLeft() {
    socket.volatile.emit("arrow_left");
  }

  void arrowFastLeft() {
    socket.volatile.emit("arrow_fast_left");
  }

  void arrowRight() {
    socket.volatile.emit("arrow_right");
  }

  void arrowFastRight() {
    socket.volatile.emit("arrow_fast_right");
  }
}
