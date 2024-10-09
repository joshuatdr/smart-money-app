class User {
  int? id; // Declare instance variables (https://dart.dev/language/classes)
  String? email; // No default values declared so will be null.
  String? password;
  // ignore: non_constant_identifier_names
  String? avatar_url;
  String? nickName;
  int? income;
  int? savingsTarget;
  String? createdAt;
  int? mandatorySpend;
  int? disposableSpend;
  int? focusGoal;

  User({
    this.id,
    this.email,
    this.password,
    // ignore: non_constant_identifier_names
    this.avatar_url,
    this.nickName,
    this.income,
    this.savingsTarget,
    this.createdAt,
    this.mandatorySpend,
    this.disposableSpend,
    this.focusGoal,
  }); // This is the constructor

  User.fromJson(Map<String, dynamic> json) {
    // Is used to create a Dart object from a JSON data structure using map,
    id = json[
        'user_id']; // maps a String key with the dynamic value. Since the key is always a String and the value can be of any type,
    email = json[
        'email']; // it is kept as dynamic to be on the safer side. It is very useful in reading a JSON object as the JSON object
    password = json[
        'password']; // represents a set of key-value pairs where key is of type String while value can be of any type
    avatar_url = json['avatar_url'];
    nickName = json['fname'];
    income = json['income'];
    savingsTarget = json['savings_target'];
    createdAt = json['created_at'];
    mandatorySpend = json['mandatory_spend'];
    disposableSpend = json['disposable_spend'];
    focusGoal = json['focus_goal'];
  }
}
