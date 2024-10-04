import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  int userID;
  String email = "";
  String avatarURL = "";
  String fName = "";
  int income = 0;
  int savingsTarget = 0;
  String createdAt = "";

  UserProvider({
    this.userID = 0,
    this.email = "",
    this.avatarURL = "",
    this.fName = "",
    this.income = 0,
    this.savingsTarget = 0,
    this.createdAt = "",
  });

  void changeUserID({
    required int newUserID,
  }) async {
    userID = newUserID;
    notifyListeners();
  }

  void changeEmail({
    required String newEmail,
  }) async {
    email = newEmail;
    notifyListeners();
  }

  void changeAvatarURL({
    required String newAvatarURL,
  }) async {
    avatarURL = newAvatarURL;
    notifyListeners();
  }

  void changeFName({
    required String newFName,
  }) async {
    fName = newFName;
    notifyListeners();
  }

  void changeIncome({
    required int newIncome,
  }) async {
    income = newIncome;
    notifyListeners();
  }

  void changeSavingsTarget({
    required int newSavingsTarget,
  }) async {
    savingsTarget = newSavingsTarget;
    notifyListeners();
  }

  void changeCreatedAt({
    required String newCreatedAt,
  }) async {
    createdAt = newCreatedAt;
    notifyListeners();
  }
}
