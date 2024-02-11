import 'package:flutter/foundation.dart';

class UserState extends ChangeNotifier {
  String _userId = '';

  String get userId => _userId;

  void setUserId(String userId) {
    _userId = userId;
    notifyListeners();
  }
}