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


      /// Home routes
      ShellRoute(
        builder: (context, state, child) {
          return BottomNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.searchRoute,
            name: SearchScreen.name,
            builder: (_, _) => const SearchScreen(),
          ),
        ],
      ),
    ],
  );
});
