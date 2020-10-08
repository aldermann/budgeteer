import 'package:budgeteer/models/models.dart';
import "package:flutter/material.dart";

import '../config.dart';
import 'wishlist.dart';
import "add_wishitem.dart";
export "payment.dart";

class WishListRoute extends StatefulWidget {
  static const RouteConfig config = RouteConfig(
    "/wishlist",
    "Wishlist",
    Icons.shopping_cart,
  );

  const WishListRoute({Key key}) : super(key: key);

  static Widget routeBuilder(BuildContext context) {
    return WishListRoute();
  }

  @override
  WishListRouteState createState() => WishListRouteState();
}

class AddWishItemRoute extends StatefulWidget {
  static const RouteConfig config = RouteConfig(
    "/wishlist/add",
    "Add wish",
    Icons.shopping_cart,
  );

  final WishItem wishItem;

  const AddWishItemRoute({Key key, this.wishItem}) : super(key: key);

  static Widget routeBuilder(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments;
    if (args != null && !(args is WishItem)) {
      throw AssertionError(
          "Argument for ${config.routePath} must be a WishItem object");
    }
    return AddWishItemRoute(wishItem: args);
  }

  @override
  AddWishItemRouteState createState() => AddWishItemRouteState();
}
