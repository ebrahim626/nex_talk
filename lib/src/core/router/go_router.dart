part of 'go_router.export.dart';

final navigatorKeyProvider = Provider<GlobalKey<NavigatorState>>(
  (ref) => GlobalKey<NavigatorState>(),
);

final navigatorContextProvider = Provider<BuildContext?>((ref) {
  final key = ref.watch(navigatorKeyProvider);
  return key.currentContext;
});

final goRouterProvider = Provider<GoRouter>((ref) {
  final navigatorKey = ref.watch(navigatorKeyProvider);
  return GoRouter(
    initialLocation: AppRoutes.splashScreenRoute,
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.splashScreenRoute,
        name: SplashScreen.name,
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginRoute,
        name: LoginScreen.name,
        builder: (context, state) => LoginScreen(),
      ),

      GoRoute(
        path: AppRoutes.directChatScreenRoute,
        name: DirectChatScreen.name,
        builder: (context, state) =>
            DirectChatScreen(chat: state.extra as ChatSummary),
      ),

      GoRoute(
        path: AppRoutes.profileScreenRoute,
        name: ProfileScreen.name,
        builder: (context, state) => ProfileScreen(),
      ),

      /// Home routes
      ShellRoute(
        builder: (context, state, child) {
          return BottomNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.searchRoute,
            name: AllChatScreen.name,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>? ?? {};
              return AllChatScreen(
                initialTab: extra['tab'] as int? ?? 0,
                userId: extra['userId'] as String? ?? '',
              );
            },
          ),
        ],
      ),
    ],
  );
});
