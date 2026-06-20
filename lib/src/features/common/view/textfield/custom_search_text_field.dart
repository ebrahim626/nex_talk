import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../../../core/utils/extensions/context.dart';
import '../../../../core/utils/extensions/gap.dart';
import '../drop_down/custom_drop_down.dart';
import 'custom_textfield_with_label.dart';

class CustomSearchTextField extends StatelessWidget {
  const CustomSearchTextField({
    super.key,
    required this.title,
    this.controller,
  });

  final String title;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsGeometry.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: context.text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Flexible(
                child: CustomDropDownPlus(
                  label: "Sort by",
                  labelColor: Colors.black54,
                  backgroundColor: Colors.white,
                  items: [],
                  onSelectionChanged: (value) {},
                  itemToString: (value) => value.toString(),
                ),
              ),
            ],
          ),
          12.ph,
          CustomTextFieldWithLabel(
            controller: controller,
            label: "",
            hintText: "Search (Name, Email, Phone)",
            leading: Icon(Icons.search),
          ),
          // CustomSearchBarWidget(
          //   controller: notifier.searchController,
          //   hintText: "Search (Name, Email, Phone)",
          //   icon: HugeIcons.strokeRoundedSearch01,
          //   borderColor: Colors.black12,
          // ),
        ],
      ),
    );
  }
}
