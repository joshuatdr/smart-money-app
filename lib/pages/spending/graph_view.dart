import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
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
  final _key = GlobalKey<ExpandableFabState>();

  List<double> weeklySummary = [0, 0, 0, 0, 0, 0, 0];

  @override
  Widget build(BuildContext context) {
    final userID = context.watch<UserProvider>().userID;

    return Scaffold(
      backgroundColor: Colors.white,
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
            Text('Last 7 Days'),
            SizedBox(height: 20),
            _renderBarGraph(userID),
          ],
        ),
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _renderFloatingActionButton(context),
    );
  }

  FutureBuilder<Object?> _renderBarGraph(int userID) {
    return FutureBuilder(
        future: UserServices().getAllUserTransactions(userID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final results = snapshot.data as List<Transactions>;
            if (results.isNotEmpty) {
              final now = new DateTime.now(); //the date right now
              final now_1w =
                  now.subtract(Duration(days: 7)); //the date one week ago

              final filterResults = results
                  .where((transaction) =>
                      now_1w.isBefore(transaction.timestampDate))
                  .toList();

              final weeklyData = filterResults.map((transaction) => [
                    transaction.cost,
                    DateFormat('EEEE').format(transaction.timestampDate)
                  ]);

              for (final [cost as double, day as String] in weeklyData) {
                switch (day) {
                  case "Sunday":
                    weeklySummary[0] += cost;
                  case "Monday":
                    weeklySummary[1] += cost;
                  case "Tuesday":
                    weeklySummary[2] += cost;
                  case "Wednesday":
                    weeklySummary[3] += cost;
                  case "Thursday":
                    weeklySummary[4] += cost;
                  case "Friday":
                    weeklySummary[5] += cost;
                  case "Saturday":
                    weeklySummary[6] += cost;
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

  ExpandableFab _renderFloatingActionButton(BuildContext context) {
    return ExpandableFab(
      key: _key,
      type: ExpandableFabType.up,
      childrenAnimation: ExpandableFabAnimation.none,
      distance: 70,
      childrenOffset: Offset(8, 16),
      openButtonBuilder: DefaultFloatingActionButtonBuilder(
        backgroundColor: Colors.blue.shade600,
        child: const Icon(Icons.menu, color: Colors.white),
      ),
      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
        backgroundColor: Colors.blue.shade800,
        child: const Icon(Icons.close, color: Colors.white),
      ),
      overlayStyle: ExpandableFabOverlayStyle(
        color: Colors.white.withOpacity(0.6),
      ),
      children: [
        Row(
          children: [
            Text('Add Purchase'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: Colors.blue.shade600,
              heroTag: null,
              onPressed: () {
                Navigator.pushNamed(context, '/addtransaction').then(
                  (value) {
                    setState(() {});
                  },
                );
                final state = _key.currentState;
                if (state != null) {
                  state.toggle();
                }
              },
              child: Icon(Icons.add, color: Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            Text('Spending History'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: Colors.blue.shade600,
              heroTag: null,
              onPressed: () {
                Navigator.pop(context);
                final state = _key.currentState;
                if (state != null) {
                  state.toggle();
                }
              },
              child: Icon(Icons.receipt_long, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
