import 'package:flutter/material.dart';
//import '../common/styles/spacing_styles.dart';
import 'package:fl_chart/fl_chart.dart';
//import '../common/sizes.dart';
//import 'package:status_alert/status_alert.dart';
//import '../model/transactions.dart';
//import '../services/api.dart';

class SpendingPage extends StatefulWidget {
  @override
  State<SpendingPage> createState() => _SpendingPageState();
}

Widget bottomTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  Widget text;
  switch (value.toInt()) {
    case 2:
      text = const Text('MAR', style: style);

    case 5:
      text = const Text('JUN', style: style);

    case 8:
      text = const Text('SEP', style: style);

    case 11:
      text = const Text('DEC', style: style);

    default:
      text = const Text('', style: style);
  }

  return SideTitleWidget(
    axisSide: meta.axisSide,
    child: text,
  );
}

Widget leftTitleWidgets(double value, TitleMeta meta) {
  const style = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 15,
  );
  String text;
  switch (value.toInt()) {
    case 1:
      text = '10K';

    case 3:
      text = '30k';

    case 5:
      text = '50k';

    default:
      return Container();
  }

  return Text(text, style: style, textAlign: TextAlign.left);
}

class _SpendingPageState extends State<SpendingPage> {
/*
String _user = 'nobody';
_testlogin(){
   setState(() {
      _user='justin';
    });
}*/

//Future<List<Transactions>> postsFuture = UserServices().getAllUserTransactions();

// https://stackoverflow.com/questions/65389839/how-to-implement-api-data-in-a-line-chart
// https://arijit-autility.medium.com/creating-line-charts-in-flutter-by-fetching-data-from-graphql-98bb50eb20bb

/*
Future getTransactionData() async {
  var testObj = await UserServices().getAllUserTransactions();

  
 // var results = await Future.wait(testObj);
 print('here');
  print(testObj);
  return testObj;
}*/

  //var testObj = getTransactionData();

  //print(testObj);

/*
createList(testObj){
  List<dynamic> testObj = [
{
  "cost": 13.99, 
  "created_at": "2024-09-30 10:34:00+01",
},
{
  "cost": 113.99, 
  "created_at": "2024-08-30 10:34:00+01",
},
{
  "cost": 13.99, 
  "created_at": "2024-09-30 10:34:00+01",
},
{
  "cost": 113.99, 
  "created_at": "2024-08-30 10:34:00+01",
},
  ];
//print(testObj);
    List<FlSpot> newSpots = [];
    for (int i = 0; i <= testObj.length-1; i++) {
      newSpots.add(FlSpot((i * 1.00), testObj[i]['cost'])); 
    }
    return newSpots;
}

createData(testObj){
  //var testObj = UserServices().getAllUserTransactions();


  



  //var results = Future.([testObj]);
  //var results = Future.wait([testObj]);
  print('createData');
  print(testObj);


  /*
  var testObj = Future.delayed(Duration(seconds: 10), () =>getTransactionData());
  var results = await Future.wait(testObj);
  var newSpots = Future.delayed(Duration(seconds: 5), () =>createList(results));
  print(newSpots);*/
  if (testObj.length >= 0){
  var newSpots = createList('');
  return newSpots;
  }
}

*/

//logic().then((list) => removeOne(list));

  createNewSpots() {
    // List<FlSpot> newSpots = [];
    //Future<List<Transactions>> postsFuture = UserServices().getAllUserTransactions();
//Future newSpotss = UserServices().getAllUserTransactions().then((testObj) => {
    // print(testObj),
    // List<FlSpot> newSpots = [];
    //  for (int i = 0; i <= testObj.length-1; i++) {
    //    newSpots.add(FlSpot((i * 1.00), testObj[i]['cost']))
    //   }
//});
// }).then((data) => {
//   print('second then'),
//   print(data)
    // List<FlSpot> newSpots = [];
    // for (int i = 0; i <= testObj.length-1; i++) {
    //   newSpots.add(FlSpot((i * 1.00), testObj[i]['cost']));
    // }
//});
//Future.delayed(Duration(seconds: 10), () =>print('postsFuture'));
//Future.delayed(Duration(seconds: 10), () =>print(postsFuture));

//print('before list');

    List<dynamic> testObj = [
      {
        "cost": 13.99,
        "created_at": "2024-09-30 10:34:00+01",
      },
      {
        "cost": 113.99,
        "created_at": "2024-08-30 10:34:00+01",
      },
      {
        "cost": 13.99,
        "created_at": "2024-09-30 10:34:00+01",
      },
      {
        "cost": 113.99,
        "created_at": "2024-08-30 10:34:00+01",
      },
    ];

//for (var keys in testObj) {

// final newSpots = [
//                         // (Month, value)
//                         (0,0),
//                         (1,1),
//                         (2,3),
//                         (3,1),
//                         // FlSpot(4,6),
//                         // FlSpot(5,1),
//                         // FlSpot(6,0),
//                         // FlSpot(7,1),
//                         // FlSpot(8,3),
//                         // FlSpot(9,1),
//                   ];

//List<FlSpot> testObj {

    List<FlSpot> newSpots = [];
    for (int i = 0; i <= testObj.length - 1; i++) {
      newSpots.add(FlSpot((i * 1.00), testObj[i]['cost']));
    }
    return newSpots;
  }

  @override
  Widget build(BuildContext context) {
/*
     return  ListView.builder(
      itemBuilder: (context, index){
        return createNewSpots();
      }
     );*/

    // var theme = Theme.of(context);
    // var appState = context.watch<MyAppState>();

    // String? validateName(value) {
    //   if (value!.isEmpty) {
    //     return 'Enter a valid name';
    //   } else {
    //     return null;
    //   }
    // }

    //  String? validateCost(value) {
    //   if (value!.isEmpty) {
    //     return 'Please enter a purchase cost';
    //   } else {
    //     return null;
    //   }
    // }

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.orange,
            title: Center(
                child: Text('Spending', style: TextStyle(color: Colors.white))),
          )),
      /* floatingActionButton: FloatingActionButton(
        onPressed: _testlogin,
        child: Icon(Icons.add),
      ),*/

      body: Column(
        children: [
          Center(
            child: AspectRatio(
                aspectRatio: 2.0,
                // child: Container(
                //   color:Colors.green,
                // ),
                child: SizedBox(
                  /*         width: 580,
                                                          height: 270,*/
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: LineChart(
                      LineChartData(
                          /* minX: 0,
                        maxX: 12,
                        minY: 0,
                        maxY: 6,*/

                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1,
                                getTitlesWidget: bottomTitleWidgets,
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 1,
                                getTitlesWidget: leftTitleWidgets,
                                reservedSize: 42,
                              ),
                            ),
                          ),
                          //       titlesData: FlTitlesData(
                          //   show: true,
                          //   bottomTitles: SideTitles(
                          //     showTitles: true,
                          //     getTitles: (value){
                          //       switch (value.toInt()){
                          //         case 2:
                          //         return 'Mar';
                          //       },
                          //       return '';
                          //     },

                          //     margin: 8,
                          //   ),
                          // ),
                          //       titlesData: FlTitlesData(
                          //   bottomTitles: AxisTitles(
                          //     sideTitles: SideTitles(
                          //       showTitles: true,
                          //       getTitlesWidget: (value, meta) {
                          //         switch (value.toInt()) {
                          //           case 1:
                          //             return Text('Jan');
                          //           case 2:
                          //             return Text('Feb');
                          //           case 3:
                          //             return Text('Mar');
                          //           case 4:
                          //             return Text('Apr');
                          //           case 5:
                          //             return Text('May');
                          //           case 6:
                          //             return Text('Jun');
                          //           case 7:
                          //             return Text('Jul');
                          //           case 8:
                          //             return Text('Aug');
                          //           case 9:
                          //             return Text('Sep');
                          //           case 10:
                          //             return Text('Oct');
                          //           case 11:
                          //             return Text('Nov');
                          //           case 12:
                          //             return Text('Dec');
                          //           default:
                          //             return Text('');
                          //         }

                          //       },
                          //     ),
                          //   ),
                          //   leftTitles: AxisTitles(
                          //     sideTitles: SideTitles(
                          //       showTitles: true,
                          //       getTitlesWidget: (value, meta) {
                          //         return Text(value.toString());
                          //       },
                          //     ),
                          //   ),
                          // ),
                          // ),

                          lineBarsData: [
                            LineChartBarData(
                                spots: createNewSpots(),
                                // spots: createNewSpots()
                                //         .map(
                                //           (e) => FlSpot(
                                //             e['x'],
                                //             (e['y'] as DateTime)
                                //               .microsecondsSinceEpoch
                                //               .toDouble(),
                                //           ),
                                //         ),

                                color: Colors.orange[400], // this or gradient
                                // gradient: const LinearGradient(
                                //   colors:[
                                //     Colors.orange,
                                //     Colors.red,
                                //     Colors.blue,
                                //   ],

                                // ),
                                barWidth: 4,
                                isCurved: true,
                                //curveSmoothness: 0.1,
                                preventCurveOverShooting: true,
                                isStrokeCapRound: true,
                                isStrokeJoinRound: true,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: Colors.orange.withOpacity(0.3),
                                ),
                                aboveBarData: BarAreaData(
                                  show: true,
                                  color: Colors.orange.withOpacity(0.2),
                                ))
                          ]),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
