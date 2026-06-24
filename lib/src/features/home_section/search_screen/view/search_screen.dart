import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:next_talk/src/core/config/constant/assets_path.dart';
import 'package:next_talk/src/core/utils/extensions/context.dart';
import 'package:next_talk/src/core/utils/theme/theme.dart';
import 'package:next_talk/src/features/common/view/custom_widgets/custom_scaffold.dart';
import 'package:next_talk/src/features/home_section/add_contact/view/add_contact_bottom_sheet.dart';
import 'package:next_talk/src/features/home_section/search_screen/controller/search_provider.dart';
import 'package:next_talk/src/features/home_section/search_screen/view/components/tab_wrapper.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/utils/extensions/gap.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key, required this.initialTab});

  final int initialTab;
  static const String name = "search-screen";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(searchProvider);
    final notifier = ref.read(searchProvider.notifier);

    return CustomScaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 85.0),
        child: FloatingActionButton(
          onPressed: () {
            notifier.selectedTabBar == 0 ?
            AddContactBottomSheet.show(context) : () {};
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(99),
          ),
          child: Icon(Icons.add),
        ),
      ),
      backGroundColor: backgroundColor,
      body: Column(
        children: [
          Container(
            padding: EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 16),
            color: logoContainerColor,
            child: Row(
              children: [
                Image.asset(AssetsPath.logo, width: 38, height: 38),
                15.pw,
                Text(
                  "NexTalk",
                  style: context.text.bodyLarge?.copyWith(
                    color: titleTextColor,
                  ),
                ),
              ],
            ),
          ),
          20.ph,
          Expanded(
            child: TabWrapper(
              initialTab: initialTab,
              currentTab: notifier.selectedTabBar,
              onTabChanged: (index) {
                notifier.setTab(index);
                context.go(
                  AppRoutes.searchRoute,
                  extra: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
