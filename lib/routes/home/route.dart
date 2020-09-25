import 'package:flutter/material.dart';

import '../config.dart';
import 'home.dart';

class HomeRoute extends StatefulWidget {
  static const RouteConfig config = RouteConfig("/", "Home", Icons.home);

  HomeRoute({Key key}) : super(key: key);

  static Widget routeBuilder(BuildContext context) => HomeRoute();

  @override
  HomeRouteState createState() => HomeRouteState();
}
