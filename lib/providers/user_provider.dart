import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  int userID;
  String email = "";
  String avatarURL = "";
  String fName = "";
  int income = 0;
  int savingsTarget = 0;
  String createdAt = "";
  int focusGoal = 0;
  bool newUser = false;

  UserProvider({
    this.userID = 0,
    this.email = "",
    this.avatarURL = "",
    this.fName = "",
    this.income = 0,
    this.savingsTarget = 0,
    this.createdAt = "",
    this.focusGoal = 0,
    this.newUser = false,
  });

  void logoutUser() async {
    userID = 0;
    email = "";
    avatarURL = "";
    fName = "";
    income = 0;
    savingsTarget = 0;
    createdAt = "";
    focusGoal = 0;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    notifyListeners();
  }

  void loginUser({
    required int loginUserID,
    required String loginEmail,
    required String loginAvatarURL,
    required String loginFName,
    required int loginIncome,
    required int loginSavingsTarget,
    required String loginCreatedAt,
    required int loginFocusGoal,
    required bool firstLogin,
  }) async {
    userID = loginUserID;
    email = loginEmail;
    avatarURL = loginAvatarURL;
    fName = loginFName;
    income = loginIncome;
    savingsTarget = loginSavingsTarget;
    createdAt = loginCreatedAt;
    focusGoal = loginFocusGoal;
    newUser = firstLogin;
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

  void changeFocusGoal({
    required int newFocusGoal,
  }) async {
    focusGoal = newFocusGoal;
    notifyListeners();
  }
}
