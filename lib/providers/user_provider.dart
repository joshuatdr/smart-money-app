import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int userID;

  UserProvider({this.userID = 0});

  void changeUserID({
    required int newUserID,
  }) async {
    userID = newUserID;
    notifyListeners();
  }
}
