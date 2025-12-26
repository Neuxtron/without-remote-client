import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:without_remote_client/core/services/socket_service.dart';
import 'package:without_remote_client/core/utils/app_constants.dart';

class IpPopup extends StatefulWidget {
  const IpPopup({super.key, required this.socketService});
  final SocketService socketService;

  @override
  State<IpPopup> createState() => _IpPopupState();
}

class _IpPopupState extends State<IpPopup> {
  final _ipController = TextEditingController();

  void _loadIp() async {
    final prefs = await SharedPreferences.getInstance();
    _ipController.text = prefs.getString(AppConstants.ipAddressKey) ?? "";
  }

  void _saveIp() async {
    final ipAddress = _ipController.text.trim();
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(AppConstants.ipAddressKey, ipAddress);

    if (prefs.getString(AppConstants.ipAddressKey)?.isEmpty ?? true) return;
    messenger.showSnackBar(
      const SnackBar(
        content: Text(
          "Connecting...",
          textAlign: TextAlign.center,
        ),
      ),
    );
    widget.socketService.disconnect();
    widget.socketService.connect();
    navigator.pop();
  }

  @override
  void initState() {
    super.initState();
    _loadIp();
  }

  @override
  void dispose() {
    super.dispose();
    _ipController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _ipController,
            keyboardType: TextInputType.url,
            decoration: InputDecoration(
              labelText: "IP Address",
              enabledBorder: _buildBorder(),
              focusedBorder: _buildBorder(),
              border: _buildBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            "Cancel",
            style: TextStyle(color: Colors.grey),
          ),
        ),
        TextButton(
          onPressed: _saveIp,
          child: const Text("Save"),
        ),
      ],
    );
  }

  OutlineInputBorder _buildBorder() {
    return const OutlineInputBorder();
  }
}
