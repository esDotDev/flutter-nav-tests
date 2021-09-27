import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav_tests/shared_paths.dart';
import 'package:vrouter/vrouter.dart';

import 'main.dart';

/// Main scaffold, should wrap all the pages in the app, adds the main TabMenu
class MainAppScaffold extends StatelessWidget {
  final Widget content;

  const MainAppScaffold({Key? key, required this.content}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    EdgeInsets padding =
        const EdgeInsets.symmetric(vertical: 24, horizontal: 8);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: content),
            Row(
              children: [
                _TabBtn('/', label: "Home", padding: padding, exactMatch: true),
                _TabBtn('/$shirts/$tees',
                    rootPath: shirts, label: "Shirts", padding: padding),
                _TabBtn('/$pants/$sweats',
                    rootPath: pants, label: "Pants", padding: padding),
                _TabBtn('/$hats/$toques',
                    rootPath: hats, label: "Hats", padding: padding),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(urlNotifier.value),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  final String tag;
  const HomeView(this.tag, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      alignment: Alignment.center,
      color: Colors.blue.shade300,
      child: Text("HOME: $tag"));
}

class NestedTabScaffold extends StatelessWidget {
  const NestedTabScaffold(
      {Key? key,
      required this.child,
      required this.category,
      required this.subCategories})
      : super(key: key);
  final Widget child;
  final String category;
  final Iterable<String> subCategories;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
              children: subCategories
                  .map((e) => _TabBtn('/$category/$e', fontSize: 14))
                  .toList()),
          Expanded(child: child),
        ],
      );
}

class ProductsListPage extends StatelessWidget {
  ProductsListPage(
      {Key? key, required this.category, required this.subCategory})
      : super(key: key);

  final String category;
  final String subCategory;
  late final List<_ProductBtn> _btns = List.generate(
    20,
    (index) => _ProductBtn(
        "/$category/$subCategory/$productInfo/${Random().nextInt(999)}"),
  );

  @override
  Widget build(BuildContext context) => ListView(children: _btns);
}

class ProductDetailsPage extends StatelessWidget {
  final String id;
  const ProductDetailsPage(this.id, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Stack(
          children: [
            Container(
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                width: double.infinity,
                child: Text(id, style: TextStyle(fontSize: 32))),
            Padding(
              padding: const EdgeInsets.all(16),
              child: BackButton(),
              // Product details
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductBtn extends StatelessWidget {
  const _ProductBtn(this.path, {Key? key}) : super(key: key);
  final String path;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => urlNotifier.value = path,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
                color: Colors.grey.shade200,
                alignment: Alignment.center,
                height: 200,
                width: double.infinity,
                child: Text(path, style: TextStyle(fontSize: 32))),
          ),
        ],
      ),
    );
  }
}

class _TabBtn extends StatelessWidget {
  const _TabBtn(this.path,
      {Key? key,
      this.label,
      this.padding,
      this.rootPath,
      this.exactMatch = false,
      this.fontSize})
      : super(key: key);

  /// When pressed the button will change urlNotifier.value to this path.
  /// If path matches the current url, this button will be visually selected.
  final String path;

  /// Overrides path, allowing an alternate path to be used for the visual selection check.
  final String? rootPath;

  /// Display label, falls back to path if null
  final String? label;

  final EdgeInsets? padding;

  /// Button is selected only on exact matches to path
  final bool exactMatch;

  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    String pathToMatch = rootPath ?? path;
    bool isSelected = exactMatch
        ? urlNotifier.value == pathToMatch
        : urlNotifier.value.contains(pathToMatch);
    Color bgColor = isSelected ? Colors.grey.shade300 : Colors.grey.shade200;
    return Expanded(
      child: OutlinedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
              backgroundColor: MaterialStateProperty.all(bgColor)),
          onPressed: _handlePressed,
          child: Padding(
            padding: padding ?? const EdgeInsets.all(8.0),
            child: Text(
              label ?? path,
              softWrap: false,
              style: TextStyle(
                  fontSize: fontSize ?? 20, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
          )),
    );
  }

  void _handlePressed() => urlNotifier.value = path;
}

class UnknownPathWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
      color: Colors.white,
      child: Column(
        children: [
          TextButton(
            child: Text('<< Back'),
            onPressed: () =>
                urlNotifier.value = VRouter.of(context).previousUrl!,
          ),
          Spacer(),
          Text('404: Page not found.'),
          Text('${urlNotifier.value}'),
          Spacer(),
        ],
      ));
}
