import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:smart_money_app/providers/user_provider.dart';
import 'package:smart_money_app/services/api.dart';
import 'package:smart_money_app/model/expenses.dart';
import 'package:pie_chart/pie_chart.dart';

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

  // Map<String, double> dataMap = {};
  // bool isDataFetched = false;
  // void fetchExpensesData() async {
  //   int userID = context.watch<UserProvider>().userID;
  //   try {
  //     List<Expenses> expenses = await UserServices.getAllUserExpenses(userID);
  //     Map<String, double> fetchedDataMap = {};
  //     for (var expense in expenses) {
  //       fetchedDataMap[expense.name ?? 'Unknown'] =
  //           expense.cost?.toDouble() ?? 0;
  //     }
  //     setState(() {
  //       dataMap = fetchedDataMap;
  //     });
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  final colorList = <Color>[
    Color(0xFF2E355D).withOpacity(1.0),
    Color(0xFF9D4B3C).withOpacity(1.0),
    Color(0xFFC1A38D),
    Color(0xFFBD7E2F).withOpacity(1.0),
    Color(0xFF51624C),
    Color(0xFFBA641F).withOpacity(1.0),
    Color(0xFF866C57).withOpacity(1.0),
    Color(0xFFD9CFBE).withOpacity(1.0),
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

  @override
  Widget build(BuildContext context) {
    AsyncSnapshot.waiting();
    int userID = context.watch<UserProvider>().userID;
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
              await promptExpense(context, data, userID)
                  .then((value) => {setState(() {})});
            },
          ),
        ],
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          backgroundColor: Colors.lightBlue.shade900,
          title: Center(
              child: Text("Monthly Expenses",
                  style: TextStyle(color: Colors.white))),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightBlue.shade600,
          heroTag: null,
          child: const Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, '/editbudget').then(
              (value) {
                setState(() {});
              },
            );
          },
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            FutureBuilder(
                future: UserServices.getAllUserExpenses(userID),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    var results = snapshot.data as List<Expenses>;
                    if (results.isNotEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.lightBlue.shade500),
                                  ),
                                  child: DataTable(
                                    dataRowMaxHeight:
                                        double.infinity, // Code to be changed.
                                    dataRowMinHeight:
                                        60, // Set the min required height.
                                    dividerThickness: 1,
                                    headingRowColor:
                                        WidgetStateColor.resolveWith(
                                      (states) => Colors.lightBlue.shade800,
                                    ),
                                    columnSpacing: 50,
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
                        width: 300,
                        height: 300,
                      ),
                    );
                  }
                }),
            Container(
              height: 1500,
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
                            height: MediaQuery.of(context).size.height / 1.89,
                            width: 780,
                            child: Column(
                              children: [
                                FutureBuilder(
                                  future:
                                      UserServices.getAllUserExpenses(userID),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      var result =
                                          snapshot.data as List<Expenses>;

                                      Map<String, double> dataMap = {};
                                      for (var expense in result) {
                                        dataMap[expense.name ?? 'Unknown'] =
                                            expense.cost?.toDouble() ?? 0;
                                      }
                                      return dataMap.isNotEmpty
                                          ? Column(
                                              children: [
                                                PieChart(
                                                  dataMap: dataMap,
                                                  animationDuration:
                                                      const Duration(
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  chartValuesOptions:
                                                      const ChartValuesOptions(
                                                    showChartValueBackground:
                                                        true,
                                                    showChartValues: true,
                                                    showChartValuesInPercentage:
                                                        true,
                                                    showChartValuesOutside:
                                                        false,
                                                    decimalPlaces: 2,
                                                  ),
                                                ),
                                                // ),
                                              ],
                                            )
                                          : Container();
                                    } else {
                                      return CircularProgressIndicator();
                                    }

                                    //
                                  },
                                ),
                              ],
                            ),
                          ),
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
                ],
              ),
            ),
          ]),
        ));
  }
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
