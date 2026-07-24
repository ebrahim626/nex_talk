import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_ce/hive.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:next_talk/src/core/config/constant/app_constants.dart';
import 'package:next_talk/src/core/config/size/size.dart';
import 'package:next_talk/src/core/router/go_router.export.dart';
import 'package:next_talk/src/core/utils/extensions/context.dart';
import 'package:next_talk/src/core/utils/theme/theme.dart';

import 'src/shared/easy_loading_widget/nex_talk_loading_widget.dart';

void main() async {

  // Hive service
  await Hive.initFlutter();
  await Hive.openBox<dynamic>(AppConstants.hiveKey);

  await ScreenUtil.ensureScreenSize();

  runApp(ProviderScope(child: const MyApp()));

}

/// EasyLoading configaration 
void configEasyLoading(BuildContext context) {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 60.0
    ..radius = 16.0
    ..progressColor = Colors.transparent
    ..backgroundColor = Colors.transparent
    ..indicatorColor = Colors.transparent
    ..textColor = Colors.transparent
    ..maskColor = Colors.black.withAlpha(100)
    ..maskType = EasyLoadingMaskType.custom
    ..userInteractions = false
    ..dismissOnTap = false
    ..indicatorWidget = const NexTalkLoadingWidget()
    ..boxShadow = <BoxShadow>[];
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenUtilInit(
      designSize: const Size(375, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      builder: (context, child) => MaterialApp.router(
        routerConfig: ref.watch(goRouterProvider),
        title: 'Nex Talk',
        theme: lightTheme,
        builder: EasyLoading.init(
          builder: (context, child) {
            configEasyLoading(context);
            topBarSize = context.padding.top;
            bottomViewPadding = context.padding.bottom;
            return MediaQuery(
              data: context.mq.copyWith(
                devicePixelRatio: 1.0,
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          }
        ),
      ),
    );
  }
}
