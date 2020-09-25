import 'package:budgeteer/routes/config.dart';
import 'package:budgeteer/routes/routes.dart';
import "package:flutter/material.dart";

class DrawerWidget extends StatelessWidget {
  final List<RouteConfig> routes;
  final String currentRoutePath;

  DrawerWidget({
    Key key,
    this.routes,
    this.currentRoutePath,
  }) : super(key: key);

  DrawerWidget.defaultDrawer(final String currentRoutePath)
      : this(
          routes: <RouteConfig>[HomeRoute.config],
          currentRoutePath: currentRoutePath,
        );

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          children: routes
              .map((RouteConfig r) => ListTile(
                    title: Text(r.routeName),
                    leading: Icon(r.icon),
                    selected: r.routePath == currentRoutePath,
                  ))
              .toList(),
        ),
      ),
    );
  }
}
