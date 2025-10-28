import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:without_remote_client/core/services/socket_service.dart';
import 'package:without_remote_client/core/themes/app_colors.dart';
import 'package:without_remote_client/routes/app_routes.dart';

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
    const iconSize = 35.0;

    // IDEA: ping display
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _RoundedButton(
                  onPressed: _socketService.arrowFastLeft,
                  icon: const Icon(
                    Icons.keyboard_double_arrow_left,
                    size: iconSize,
                  ),
                ),
                _RoundedButton(
                  onPressed: _socketService.arrowLeft,
                  icon: const Icon(
                    Icons.keyboard_arrow_left,
                    size: iconSize,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _RoundedButton(
                      onPressed: _socketService.arrowUp,
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
                        child: SvgPicture.asset("assets/icons/play_pause.svg"),
                      ),
                    ),
                    _RoundedButton(
                      onPressed: _socketService.arrowDown,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        size: iconSize,
                      ),
                    ),
                  ],
                ),
                _RoundedButton(
                  onPressed: _socketService.arrowRight,
                  icon: const Icon(
                    Icons.keyboard_arrow_right,
                    size: iconSize,
                  ),
                ),
                _RoundedButton(
                  onPressed: _socketService.arrowFastRight,
                  icon: const Icon(
                    Icons.keyboard_double_arrow_right,
                    size: iconSize,
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _RoundedButton(
                      onPressed: _socketService.volUp,
                      icon: const Icon(
                        Icons.volume_up,
                        size: iconSize,
                      ),
                    ),
                    _RoundedButton(
                      onPressed: _socketService.volDown,
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
              onPressed: _socketService.space,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(999),
              ),
              color: AppColors.primary,
              textColor: Colors.white,
              child: const Text("[___]"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.remoteGestures,
                  arguments: {"socketService": _socketService},
                );
              },
              child: const Text("Start remote gestures"),
            ),
          ],
        ),
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
