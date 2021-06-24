import 'package:flutter/material.dart';
import 'package:flutter_nav_tests/shared_widgets.dart';
import 'package:vrouter/vrouter.dart';

import '../main.dart';
import '../shared_paths.dart';

class VRouterTest extends StatefulWidget {
  @override
  State<VRouterTest> createState() => _VRouterTestState();
}

class _VRouterTestState extends State<VRouterTest> {
  final GlobalKey<VRouterState> routerKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    // Hook VRouter into the urlNotifier that is shared by all the demos
    urlNotifier.addListener(() {
      routerKey.currentState?.push(urlNotifier.value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return VRouter(
      // Update the urlNotifier whenever path changes, this keeps urlNotifier.path in sync when pop() is called
      afterEnter: (_, __, path) => urlNotifier.value = path,
      key: routerKey,
      initialUrl: urlNotifier.value,
      debugShowCheckedModeBanner: false,
      buildTransition: (inAnim, _, child) => FadeTransition(opacity: inAnim, child: child),
      routes: [
        // Use a top level nester to add our main tab menu (shirts | pants | hats )
        VNester(
          path: null,
          widgetBuilder: (child) => MainAppScaffold(content: child),
          nestedRoutes: [
            /// Home view, does not show any sub-menu
            VWidget(path: "/", widget: HomeView()),

            /// Each of these methods declares 6 routes,
            /// and wraps them in nested sub menu

            /// For example, _buildShirtRoutes declares:
            ///   /shirts/tees,
            ///   /shirts/tees/productInfo/:id
            ///   /shirts/sweaters,
            ///   /shirts/sweaters/productInfo/:id
            ///   /shirts/tanks,
            ///   /shirts/tanks/productInfo/:id
            ///   And wraps them all in a shared menu of ( tees | sweats | tanks )
            /// SHIRTS
            ..._buildShirtRoutes(),

            /// PANTS
            ..._buildPantRoutes(),

            /// HATS
            ..._buildHatRoutes(),
          ],
        ),
        VWidget(path: r':_(.*)', widget: UnknownPathWidget())
      ],
    );
  }

  List<VRouteElement> _buildShirtRoutes() {
    return [
      VNester(
        path: '/$shirts/',
        // Nesting: Wrap a secondary tab menu around these child routes
        widgetBuilder: (child) => NestedTabScaffold(
          child: child,
          category: shirts,
          subCategories: [tees, sweaters, tanks],
        ),
        nestedRoutes: [
          // Tees
          VWidget(
            path: "$tees",
            widget: ProductsListPage(category: shirts, subCategory: tees),
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
          // Sweaters
          VWidget(
            path: "$sweaters",
            widget: ProductsListPage(category: shirts, subCategory: sweaters),
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
          // Tanks
          VWidget(
            path: "$tanks",
            widget: ProductsListPage(category: shirts, subCategory: tanks),
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
        ],
      )
    ];
  }

  List<VRouteElement> _buildPantRoutes() {
    return [
      VNester(
        path: '/$pants/',
        // Nesting: Wrap a secondary tab menu around these child routes
        widgetBuilder: (child) => NestedTabScaffold(
          child: child,
          category: pants,
          subCategories: [sweats, jeans, shorts],
        ),
        nestedRoutes: [
          // Tees
          VWidget(
            path: "$sweats",
            widget: ProductsListPage(category: pants, subCategory: sweats),
            // Product info page is stacked on to of the productList, back button "just works"
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
          // Sweaters
          VWidget(
            path: "$jeans",
            widget: ProductsListPage(category: pants, subCategory: jeans),
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
          // Tanks
          VWidget(
            path: "$shorts",
            widget: ProductsListPage(category: pants, subCategory: shorts),
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
        ],
      )
    ];
  }

  List<VRouteElement> _buildHatRoutes() {
    return [
      VNester(
        path: '/$hats/',
        // Nesting: Wrap a secondary tab menu around these child routes
        widgetBuilder: (child) => NestedTabScaffold(
          child: child,
          category: hats,
          subCategories: [toques, visors, caps],
        ),
        nestedRoutes: [
          // Tees
          VWidget(
            path: "$toques",
            widget: ProductsListPage(category: hats, subCategory: toques),
            // Product info page is stacked on to of the productList, back button "just works"
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
          // Sweaters
          VWidget(
            path: "$visors",
            widget: ProductsListPage(category: hats, subCategory: visors),
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
          // Tanks
          VWidget(
            path: "$caps",
            widget: ProductsListPage(category: hats, subCategory: caps),
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
        ],
      )
    ];
  }
}
