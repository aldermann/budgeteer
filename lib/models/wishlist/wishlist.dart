import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import "package:hive_flutter/hive_flutter.dart";

import 'wish_item.dart';

abstract class WishList {
  static const boxName = "wishlist";

  static Future<void> openBox() {
    return Hive.openBox<WishItem>(boxName);
  }

  static Box<WishItem> getBox() {
    return Hive.box<WishItem>(boxName);
  }

  static void register() {
    Hive.registerAdapter<WishItem>(WishItemAdapter());
  }

  static Iterable<WishItem> get values => getBox().values;

  static ValueListenable<Box<WishItem>> get listenable => getBox().listenable();

  static void add(WishItem wishItem) {
    getBox().add(wishItem);
  }

  static void get(dynamic key) {
    getBox().get(key);
  }
}
