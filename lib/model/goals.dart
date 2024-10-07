class Goals {
  int? goalID;
  String? name;
  num? cost;
  String? imgURL;
  String? createdAt;
  String? description;

  Goals({
    this.goalID,
    this.name,
    this.cost,
    this.imgURL,
    this.createdAt,
  });

  Goals.fromJson(Map<String, dynamic> json) {
    goalID = json['goal_id'];
    name = json['name'];
    cost = json['cost'];
    imgURL = json['img_url'];
    createdAt = json['created_at'];
    imgURL == null ? "" : json['img_url'];
  }
}
