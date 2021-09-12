import 'package:flutter/material.dart';
import 'package:flutter_nav_tests/shared_widgets.dart';

import '../main.dart';
import 'package:go_router/go_router.dart';

class GoRouterDemo extends StatefulWidget {
  @override
  _GoRouterDemoState createState() => _GoRouterDemoState();
}

class _GoRouterDemoState extends State<GoRouterDemo> {
  void _go() => _router.go(urlNotifier.value);
  void _going() => urlNotifier.value = _router.location;

  @override
  void initState() {
    super.initState();

    // hook GoRouter into the urlNotifier that is shared by all the demos
    urlNotifier.addListener(_go);

    // Update the urlNotifier whenever the location changes; this keeps
    // urlNotifier.value in sync when pop() is called
    // TODO: this doesn't yet work for pop
    _router.routerDelegate.addListener(_going);
  }

  @override
  void dispose() {
    urlNotifier.removeListener(_go);
    _router.routerDelegate.removeListener(_going);
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
        path: '/shirts/:kind(tees|sweaters|tanks)',
        builder: (context, state) => FadeTransitionPage(
          key: state.pageKey,
          child: MainAppScaffold(
            content: NestedTabScaffold(
              category: 'shirts',
              subCategories: ['tees', 'sweaters', 'tanks'],
              child: ProductsListPage(
                category: 'shirts',
                subCategory: state.params['kind']!,
              ),
            ),
          ),
        ),
        routes: [
          GoRoute(
            path: 'productInfo/:id',
            builder: (context, state) => FadeTransitionPage(
              key: state.pageKey,
              child: MainAppScaffold(
                content: NestedTabScaffold(
                  category: 'shirts',
                  subCategories: ['tees', 'sweaters', 'tanks'],
                  child: ProductDetailsPage(state.params['id']!),
                ),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/pants/:kind(sweats|jeans|shorts)',
        builder: (context, state) => FadeTransitionPage(
          key: state.pageKey,
          child: MainAppScaffold(
            content: NestedTabScaffold(
              category: 'pants',
              subCategories: ['sweats', 'jeans', 'shorts'],
              child: ProductsListPage(
                category: 'pants',
                subCategory: state.params['kind']!,
              ),
            ),
          ),
        ),
        routes: [
          GoRoute(
            path: 'productInfo/:id',
            builder: (context, state) => FadeTransitionPage(
              key: state.pageKey,
              child: MainAppScaffold(
                content: NestedTabScaffold(
                  category: 'pants',
                  subCategories: ['sweats', 'jeans', 'shorts'],
                  child: ProductDetailsPage(state.params['id']!),
                ),
              ),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/hats/:kind(toques|visors|caps)',
        builder: (context, state) => FadeTransitionPage(
          key: state.pageKey,
          child: MainAppScaffold(
            content: NestedTabScaffold(
              category: 'hats',
              subCategories: ['toques', 'visors', 'caps'],
              child: ProductsListPage(
                category: 'hats',
                subCategory: state.params['kind']!,
              ),
            ),
          ),
        ),
        routes: [
          GoRoute(
            path: 'productInfo/:id',
            builder: (context, state) => FadeTransitionPage(
              key: state.pageKey,
              child: MainAppScaffold(
                content: NestedTabScaffold(
                  category: 'hats',
                  subCategories: ['toques', 'visors', 'caps'],
                  child: ProductDetailsPage(state.params['id']!),
                ),
              ),
            ),
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
}

class FadeTransitionPage<T> extends Page<T> {
  final Widget child;
  final Duration duration;

  const FadeTransitionPage({
    required this.child,
    LocalKey? key,
    this.duration = const Duration(milliseconds: 300),
  }) : super(key: key);

  @override
  Route<T> createRoute(BuildContext context) =>
      PageBasedFadeTransitionRoute<T>(this);
}

class PageBasedFadeTransitionRoute<T> extends PageRoute<T> {
  final FadeTransitionPage<T> _page;

  PageBasedFadeTransitionRoute(this._page) : super(settings: _page);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  Duration get transitionDuration => _page.duration;

  @override
  bool get maintainState => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    final curveTween = CurveTween(curve: Curves.easeIn);
    return FadeTransition(
      opacity: animation.drive(curveTween),
      child: (settings as FadeTransitionPage).child,
    );
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation, Widget child) =>
      child;
}
