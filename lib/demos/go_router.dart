import 'package:flutter/material.dart';

import '../main.dart';
import 'package:go_router/go_router.dart';

class GoRouterDemo extends StatefulWidget {
  @override
  _GoRouterDemoState createState() => _GoRouterDemoState();
}

class _GoRouterDemoState extends State<GoRouterDemo> {
  @override
  void initState() {
    // hook GoRouter into the urlNotifier that is shared by all the demos
    urlNotifier.addListener(() => context.go(urlNotifier.value));
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        home: Scaffold(body: Center(child: Text('GoRouterDemo'))),
      );
}
