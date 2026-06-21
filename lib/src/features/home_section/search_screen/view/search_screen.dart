import 'package:flutter/material.dart';
import 'package:next_talk/src/core/config/constant/assets_path.dart';
import 'package:next_talk/src/core/utils/extensions/context.dart';
import 'package:next_talk/src/core/utils/theme/theme.dart';
import 'package:next_talk/src/features/common/view/custom_widgets/custom_scaffold.dart';
import 'package:next_talk/src/features/home_section/add_contact/view/add_contact_bottom_sheet.dart';
import 'package:next_talk/src/features/home_section/search_screen/view/components/direct_messages.dart';
import 'package:next_talk/src/features/home_section/search_screen/view/components/groups.dart';
import '../../../../core/utils/extensions/gap.dart';
import '../../../common/view/textfield/custom_textfield_with_label.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  static const String name = "search_screen";

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 85.0),
        child: FloatingActionButton(
          onPressed: () {
            AddContactBottomSheet.show(context);
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
            child: DefaultTabController(
              length: 2,
              child: Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    // Tab switcher pill
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: containerColor,
                      ),
                      child: TabBar(
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
                      leading: Icon(Icons.search),
                    ),
                    32.ph,
                    // Forms
                    Expanded(
                      child: TabBarView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [DirectMessages(), Groups()],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
