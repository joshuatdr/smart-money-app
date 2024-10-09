import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:smart_money_app/providers/user_provider.dart';
import 'package:smart_money_app/services/api.dart';
import 'package:smart_money_app/model/expenses.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'dart:math' as math;

class BudgetPage extends StatefulWidget {
  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  Future<void> deleteExpense(int expenseId, int userId) async {
    final response = await http.delete(Uri.parse(
        "https://smart-money-backend.onrender.com/api/user/$userId/expenses/$expenseId"));
    if (response.statusCode == 204) {
      // If the server returns a 204 response, user is successfully deleted
    }
  }

  final colorList = <Color>[
    Color(0xFF2E355D),
    Color(0xFF9D4B3C),
    Color(0xFFC1A38D),
    Color(0xFFBD7E2F),
    Color(0xFF51624C),
    Color(0xFFBA641F),
    Color(0xFF866C57),
    Color(0xFFD9CFBE),
  ];

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
                Text(toBeginningOfSentenceCase(data.name)),
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

  @override
  Widget build(BuildContext context) {
    AsyncSnapshot.waiting();
    int userID = context.watch<UserProvider>().userID;
    DataRow getDataRow(index, data) {
      return DataRow(
        cells: <DataCell>[
          DataCell(Text(
            toBeginningOfSentenceCase(data.name),
            maxLines: 6,
            softWrap: true,
          )),
          DataCell(
            Text(
              '£${data.cost.toStringAsFixed(2)}',
              maxLines: 2,
              softWrap: false,
            ),
          ),
          DataCell(
            Icon(Icons.edit, color: Colors.lightBlue[500]),
          ),
          DataCell(
            Icon(Icons.delete_forever, color: Colors.lightBlue[500]),
            onTap: () async {
              await promptExpense(context, data, userID)
                  .then((value) => {setState(() {})});
            },
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      // backgroundColor: Colors.purple,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade900,
        title: Center(
            child: Text("Budget", style: TextStyle(color: Colors.white))),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade600,
        heroTag: null,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, '/editbudget').then(
            (value) {
              setState(() {});
            },
          );
        },
      ),
      body: FutureBuilder(
          future: UserServices.getAllUserExpenses(userID),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var results = snapshot.data as List<Expenses>;

              Map<String, double> dataMap = {};
              for (var expense in results) {
                dataMap[toBeginningOfSentenceCase(expense.name) ?? 'Unknown'] =
                    expense.cost?.toDouble() ?? 0;
              }
              if (results.isNotEmpty) {
                return SingleChildScrollView(
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          width:
                              math.min(MediaQuery.of(context).size.width, 1000),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border.all(color: Colors.lightBlue.shade500),
                          ),
                          child: DataTable(
                            dataRowMaxHeight:
                                double.infinity, // Code to be changed.
                            dataRowMinHeight:
                                60, // Set the min required height.
                            dividerThickness: 1,
                            headingRowColor: WidgetStateColor.resolveWith(
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
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15, bottom: 15),
                                  child: SizedBox(
                                    width: 780,
                                    child: Column(
                                      children: [
                                        Column(
                                          children: [
                                            PieChart(
                                              dataMap: dataMap,
                                              animationDuration: const Duration(
                                                  milliseconds: 3500),
                                              chartLegendSpacing: 1,
                                              chartRadius:
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height /
                                                      2,
                                              colorList: colorList,
                                              initialAngleInDegree: 90,
                                              chartType: ChartType.disc,
                                              legendOptions:
                                                  const LegendOptions(
                                                showLegendsInRow: false,
                                                legendPosition:
                                                    LegendPosition.right,
                                                showLegends: true,
                                                legendTextStyle: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              chartValuesOptions:
                                                  const ChartValuesOptions(
                                                showChartValueBackground: true,
                                                showChartValues: true,
                                                showChartValuesInPercentage:
                                                    true,
                                                showChartValuesOutside: false,
                                                decimalPlaces: 1,
                                              ),
                                            ),
                                          ],
                                        )

                                        //
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return Center(
                  child: Image.asset('logo.png',
                      width: 200,
                      color: Colors.lightBlue.shade900.withOpacity(0.2)),
                );
              }
            } else {
              return Center(
                child: SizedBox(
                  // ignore: sort_child_properties_last
                  child: CircularProgressIndicator(),
                  width: 300,
                  height: 300,
                ),
              );
            }
          }),
    );
  }
}
