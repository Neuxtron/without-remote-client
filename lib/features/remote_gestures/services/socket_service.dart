import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:without_remote_client/core/utils/app_constants.dart';

class SocketService {
  io.Socket? _socket;

  void connect(String? ipAddress, dynamic Function(dynamic) onConnect) async {
    final prefs = await SharedPreferences.getInstance();
    final storedIp = prefs.getString(AppConstants.ipAddressKey);
    final usedIp = ipAddress ?? storedIp;
    if (usedIp == null) return;

    final socket = io.io(
      "http://$usedIp:3000",
      io.OptionBuilder().setTransports(["websocket"]).build(),
    );
    _socket = socket;
    socket.connect();
    socket.onConnect(onConnect);
  }

  void disconnect() {
    _socket?.disconnect();
  }

  void emit(String emitKey) {
    _socket?.volatile.emit(emitKey);
  }
}
