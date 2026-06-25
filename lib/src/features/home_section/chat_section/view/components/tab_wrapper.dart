import 'package:flutter/material.dart';
import '../../../../../core/utils/extensions/context.dart';
import '../../../../../core/utils/extensions/gap.dart';
import '../../../../../core/utils/theme/theme.dart';
import '../../../../common/view/textfield/custom_textfield_with_label.dart';
import 'direct_messages.dart';
import 'groups.dart';

class TabWrapper extends StatefulWidget {
  const TabWrapper({
    super.key,
    required this.initialTab,
    required this.currentTab,
    required this.onTabChanged,
  });

  final int initialTab;
  final int currentTab;
  final ValueChanged<int> onTabChanged;

  @override
  State<TabWrapper> createState() => _TabWrapperState();
}

class _TabWrapperState extends State<TabWrapper>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab,
    );

    // 👈 sync initial tab to provider so navbar reflects correctly on first load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onTabChanged(widget.initialTab);
    });

    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        widget.onTabChanged(_tabController.index);
      }
    });
  }

  @override
  void didUpdateWidget(TabWrapper old) {
    super.didUpdateWidget(old);
    if (old.initialTab != widget.initialTab) {
      _tabController.animateTo(widget.initialTab); // 👈 nav tap → tab changes
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: containerColor,
            ),
            child: TabBar(
              controller: _tabController,
              padding: EdgeInsets.zero,
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: primaryColor,
              ),
              labelColor: Colors.white,
              unselectedLabelColor: bodyTextColor,
              labelStyle: context.text.titleMedium,
              unselectedLabelStyle: context.text.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              tabs: const [
                Tab(text: "Direct"),
                Tab(text: "Groups"),
              ],
            ),
          ),
          30.ph,
          CustomTextFieldWithLabel(
            isFillColor: true,
            fillColor: containerColor2,
            height: 52,
            controller: TextEditingController(),
            label: "",
            hintText: "Search conversations...",
            leading: const Icon(Icons.search),
          ),
          32.ph,
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [DirectMessages(), Groups()],
            ),
          ),
        ],
      ),
    );
  }
}
