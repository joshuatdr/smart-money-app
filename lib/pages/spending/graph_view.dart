import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:smart_money_app/pages/spending/bar_graph/bar_graph.dart';
import 'package:smart_money_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:smart_money_app/services/api.dart';
import 'package:smart_money_app/model/transactions.dart';

class GraphView extends StatefulWidget {
  const GraphView({super.key});

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  final _key = GlobalKey<ExpandableFabState>();

  List<double> weeklySummary = [
    4.40,
    2.50,
    42.42,
    10.50,
    100.20,
    88.99,
    90.10,
  ];

  @override
  Widget build(BuildContext context) {
    final userID = context.watch<UserProvider>().userID;

    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade900,
        title: Text("Graph View", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: _renderBarGraph(userID),
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
            var results = snapshot.data as List<Transactions>;
            if (results.isNotEmpty) {
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
