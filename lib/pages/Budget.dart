import 'package:flutter/material.dart';
//import 'package:smart_money_app/pages/dashboard.dart';
import 'package:smart_money_app/pages/editBudget.dart';
//import 'package:smart_money_app/pages/edit_profile.dart';
import '../../model/expenses.dart';
import '../../services/api.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class PieData {
  static List<Data> data = [
    Data(name: "Rent", percent: 30, color: const Color(0xff0293ee)),
    Data(
        name: "utilities",
        percent: 20,
        color: const Color.fromARGB(255, 235, 126, 3)),
    Data(
        name: "travel",
        percent: 15,
        color: const Color.fromARGB(255, 219, 62, 222)),
    Data(
        name: "food",
        percent: 20,
        color: const Color.fromARGB(255, 10, 52, 192)),
    Data(
        name: "subscription",
        percent: 8,
        color: const Color.fromARGB(255, 222, 22, 29)),
    Data(
        name: "charity",
        percent: 7,
        color: const Color.fromARGB(255, 192, 225, 44)),
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
  List<PieChartSectionData> getSections(int touchedIndex) => PieData.data
      .asMap()
      .map<int, PieChartSectionData>((index, data) {
        final isTouched = index == touchedIndex;
        final double fontSize = isTouched ? 25 : 16;
        final double radius = isTouched ? 60 : 50;

        final value = PieChartSectionData(
            color: data.color,
            value: data.percent,
            title: "",
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

  Future<void> deleteExpense(int expenseId, int userId) async {
    final response = await http.delete(Uri.parse(
        "https://smart-money-backend.onrender.com/api/user/$userId/expenses/$expenseId"));
    if (response.statusCode == 204) {
      // If the server returns a 204 response, user is successfully deleted
    }

    print('delete expense');
  }

  Future promptExpense(context, data, userId) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text('Delete Expense')),
          content: SizedBox(
            width: 100,
            height: 200,
            child: Column(
              children: [
                Text(data.name),
                const Text('Do you want to delete this expense?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(false); // closes prompt
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                await deleteExpense(data.expenseId, userId).then((value) => {
                      if (context.mounted) {Navigator.of(context).pop()}
                    });
              },
            ),
          ],
        );
      },
    );
  }

  DataRow getDataRow(index, data) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(data.name)), //add name of your columns here
        DataCell(Text('£${data.cost}')),
        DataCell(
          Icon(Icons.image_outlined, color: Colors.lightBlue[500]),
        ),
        DataCell(
          Icon(Icons.delete_forever, color: Colors.lightBlue[500]),
          onTap: () async {
            await promptExpense(context, data, userId)
                .then((value) => {setState(() {})});
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.lightBlue.shade900,
          title: Center(
              child: Text("Budget", style: TextStyle(color: Colors.white))),
        ),
        body: SingleChildScrollView(
          child: Column(children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 1),
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: 169,
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
            ),
            Container(
              child: FutureBuilder(
                  future: UserServices().getAllUserExpenses(userId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      var results = snapshot.data as List<Expenses>;
                      if (results.isNotEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              SingleChildScrollView(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.lightBlue.shade500),
                                  ),
                                  child: DataTable(
                                    dataRowMaxHeight:
                                        double.infinity, // Code to be changed.
                                    dataRowMinHeight:
                                        80, // Set the min required height.
                                    dividerThickness: 1,
                                    headingRowColor:
                                        WidgetStateColor.resolveWith(
                                      (states) => Colors.lightBlue.shade800,
                                    ),
                                    columnSpacing: 30,
                                    columns: [
                                      DataColumn(
                                          label: Text(
                                        'Name',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Cost',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Edit',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      DataColumn(
                                          label: Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                    ],
                                    rows: List.generate(
                                      results.length,
                                      (index) => getDataRow(
                                        index,
                                        results[index],
                                      ),
                                    ),
                                    showBottomBorder: true,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return Center(
                          child: Text("No expenses yet!"),
                        );
                      }
                    } else {
                      return Center(
                        child: SizedBox(
                          // ignore: sort_child_properties_last
                          child: CircularProgressIndicator(),
                          width: 30,
                          height: 30,
                        ),
                      );
                    }
                  }),
            )
          ]),
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
