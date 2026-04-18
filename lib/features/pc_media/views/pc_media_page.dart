import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:without_remote_client/core/services/socket_service.dart';
import 'package:without_remote_client/core/themes/app_colors.dart';
import 'package:without_remote_client/core/utils/app_constants.dart';
import 'package:without_remote_client/features/pc_media/models/remote_mode.dart';
import 'package:without_remote_client/features/pc_media/views/ip_popup.dart';
import 'package:without_remote_client/features/remote_gestures/models/gesture_action.dart';
import 'package:without_remote_client/features/remote_gestures/models/gesture_type.dart';
import 'package:without_remote_client/routes/app_routes.dart';
import 'package:without_remote_client/shared/widget/blank_app_bar.dart';

import '../view_models/pc_media_view_model.dart';

class PcMediaPage extends StatefulWidget {
  const PcMediaPage({super.key});

  @override
  State<PcMediaPage> createState() => _PcMediaPageState();
}

class _PcMediaPageState extends State<PcMediaPage> {
  final _socketService = SocketService();

  void _startVideoGestures(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.remoteGestures,
      // TODO: media controls
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

  void _startFileGestures(BuildContext context) {
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
              AppConstants.socketEmit.returnKey,
            ),
          ),
          GestureType.longPress: GestureAction(
            onUpdate: _socketService.onEmit(
              AppConstants.socketEmit.back,
            ),
          ),
        },
      },
    );
  }

  void _showIpPopup() {
    showDialog(
      context: context,
      builder: (context) {
        return IpPopup(
          socketService: _socketService,
        );
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
    final pcMediaVM = context.read<PcMediaViewModel>();

    final modes = [
      RemoteMode(
        onDoubleTap: () => _startVideoGestures(context),
        icon: Icons.movie_outlined,
        label: "Double tap to start video gestures",
      ),
      RemoteMode(
        onDoubleTap: () => _startFileGestures(context),
        icon: Icons.folder_outlined,
        label: "Double tap to start file gestures",
      ),
    ];

    // IDEA: ping display
    return Scaffold(
      appBar: BlankAppBar(
        toolbarHeight: null,
        actions: [
          IconButton(
            onPressed: _showIpPopup,
            icon: const Icon(
              Icons.settings_outlined,
              color: Colors.grey,
            ),
          ),
        ],
      ),
      body: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          //-----------/ Mode Pages /-----------//
          PageView(
            scrollDirection: Axis.vertical,
            onPageChanged: (index) => pcMediaVM.pageIndex = index,
            children: [
              ...List.generate(modes.length, (index) {
                final mode = modes[index];
                final isFirst = index == 0;
                final isLast = index == modes.length - 1;
                return _RemoteModeView(
                  mode: mode,
                  isFirst: isFirst,
                  isLast: isLast,
                  index: index,
                );
              }),
            ],
          ),

          //-----------/ Indicators /-----------//
          Selector<PcMediaViewModel, (int, bool)>(
            selector: (_, vm) => (vm.pageIndex, vm.showIndicators),
            builder: (context, data, child) {
              final (pageIndex, showIndicators) = data;
              return Positioned(
                left: 24,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: showIndicators ? 1 : 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(modes.length, (index) {
                      final icon = modes[index].icon;
                      final active = index == pageIndex;
                      return Icon(
                        icon,
                        color: active ? AppColors.primary : Colors.black26,
                      );
                    }),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _RemoteModeView extends StatelessWidget {
  const _RemoteModeView({
    required this.mode,
    required this.isFirst,
    required this.isLast,
    required this.index,
  });

  final RemoteMode mode;
  final bool isFirst;
  final bool isLast;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentGeometry.center,
      children: [
        GestureDetector(
          onDoubleTap: mode.onDoubleTap,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    mode.icon,
                    size: 50,
                    color: Colors.grey.shade400,
                  ),
                  Text(
                    mode.label,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),

        Selector<PcMediaViewModel, int>(
          selector: (_, vm) => vm.pageIndex,
          builder: (context, pageIndex, child) {
            return Positioned(
              top: isLast ? 0 : null,
              bottom: isFirst ? 48 : null,
              child: AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: pageIndex == index ? .3 : 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isLast) const Icon(Icons.keyboard_double_arrow_up),
                    const Text("Switch Mode"),
                    if (isFirst) const Icon(Icons.keyboard_double_arrow_down),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
