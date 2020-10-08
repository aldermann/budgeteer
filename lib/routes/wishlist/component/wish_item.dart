import 'package:budgeteer/models/models.dart';
import 'package:flutter/material.dart';

import '../route.dart';
import 'countdown.dart';

enum _WishItemAction {
  Edit,
  Delete,
  Buy,
}

class WishItemWidget extends StatelessWidget {
  final WishItem item;

  const WishItemWidget({Key key, this.item}) : super(key: key);

  _handleEdit(BuildContext context) => () {
        Navigator.pushNamed(
          context,
          AddWishItemRoute.config.routePath,
          arguments: item,
        );
      };

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ListTile(
      leading: Icon(item.type.icon),
      title: Text(item.name),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.price.representation(extended: true),
            style: theme.textTheme.subtitle1.copyWith(color: Colors.red),
          ),
          Countdown(
              item: item,
              builder: (BuildContext context, Duration duration) {
                if (duration == Duration()) {
                  return Text("Ready");
                }
                int days = duration.inDays;
                int hours = duration.inHours.remainder(Duration.hoursPerDay);
                int minutes =
                    duration.inMinutes.remainder(Duration.minutesPerHour);
                int seconds =
                    duration.inSeconds.remainder(Duration.secondsPerMinute);
                return Text("$days day, $hours:$minutes:$seconds remaining");
              })
        ],
      ),
      onLongPress: _handleEdit(context),
      trailing: PopupMenuButton<_WishItemAction>(
        icon: Icon(Icons.more_vert),
        itemBuilder: (BuildContext innerContext) {
          return <PopupMenuEntry<_WishItemAction>>[
            PopupMenuItem<_WishItemAction>(
              value: _WishItemAction.Edit,
              child: Text("Edit"),
            ),
            PopupMenuItem<_WishItemAction>(
              value: _WishItemAction.Delete,
              child: Text("Delete"),
            ),
            if (item.isReady)
              PopupMenuItem<_WishItemAction>(
                value: _WishItemAction.Buy,
                child: Text("Buy"),
              ),
          ];
        },
        onSelected: (_WishItemAction action) {
          switch (action) {
            case _WishItemAction.Edit:
              _handleEdit(context)();
              break;
            case _WishItemAction.Delete:
              item.deleteWithConfirmation(context);
              break;
            case _WishItemAction.Buy:
              Navigator.pushNamed(
                context,
                AddWishPaymentRoute.config.routePath,
                arguments: item,
              );
          }
        },
      ),
    );
  }
}
