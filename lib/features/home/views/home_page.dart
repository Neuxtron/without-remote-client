import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:without_remote_client/core/services/socket_service.dart';
import 'package:without_remote_client/core/themes/app_colors.dart';
import 'package:without_remote_client/core/utils/app_constants.dart';
import 'package:without_remote_client/features/remote_gestures/models/gesture_action.dart';
import 'package:without_remote_client/features/remote_gestures/models/gesture_type.dart';
import 'package:without_remote_client/routes/app_routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _socketService = SocketService();

  void _startGestures() {
    Navigator.pushNamed(
      context,
      AppRoutes.remoteGestures,
      arguments: {
        "actions": <GestureType, GestureAction>{
          GestureType.swipeLeft: GestureAction(
            onUpdate: _socketService.onEmit(
              AppConstants.socketEmit.arrowLeft,
            ),
          ),
          GestureType.swipeRight: GestureAction(
            onUpdate: _socketService.onEmit(
              AppConstants.socketEmit.arrowRight,
            ),
          ),
          GestureType.swipeUp: GestureAction(
            onUpdate: _socketService.onEmit(
              AppConstants.socketEmit.arrowUp,
            ),
          ),
          GestureType.swipeDown: GestureAction(
            onUpdate: _socketService.onEmit(
              AppConstants.socketEmit.arrowDown,
            ),
          ),
          GestureType.doubleTap: GestureAction(
            onUpdate: _socketService.onEmit(
              AppConstants.socketEmit.space,
            ),
          ),
        },
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _socketService.context = context;
      _socketService.connect();
    });
  }

  @override
  Widget build(BuildContext context) {
    const iconSize = 35.0;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return _IpPopup(
                    socketService: _socketService,
                  );
                },
              );
            },
            icon: const Icon(Icons.settings_outlined),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _RoundedButton(
                onPressed: _socketService.onEmit(
                  AppConstants.socketEmit.arrowFastLeft,
                ),
                icon: const Icon(
                  Icons.keyboard_double_arrow_left,
                  size: iconSize,
                ),
              ),
              _RoundedButton(
                onPressed: _socketService.onEmit(
                  AppConstants.socketEmit.arrowLeft,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_left,
                  size: iconSize,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _RoundedButton(
                    onPressed: _socketService.onEmit(
                      AppConstants.socketEmit.arrowUp,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_up,
                      size: iconSize,
                    ),
                  ),
                  _RoundedButton(
                    onPressed: () {},
                    icon: SizedBox(
                      height: iconSize,
                      width: iconSize,
                      child: SvgPicture.asset(
                        "assets/icons/play_pause.svg",
                      ),
                    ),
                  ),
                  _RoundedButton(
                    onPressed: _socketService.onEmit(
                      AppConstants.socketEmit.arrowDown,
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      size: iconSize,
                    ),
                  ),
                ],
              ),
              _RoundedButton(
                onPressed: _socketService.onEmit(
                  AppConstants.socketEmit.arrowRight,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_right,
                  size: iconSize,
                ),
              ),
              _RoundedButton(
                onPressed: _socketService.onEmit(
                  AppConstants.socketEmit.arrowFastRight,
                ),
                icon: const Icon(
                  Icons.keyboard_double_arrow_right,
                  size: iconSize,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _RoundedButton(
                    onPressed: _socketService.onEmit(
                      AppConstants.socketEmit.volUp,
                    ),
                    icon: const Icon(
                      Icons.volume_up,
                      size: iconSize,
                    ),
                  ),
                  _RoundedButton(
                    onPressed: _socketService.onEmit(
                      AppConstants.socketEmit.volDown,
                    ),
                    icon: const Icon(
                      Icons.volume_down,
                      size: iconSize,
                    ),
                  ),
                ],
              ),
            ],
          ),
          MaterialButton(
            onPressed: _socketService.onEmit(AppConstants.socketEmit.space),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(999),
            ),
            color: AppColors.primary,
            textColor: Colors.white,
            child: const Text("[___]"),
          ),
          TextButton(
            onPressed: _startGestures,
            child: const Text("Start remote gestures"),
          ),
        ],
      ),
    );
  }
}

class _RoundedButton extends StatelessWidget {
  const _RoundedButton({
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: IconButton.styleFrom(
        padding: const EdgeInsets.all(12),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      icon: icon,
    );
  }
}

class _IpPopup extends StatefulWidget {
  const _IpPopup({required this.socketService});
  final SocketService socketService;

  @override
  State<_IpPopup> createState() => _IpPopupState();
}

class _IpPopupState extends State<_IpPopup> {
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
