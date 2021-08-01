import 'package:flutter/material.dart';
import 'package:flutter_nav_tests/shared_widgets.dart';

import '../main.dart';
import 'package:go_router/go_router.dart';

class GoRouterDemo extends StatefulWidget {
  @override
  _GoRouterDemoState createState() => _GoRouterDemoState();
}

class _GoRouterDemoState extends State<GoRouterDemo> {
  late final GoRouter _router;

  void _go() => context.go(urlNotifier.value);

  @override
  void initState() {
    super.initState();

    // hook GoRouter into the urlNotifier that is shared by all the demos
    urlNotifier.addListener(_go);

    // create a router
    _router = GoRouter(
      routes: _routes,
      error: _error,
      initialLocation: urlNotifier.value,
    );
  }

  List<GoRoute> _routes(BuildContext context, String location) {
    // Update the urlNotifier whenever path changes, this keeps
    // urlNotifier.value in sync when pop() is called
    urlNotifier.value = location;

    return [
      GoRoute(
        path: '/',
        builder: (context, state) => MaterialPage(
          child: MainAppScaffold(content: HomeView()),
        ),
      )
    ];
  }

  Page<dynamic> _error(BuildContext context, GoRouterState state) =>
      MaterialPage(child: Scaffold(body: Text(state.error.toString())));

  @override
  void dispose() {
    urlNotifier.removeListener(_go);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        routeInformationParser: _router.routeInformationParser,
        routerDelegate: _router.routerDelegate,
      );
}
