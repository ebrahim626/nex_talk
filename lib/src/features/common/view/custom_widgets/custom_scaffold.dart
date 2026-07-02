import 'package:flutter/material.dart';
import 'package:next_talk/src/core/utils/theme/theme.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.backGroundColor, this.appBar,
  });

  final Widget body;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final Color? backGroundColor;
  final AppBar? appBar;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: appBar,
        backgroundColor: backGroundColor ?? backgroundColor,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: bottomNavigationBar,
        body: SafeArea(bottom: false ,child: body),
      ),
    );
  }
}
