import 'package:hive/hive.dart';

const String _METADATA_BOX_NAME = "METADATA";
const String _INSTALLATION_DATE = "INSTALLATION_DATE";

class Metadata {
  static Metadata _instance;
  DateTime installationDate;

  Metadata._internal({this.installationDate});

  static Future<Metadata> init() async {
    Box metadataBox = await Hive.openBox(_METADATA_BOX_NAME);
    DateTime installationDate;
    if (!metadataBox.containsKey(_INSTALLATION_DATE)) {
      installationDate = DateTime.now();
      metadataBox.put(_INSTALLATION_DATE, installationDate);
    } else {
      installationDate = metadataBox.get(_INSTALLATION_DATE);
    }

    Metadata._instance = Metadata._internal(installationDate: installationDate);
    return Metadata._instance;
  }

  factory Metadata() {
    return Metadata._instance;
  }
}
