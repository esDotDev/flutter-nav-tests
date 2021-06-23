import 'package:flutter/material.dart';
import 'package:flutter_nav_tests/shared_paths.dart';
import 'demos/vrouter.dart';

/// This value notifier is used as the src of truth for all demos
ValueNotifier<String> urlNotifier = ValueNotifier('/$shirts/$tees');

/// This demo shows a common design pattern of nested navigation menus:
///   * When we're inside of a top-level section, we want to show a sub-menu around all pages in that section.
///   * To support this, a routing solution needs to be able to declare multiple builder methods around a matched route.

///     All this really ends up being is a list of builder methods, and a single matched route:
///     builder1.build(                        // menu
///       child: builder1.build(               // sub-menu
///         child: theMatchedRoute)))          // the content

/// One clear example of an app that uses this structure is twitter.
/// https://play-lh.googleusercontent.com/tTCj4Uv869MDcvf1yaFDEkvhC6YxqD45MRXxxomJWwBYy_DSzip2wjiTMN0zQR_9Yw=w2560-h937-rw
/// https://play-lh.googleusercontent.com/Isv38ThMJRqzdJa-ECu0rQZKsYU7uYTheFQim2vTanrzFqGwtXvYFQk5LttiH99PXg=w2560-h937-rw

/// Ideally the route transition should be applied inside of the nested widgets.
///   * Your tab menu should not slide-in with every page, instead the tab menu should be persistent and stateful.
///   * The inner content is what fades or slides into view

/// The basic structure of this demo is:
// home
// shirts
//    tees
//        productDetails
//     sweaters
//        productDetails
//     tanks
//        productDetails
// pants
//     sweats
//        productDetails
//     jeans
//        productDetails
//     shorts
//        tankDetails
// hats
//    toques
//        productDetails
//    visors
//        productDetails
//    caps
//        tankDetails

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return VRouterTest();
  }
}
