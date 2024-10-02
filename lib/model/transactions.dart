import 'package:intl/intl.dart';


class Transactions {
  // Create a class Transactions
  int? transactionId;
  String? name; 
  num? cost;
  String? imgUrl;
  String? createdAt;
  int? userId;

  Transactions(
      {this.transactionId,
  this.name,
  this.cost,
  this.imgUrl,
  this.createdAt,
  this.userId}); // This is the constructor

  Transactions.fromJson(Map<String, dynamic> json) {
  transactionId = json['transaction_id'];
  name = json['name'];
  cost = json['cost'];
  imgUrl = json['img_url'];
  createdAt = json['created_at'];
//   print(DateTime.parse(createdAt.toString()));
// DateTime tempDate = DateFormat("yyyy-MM-dd hh:mm:ss").parse(createdAt.toString());
// print(tempDate);
if (imgUrl == null) {
 imgUrl = "";
} else {
  imgUrl == json['img_url'];
}



  userId = json['user_id'];
  }
}
