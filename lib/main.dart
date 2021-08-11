import 'package:flutter/material.dart';
import 'package:flutter_nav_tests/demos/go_router.dart';
import 'demos/vrouter.dart';

/// This value notifier is used as the src of truth for all demos
ValueNotifier<String> urlNotifier = ValueNotifier('/');

void main(List<String> args) {
  final app = args.length == 1 && args[0] == 'gorouter'
      ? GoRouterDemo()
      : VRouterDemo();
  runApp(app);
}
