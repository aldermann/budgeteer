import 'package:budgeteer/components/drawer.dart';
import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'component/wish_item.dart';
import 'route.dart';



class WishListWidget extends StatelessWidget {
  final List<WishItem> items;

  const WishListWidget({Key key, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                return WishItemWidget(
                  item: items[index],
                );
              }),
        ),
      ],
    );
  }
}

class WishListRouteState extends State<WishListRoute> {
  MonthYear currentMonth = MonthYear.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(WishListRoute.config.routeName)),
      drawer: RouteDrawer.defaultDrawer(WishListRoute.config.routePath),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: WishList.listenable,
                builder: (
                  BuildContext context,
                  Box<WishItem> box,
                  Widget widget,
                ) {
                  return WishListWidget(
                    items: box.values.toList(),
                  );
                },
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {
                  Navigator.pushNamed(
                      context, AddWishItemRoute.config.routePath);
                },
                child: Text(AddWishItemRoute.config.routeName),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
