import 'package:budgeteer/components/fund.dart';
import 'package:budgeteer/models/models.dart';
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

  static Widget headerBuilder(
    BuildContext context,
    Currency totalBudget,
    Currency totalSaving,
  ) {
    ThemeData theme = Theme.of(context);
    return DrawerHeader(
      decoration: BoxDecoration(color: theme.primaryColorDark),
      child: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                text: "Budget: ",
                style: theme.textTheme.headline5,
                children: [
                  TextSpan(
                    text: totalBudget.representation(),
                    style: theme.textTheme.headline5.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                text: "Saving: ",
                style: theme.textTheme.headline5,
                children: [
                  TextSpan(
                    text: totalSaving.representation(),
                    style: theme.textTheme.headline5.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<ListTile> routesListTile = routes
        .map((RouteConfig r) => ListTile(
              title: Text(r.routeName),
              leading: Icon(r.icon),
              selected: r.routePath == currentRoutePath,
            ))
        .toList();
    return Drawer(
      child: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          children: [
            FundListener(
              builder: headerBuilder,
            ),
            ...routesListTile,
          ],
        ),
      ),
    );
  }
}
