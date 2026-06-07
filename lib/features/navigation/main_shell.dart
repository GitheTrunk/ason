import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/custom_bottom_nav.dart';

class MainShell extends StatelessWidget {
  const MainShell({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allows the body to extend behind the floating nav bar
      body: child,
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (int index) => _onItemTapped(index, context),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/home')) {
      return 0;
    }
    if (location.startsWith('/map')) {
      return 1;
    }
    if (location.startsWith('/contacts')) {
      return 2;
    }
    if (location.startsWith('/first-aid')) {
      return 3;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        GoRouter.of(context).go('/home');
      case 1:
        GoRouter.of(context).go('/map');
      case 2:
        GoRouter.of(context).go('/contacts');
      case 3:
        GoRouter.of(context).go('/first-aid');
    }
  }
}
