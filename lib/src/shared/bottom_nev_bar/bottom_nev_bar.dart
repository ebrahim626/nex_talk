import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/router/app_routes.dart';
import '../../features/home_section/chat_section/view/components/current_user_id_provider.dart';
import 'components/bottom_nav_container.dart';
import 'components/build_item.dart';

class BottomNavBar extends ConsumerWidget {
  const BottomNavBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(selectedTabProvider);
    final userId = ref.watch(currentUserIdProvider);
    // final userId = ref.watch(currentUserIdProvider);
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
        onTap: (index) => _onItemTapped(context, index, userId!),
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
        icon: Icons.group_outlined,
        activeIcon: Icons.group,
        label: 'Groups',
      ),

      BottomNavUtils.buildItem(
        icon: Icons.account_circle_outlined,
        activeIcon: Icons.account_circle,
        label: 'Profile',
      ),
    ];
  }

  void _onItemTapped(BuildContext context, int index, String userId) {
    switch (index) {
      case 0:
        context.go(
          AppRoutes.searchRoute,
          extra: {'tab': index, 'userId': userId},
        );
        break;
      case 1:
        context.go(
          AppRoutes.searchRoute,
          extra: {'tab': index, 'userId': userId},
        );
        break;
      case 2:
        context.push(
          AppRoutes.profileScreenRoute,
        );
        break;
    }
  }

  // int _getSelectedIndex(BuildContext context) {
  //   final String location = GoRouterState.of(context).uri.toString();
  //
  //   if (location.startsWith(AppRoutes.searchRoute)) return 0;
  //
  //   return 0; // Default to Home
  // }
}
