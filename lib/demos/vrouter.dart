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
        // VWidget(path: r':_(.*)', widget: UnknownPathWidget())
      ],
    );
  }

  List<VRouteElement> _buildShirtRoutes() {
    return [
      VWidget(
        path: '/$shirts',
        widget: TextButton(child: Text("tees"), onPressed: () => routerKey.currentState?.push('$tees')),
      ),
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
            widget: ProductsListPage(tees, category: shirts),
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
          // Sweaters
          VWidget(
            path: "$sweaters",
            widget: ProductsListPage(sweaters, category: shirts),
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
          // Tanks
          VWidget(
            path: "$tanks",
            widget: ProductsListPage(tanks, category: shirts),
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
      VWidget(
        path: '/$pants',
        widget: TextButton(child: Text("pants"), onPressed: () => routerKey.currentState?.push('$pants')),
      ),
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
            widget: ProductsListPage(sweats, category: pants),
            // Product info page is stacked on to of the productList, back button "just works"
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
          // Sweaters
          VWidget(
            path: "$jeans",
            widget: ProductsListPage(jeans, category: pants),
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
          // Tanks
          VWidget(
            path: "$shorts",
            widget: ProductsListPage(shorts, category: pants),
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
      VWidget(
        path: '/$hats',
        widget: TextButton(child: Text("hats"), onPressed: () => routerKey.currentState?.push('$hats')),
      ),
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
            widget: ProductsListPage(toques, category: hats),
            // Product info page is stacked on to of the productList, back button "just works"
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
          // Sweaters
          VWidget(
            path: "$visors",
            widget: ProductsListPage(visors, category: hats),
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
          // Tanks
          VWidget(
            path: "$caps",
            widget: ProductsListPage(caps, category: hats),
            stackedRoutes: [
              VWidget(path: "$productInfo/:id", widget: ProductDetailsPage()),
            ],
          ),
        ],
      )
    ];
  }
}
