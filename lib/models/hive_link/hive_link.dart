import 'package:budgeteer/models/budget/budget.dart';
import 'package:hive/hive.dart';
// ignore: implementation_imports
import 'package:hive/src/hive_impl.dart';

import '../config.dart';

part 'hive_link.g.dart';

@HiveType(typeId: HiveTypeId.HiveLink)
class HiveLink<T extends HiveObject> {
  @HiveField(0)
  String _boxName;

  @HiveField(1)
  var _key; // Could be String or Int

  HiveLink();

  T get item {
    if (_boxName == null || _key == null) {
      return null;
    }
    Box box = (Hive as HiveImpl).getBoxWithoutCheckInternal(_boxName) as Box;
    return box.get(_key);
  }

  set item(T element) {
    _boxName = element?.box?.name;
    _key = element?.key;
  }

  HiveLink<R> cast<R extends T>() {
    return HiveLink<R>()
      .._key = _key
      .._boxName = _boxName;
  }

  static void registerAdapters() {
    Hive.registerAdapter<HiveLink<Budget>>(HiveLinkAdapter<Budget>());
  }
}
