import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:without_remote_client/features/home/views/home_page.dart';
import 'package:without_remote_client/features/phone_media/views/phone_media_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with TickerProviderStateMixin {
  late final SlidableController _slidableController;
  int _currentIndex = 0;

  void _changeIndex(int index) {
    setState(() => _currentIndex = index);
    _slidableController.close();
  }

  @override
  void initState() {
    super.initState();
    _slidableController = SlidableController(this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Slidable(
        controller: _slidableController,
        endActionPane: ActionPane(
          extentRatio: 2 / 3,
          motion: const BehindMotion(),
          children: [
            Expanded(
              child: Material(
                color: Colors.blue.shade800,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _MenuItem(
                      title: "PC Media",
                      icon: Icons.computer,
                      onPressed: () => _changeIndex(0),
                      active: _currentIndex == 0,
                    ),
                    _MenuItem(
                      title: "Phone Media",
                      icon: Icons.phone_android,
                      onPressed: () => _changeIndex(1),
                      active: _currentIndex == 1,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        child: IndexedStack(
          index: _currentIndex,
          children: [
            const HomePage(),
            const PhoneMediaPage(),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  const _MenuItem({
    required this.title,
    required this.icon,
    required this.onPressed,
    required this.active,
  });

  final String title;
  final IconData icon;
  final VoidCallback onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      tileColor: active ? Colors.blue.shade900 : Colors.blue.shade800,
      textColor: Colors.white,
      title: Text(
        title,
        textAlign: TextAlign.right,
      ),
      trailing: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }
}
