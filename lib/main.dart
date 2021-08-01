import 'package:flutter/material.dart';
import 'package:flutter_nav_tests/demos/go_router.dart';
import 'demos/vrouter.dart';

/// This value notifier is used as the src of truth for all demos
ValueNotifier<String> urlNotifier = ValueNotifier('/');

enum DemoKind { vrouter, gorouter }

void main(List<String> args) {
  final demoKind = args.length == 1 && args[0] == 'gorouter'
      ? DemoKind.gorouter
      : DemoKind.vrouter;

  runApp(App(demoKind));
}

class App extends StatelessWidget {
  final demoKind;
  const App(this.demoKind, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (demoKind) {
      case DemoKind.vrouter:
        return VRouterDemo();
      case DemoKind.gorouter:
        return GoRouterDemo();
      default:
        throw Exception('oops');
    }
  }
}
