import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/spending/bar_graph/bar_graph.dart';
import 'package:smart_money_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:smart_money_app/services/api.dart';
import 'package:smart_money_app/model/transactions.dart';
import 'package:intl/intl.dart';

class GraphView extends StatefulWidget {
  const GraphView({super.key});

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  List<double> weeklySummary = [0, 0, 0, 0, 0, 0, 0];
  List<String> weekdays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday",
  ];

  @override
  Widget build(BuildContext context) {
    final userID = context.watch<UserProvider>().userID;

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade900,
        title: Text("Graph View", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: Colors.white,
                ),
                child: _renderBarGraph(userID),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue.shade600,
        heroTag: null,
        child: const Icon(Icons.receipt_long, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  FutureBuilder<Object?> _renderBarGraph(int userID) {
    return FutureBuilder(
        future: UserServices().getAllUserTransactions(userID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final results = snapshot.data as List<Transactions>;
            if (results.isNotEmpty) {
              final now = DateTime.now(); //the date right now
              final now_1w =
                  now.subtract(Duration(days: 6)); //the date one week ago

              final filterResults = results
                  .where((transaction) =>
                      now_1w.isBefore(transaction.timestampDate))
                  .toList();

              final weeklyData = filterResults.map((transaction) => [
                    transaction.cost,
                    DateFormat('EEEE').format(transaction.timestampDate)
                  ]);

              int? currentDayIndex;
              for (final [cost as double, day as String] in weeklyData) {
                currentDayIndex ??= weekdays.indexOf(day) - 1;

                switch (day) {
                  case "Monday":
                    if (weekdays.indexOf(day) <= currentDayIndex) {
                      weeklySummary[0] += cost;
                    }
                  case "Tuesday":
                    if (weekdays.indexOf(day) <= currentDayIndex) {
                      weeklySummary[1] += cost;
                    }
                  case "Wednesday":
                    if (weekdays.indexOf(day) <= currentDayIndex) {
                      weeklySummary[2] += cost;
                    }
                  case "Thursday":
                    if (weekdays.indexOf(day) <= currentDayIndex) {
                      weeklySummary[3] += cost;
                    }
                  case "Friday":
                    if (weekdays.indexOf(day) <= currentDayIndex) {
                      weeklySummary[4] += cost;
                    }
                  case "Saturday":
                    if (weekdays.indexOf(day) <= currentDayIndex) {
                      weeklySummary[5] += cost;
                    }
                  case "Sunday":
                    if (weekdays.indexOf(day) <= currentDayIndex) {
                      weeklySummary[6] += cost;
                    }
                }
              }

              return WeekdayBarChart(
                weeklySummary: weeklySummary,
              );
            } else {
              return Center(
                child: Text("No data to show!"),
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
        });
  }
}
