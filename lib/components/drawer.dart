import 'package:budgeteer/components/fund.dart';
import 'package:budgeteer/models/models.dart';
import 'package:budgeteer/routes/config.dart';
import 'package:budgeteer/routes/routes.dart';
import "package:flutter/material.dart";

class RouteDrawer extends StatelessWidget {
  final List<RouteConfig> routes;
  final String currentRoutePath;

  RouteDrawer({
    Key key,
    this.routes,
    this.currentRoutePath,
  }) : super(key: key);

  RouteDrawer.defaultDrawer(final String currentRoutePath)
      : this(
          routes: <RouteConfig>[
            HomeRoute.config,
            IncomeRoute.config,
            ExpenseRoute.config,
            LoanRoute.config,
            SavingRoute.config,
          ],
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
    ThemeData theme = Theme.of(context);
    List<ListTile> routesListTile = routes.map(
      (RouteConfig r) {
        final bool selected = r.routePath == currentRoutePath;
        return ListTile(
            title: Text(r.routeName),
            leading: Icon(r.icon),
            selected: selected,
            selectedTileColor: theme.cardColor,
            onTap: selected
                ? null
                : () {
                    if (r == HomeRoute.config) {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName(HomeRoute.config.routePath),
                      );
                    } else {
                      Navigator.pushNamed(context, r.routePath);
                    }
                  });
      },
    ).toList();
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
