library smart_money_app.globals;

class Globals {
  int userID;

  Globals({this.userID = 0});

  void changeID({
    required int newUserID,
  }) async {
    userID = newUserID;
  }
}
