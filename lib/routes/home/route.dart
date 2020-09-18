import 'package:flutter/material.dart';

import 'home.dart';

class HomeRoute extends StatefulWidget {
  static const String routeName = "/home";

  HomeRoute({Key key}) : super(key: key);

  static Widget routeBuilder(BuildContext context) => HomeRoute();

  @override
  HomeRouteState createState() => HomeRouteState();
}