class AppConstants {
  AppConstants._();

  static const String ipAddressKey = "IP_ADDRESS";
  static const socketEmit = _SocketEmitConstraints._();
}

class _SocketEmitConstraints {
  const _SocketEmitConstraints._();
  final String volUp = "vol_up";
  final String volDown = "vol_down";
  final String arrowUp = "arrow_up";
  final String arrowDown = "arrow_down";
  final String arrowLeft = "arrow_left";
  final String arrowFastLeft = "arrow_fast_left";
  final String arrowRight = "arrow_right";
  final String arrowFastRight = "arrow_fast_right";
  final String playPause = "play_pause";
  final String space = "space";
  final String returnKey = "return";
  final String back = "back";
}
