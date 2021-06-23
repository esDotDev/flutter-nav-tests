import 'package:flutter/material.dart';
import 'package:flutter_nav_tests/shared_paths.dart';
import 'demos/vrouter.dart';

/// This value notifier is used as the src of truth for all demos
ValueNotifier<String> urlNotifier = ValueNotifier('/$shirts/$tees');

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VRouterTest();
  }
}
