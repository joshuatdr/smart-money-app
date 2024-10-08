import '../common/dateformat.dart';

class Transactions {
  // Create a class Transactions
  int? transactionId;
  String? name; 
  num? cost;
  String? imgUrl;
  String? createdAt;
  int? userId;
  String? desc;

  Transactions(
    {this.transactionId,
    this.name,
    this.cost,
    this.imgUrl,
    this.createdAt,
    this.userId,
    this.desc}
  ); // This is the constructor

  Transactions.fromJson(Map<String, dynamic> json) {
  transactionId = json['transaction_id'];
  name = json['name'];
  cost = json['cost'];
  imgUrl = json['img_url'];
  createdAt = dateFormat(json['created_at']);
  if (imgUrl == null) {
  imgUrl = "";
  } else {
    imgUrl == json['img_url'];
  }
  userId = json['user_id'];
  desc = json['description'];
  }
}
