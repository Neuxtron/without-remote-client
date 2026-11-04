import 'package:flutter/material.dart';
import 'package:without_remote_client/features/remote_gestures/services/socket_service.dart';

class SocketViewModel extends ChangeNotifier {
  final _service = SocketService();
  late final dynamic Function(dynamic) _onConnect;

  void initialize(dynamic Function(dynamic) onConnect) {
    _onConnect = onConnect;
  }

  void connect({String? ipAddress}) {
    _service.connect(ipAddress, _onConnect);
  }

  void disconnect() => _service.disconnect();

  VoidCallback onEmit(String emitKey) {
    return () => emit(emitKey);
  }

  void emit(String emitKey) => _service.emit(emitKey);
}
