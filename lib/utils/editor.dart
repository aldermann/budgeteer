enum EditMode {
  Update,
  Create
}

extension EditModeExtension on EditMode {
  String get name {
    switch(this) {
      case EditMode.Update:
        return "Update";
      case EditMode.Create:
        return "Create";
    }
    return "";
  }
}