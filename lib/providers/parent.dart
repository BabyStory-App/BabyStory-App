import 'package:babystory/models/parent.dart';
import 'package:flutter/material.dart';

class ParentProvider with ChangeNotifier {
  Parent? _parent;

  Parent? get parent => _parent;

  void setParent(Parent parent) {
    _parent = parent;
  }

  void clearValue() {
    _parent = null;
    notifyListeners();
  }

  void updateParent(Parent parent) {
    _parent = parent;
    notifyListeners();
    _parent?.printInfo();
  }

  void updateParentWithouthNotify(Parent parent) {
    _parent = parent;
  }

  bool isParentExist() {
    return _parent != null;
  }
}
