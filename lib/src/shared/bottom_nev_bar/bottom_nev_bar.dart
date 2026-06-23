import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import '../../features/home_section/search_screen/controller/search_provider.dart';
import 'components/bottom_nav_container.dart';
import 'components/build_item.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(searchProvider);
    final tabIndex = ref.read(searchProvider.notifier).selectedTabBar;
    // final unreadCount = ref.watch(unreadCountProvider);
    // final scaffoldKey = ref.watch(shellScaffoldKeyProvider);

    // Determine current screen from router
    // final location = GoRouterState.of(context).uri.toString();
    // final currentScreen = location.contains('history') ? 'History' : 'Home';

    return Scaffold(
      // key: scaffoldKey,                              // 👈 shell scaffold key
      // drawer: MenuDrawer(currentScreen: currentScreen), // 👈 drawer here
      body: child,
      extendBody: true,
      bottomNavigationBar: BottomNavContainer(
        currentIndex: tabIndex,
        onTap: (index) => _onItemTapped(context, index),
        navItems: _buildNavItems(context),
      ),
    );
  }
  // items: const [
  // BottomNavigationBarItem(
  // icon: HugeIcon(icon: HugeIcons.strokeRoundedGoogleHome),
  // activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedGoogleHome),
  // label: 'Home',
  // ),
  // BottomNavigationBarItem(
  // icon: HugeIcon(icon: HugeIcons.strokeRoundedTransactionHistory),
  // activeIcon: HugeIcon(icon: HugeIcons.strokeRoundedTransactionHistory),
  // label: 'History',
  // ),
  // ],
  // ),
  //

  List<BottomNavigationBarItem> _buildNavItems(BuildContext context) {
    return [
      BottomNavUtils.buildItem(
        icon: Icons.chat_bubble_outline,
        activeIcon: Icons.chat_bubble,
        label: 'Direct',
      ),

      BottomNavUtils.buildItem(
        icon: Icons.groups_outlined,
        activeIcon: Icons.groups,
        label: 'Groups',
      ),

      BottomNavUtils.buildItem(
        icon: Icons.account_circle_outlined,
        activeIcon: Icons.account_circle,
        label: 'Profile',
      ),
    ];
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.searchRoute,extra: index);
        break;
      case 1:
        context.go(AppRoutes.searchRoute, extra: index);
        break;
    }
  }

  int _getSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();

    if (location.startsWith(AppRoutes.searchRoute)) return 0;

    return 0; // Default to Home
  }
}
