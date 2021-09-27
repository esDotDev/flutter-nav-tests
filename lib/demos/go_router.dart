import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav_tests/shared_widgets.dart';

import '../main.dart';
import 'package:go_router/go_router.dart';

import '../shared_paths.dart';

class GoRouterDemo extends StatefulWidget {
  @override
  _GoRouterDemoState createState() => _GoRouterDemoState();
}

class _GoRouterDemoState extends State<GoRouterDemo> {
  void _go() => _router.go(urlNotifier.value);
  void _gone() => urlNotifier.value = _router.location;

  @override
  void initState() {
    super.initState();

    // hook GoRouter into the urlNotifier that is shared by all the demos
    urlNotifier.addListener(_go);

    // Update the urlNotifier whenever the location changes; this keeps
    // urlNotifier.value in sync when pop() is called
    _router.addListener(_gone);
  }

  @override
  void dispose() {
    urlNotifier.removeListener(_go);
    _router.removeListener(_gone);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      );

  late final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => FadeTransitionPage(
          key: state.pageKey,
          child: MainAppScaffold(content: HomeView('GO_ROUTER')),
        ),
      ),
      GoRoute(
        path: '/:cat(shirts|pants|hats)/:kind',
        builder: (context, state) {
          final cat = state.params['cat']!;
          final subcats = _subcatsFrom(state.params['cat']!);
          final kind = state.params['kind']!;

          return FadeTransitionPage(
            key: ValueKey(state.subloc),
            child: MainAppScaffold(
              content: NestedTabScaffold(
                category: cat,
                subCategories: subcats,
                child: ProductsListPage(
                  category: cat,
                  subCategory: kind,
                ),
              ),
            ),
          );
        },
        routes: [
          GoRoute(
            path: 'productInfo/:id',
            builder: (context, state) {
              final cat = state.params['cat']!;
              final subcats = _subcatsFrom(state.params['cat']!);
              final id = state.params['id']!;

              return FadeTransitionPage(
                key: state.pageKey,
                child: MainAppScaffold(
                  content: NestedTabScaffold(
                    category: cat,
                    subCategories: subcats,
                    child: ProductDetailsPage(id),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    ],
    error: (context, state) => FadeTransitionPage(
      key: state.pageKey,
      child: Scaffold(body: Text(state.error.toString())),
    ),
    initialLocation: urlNotifier.value,
    debugLogDiagnostics: true,
  );

  static Iterable<String> _subcatsFrom(String cat) {
    switch (cat) {
      case 'shirts':
        return ShirtType.values.map(describeEnum);
      case 'pants':
        return PantsType.values.map(describeEnum);
      case 'hats':
        return HatType.values.map(describeEnum);
      default:
        throw Exception('Unknown category: $cat');
    }
  }
}

class FadeTransitionPage<T> extends CustomTransitionPage<T> {
  const FadeTransitionPage({
    required Widget child,
    LocalKey? key,
  }) : super(key: key, transitionsBuilder: _transitionsBuilder, child: child);

  static Widget _transitionsBuilder(
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) =>
      FadeTransition(opacity: animation, child: child);
}
