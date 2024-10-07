class Expenses {
  // Create a class Transactions
  int? expenseId;
  String? name;
  num? cost;
  int? userId;

  Expenses(
      {this.expenseId,
      this.name,
      this.cost,
      this.userId}); // This is the constructor

  Expenses.fromJson(Map<String, dynamic> json) {
    expenseId = json['monthly_expense_id'];
    name = json['name'];
    cost = json['cost'];
    userId = json['user_id'];
  }
}
