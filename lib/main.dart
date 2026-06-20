import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_talk/src/core/config/size/size.dart';
import 'package:next_talk/src/core/utils/extensions/context.dart';
import 'package:next_talk/src/core/utils/theme/theme.dart';
import 'package:next_talk/src/features/auth/login_section/view/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) => MaterialApp(
        title: 'Nex Talk',
        theme: lightTheme,
        builder: (context, child) {
          topBarSize = context.padding.top;
          bottomViewPadding = context.padding.bottom;
          return MediaQuery(
            data: context.mq.copyWith(
              devicePixelRatio: 1.0,
              textScaler: const TextScaler.linear(1.0),
            ),
            child: LoginScreen(),
          );
        },
      ),
    );
  }
}