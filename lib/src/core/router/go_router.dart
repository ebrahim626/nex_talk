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
    initialLocation: AppRoutes.loginRoute,
    navigatorKey: navigatorKey,
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: AppRoutes.loginRoute,
        name: LoginScreen.name,
        builder: (context, state) => LoginScreen(),
      ),

      GoRoute(
        path: AppRoutes.directChatScreenRoute,
        name: DirectChatScreen.name,
        builder: (context, state) => DirectChatScreen(),
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
            builder: (builder, state) => AllChatScreen(initialTab: state.extra as int? ?? 0),
          ),
        ],
      ),
    ],
  );
});
