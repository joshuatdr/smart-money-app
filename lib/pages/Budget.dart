import 'package:flutter/material.dart';
//import 'package:smart_money_app/pages/dashboard.dart';
import 'package:smart_money_app/pages/editBudget.dart';
//import 'package:smart_money_app/pages/edit_profile.dart';
//import '../../model/user.dart';
//import '../../services/api.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart';
//import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class PieData {
  static List<Data> data = [
    Data(name: "Blue", percent: 40, color: const Color(0xff0293ee)),
    Data(
        name: "Orange",
        percent: 30,
        color: const Color.fromARGB(255, 235, 126, 3)),
    Data(name: "Black", percent: 15, color: const Color.fromARGB(255, 0, 0, 0)),
    Data(
        name: "Green",
        percent: 15,
        color: const Color.fromARGB(255, 2, 238, 41)),
  ];
}

class Data {
  final String name;

  final double percent;

  final Color color;

  Data({required this.name, required this.percent, required this.color});
}

class BudgetPage extends StatefulWidget {
  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  late final userId = context.watch<UserProvider>().userID;
  late final email = context.watch<UserProvider>().email;
  late final fName = context.watch<UserProvider>().fName;
  late final createdAt = context.watch<UserProvider>().createdAt;
  late final income = context.watch<UserProvider>().income;
  late final savingsTarget = context.watch<UserProvider>().savingsTarget;

  List<PieChartSectionData> getSections(int touchedIndex) => PieData.data
      .asMap()
      .map<int, PieChartSectionData>((index, data) {
        final isTouched = index == touchedIndex;
        final double fontSize = isTouched ? 25 : 16;
        final double radius = isTouched ? 60 : 50;

        final value = PieChartSectionData(
            color: data.color,
            value: data.percent,
            title: "$userId",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
            ));

        return MapEntry(index, value);
      })
      .values
      .toList();

  int touchedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple,
        appBar: AppBar(
          //  leading: null,
          backgroundColor: Colors.orange,
          title: Center(
              child: Text("Budget", style: TextStyle(color: Colors.white))),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Card(
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 200,
                        child: Expanded(
                          child: PieChart(
                            PieChartData(
                              pieTouchData: PieTouchData(
                                touchCallback: (FlTouchEvent event,
                                    PieTouchResponse? pieTouchResponse) {
                                  setState(() {
                                    if (pieTouchResponse != null &&
                                        (event is FlLongPressEnd ||
                                            event is FlPanEndEvent)) {
                                      touchedIndex = -1;
                                    } else {
                                      touchedIndex = pieTouchResponse
                                              ?.touchedSection
                                              ?.touchedSectionIndex ??
                                          -1;
                                    }
                                  });
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              sectionsSpace: 0,
                              centerSpaceRadius: 40,
                              sections: getSections(touchedIndex),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: IndicatorsWidget(),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Card(
                    child: _SampleCard(
                  cardName:
                      'Your weekly savings are £... after unavoidable spending',
                )),
                Card(
                    child: _SampleCard(
                        cardName:
                            'It will take {amount of time} to reach your savings target!')),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditBudgetPage()),
                      );
                    },
                    child: Text("Edit Budget")),
              ],
            ),
          ),
        ));
  }
}

class IndicatorsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: PieData.data
            .map((data) => Container(
                  padding: EdgeInsets.symmetric(vertical: 2),
                  child: buildIndicator(color: data.color, text: data.name),
                ))
            .toList(),
      );
  Widget buildIndicator(
          {required Color color,
          required String text,
          bool isSquare = false,
          double size = 16,
          Color textColor = const Color(0xff505050)}) =>
      Row(
        children: <Widget>[
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
                shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
                color: color),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
          )
        ],
      );
}

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.cardName});
  final String cardName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 100,
      child: Center(child: Text(cardName)),
    );
  }
}
