import 'package:hive/hive.dart';

part 'hive_link.g.dart';

@HiveType(typeId: 0)
class HiveLink<T extends HiveObject> {
  @HiveField(0)
  String _boxName;

  @HiveField(1)
  var _key; // Could be String or Int

  T _item;

  HiveLink();

  T get item {
    if (_item != null) {
      return _item;
    }
    return _boxName == null || _key == null ? null : Hive.box<T>(_boxName).get(_key);
  }

  set item(T element) {
    _boxName = element?.box?.name;
    _key = element?.key;
    _item = element;
  }
}
