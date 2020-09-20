enum EditMode {
  Update,
  Create,
  View,
}

extension EditModeExtension on EditMode {
  String get name {
    switch(this) {
      case EditMode.Update:
        return "Update";
      case EditMode.Create:
        return "Create";
      case EditMode.View:
        return "View";
    }
    return "";
  }
}