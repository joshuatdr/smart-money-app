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

/*
{
	"goals": [
		{
			"goal_id": 1,
			"name": "Japan Trip",
			"cost": 1700,
			"img_url": "https://lp-cms-production.imgix.net/2023-02/GettyImages-1071391480.jpeg",
			"created_at": "2024-10-01T14:38:01.265Z",
			"description": "A 7 day trip to explore Tokyo's futuristic skyline, then escape to Kyoto's peaceful temples and gardens.",
			"user_id": 1
		},
		{
			"goal_id": 2,
			"name": "New Fridge",
			"cost": 599,
			"img_url": "https://media.currys.biz/i/currysprod/Should-I-Buy-A-Smart-Fridge-Header",
			"created_at": "2024-09-30T20:54:48.038Z",
			"description": "One of those with the touchscreen that nobody ever uses.",
			"user_id": 1
		},
		{
			"goal_id": 3,
			"name": "Perfume for Mum's Bday",
			"cost": 145,
			"img_url": "https://media.theperfumeshop.com/medias/sys_master/prd-images/h29/hcc/9226375692318/prd-front-1002906_420x420/chanel-coco-mademoiselle-unknown-for-her-420x420.jpg",
			"created_at": "2024-09-30T12:22:12.592Z",
			"description": "Chanel Coco Mademoiselle.",
			"user_id": 1
		}
	]
}*/