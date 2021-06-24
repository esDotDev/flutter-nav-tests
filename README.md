# flutter_nav_tests

This demo shows a common design pattern of nested navigation menus:
  * We want to be able to show a persistent menu or chrome, around a set of child pages.
  * This should be able to be applied recursively (main menu, secondary menu, tertiary menu, etc)
  * To support this, a routing solution needs to be able to declare multiple builder methods around a single matched route.
  Imperatively, all this really ends up being is:
```
    builder1.build(                        // menu
      child: builder2.build(               // sub-menu
                                           // etc
        child: theMatchedRoute)))          // the content
```
One clear example of an app that uses this structure is twitter:
https://play-lh.googleusercontent.com/tTCj4Uv869MDcvf1yaFDEkvhC6YxqD45MRXxxomJWwBYy_DSzip2wjiTMN0zQR_9Yw=w2560-h937-rw
https://play-lh.googleusercontent.com/Isv38ThMJRqzdJa-ECu0rQZKsYU7uYTheFQim2vTanrzFqGwtXvYFQk5LttiH99PXg=w2560-h937-rw

Ideally the route transition should be applied inside of the nested widgets.
  * Your tab menu should not slide-in with every page, instead the tab menu should be persistent and stateful.
  * The content at the leaf node is what fades or slides into view

The basic structure of this demo is:
* home
* shirts
  * tees
    * productDetails
  * sweaters
    * productDetails
  * tanks
    * productDetails
* pants
  * sweats
    * productDetails
  * jeans
    * productDetails
  * shorts
    * productDetails
* hats
   * toques
      * productDetails
   * visors
      * productDetails
   * caps
      * productDetails
