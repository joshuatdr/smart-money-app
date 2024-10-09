import 'package:flutter/material.dart';
import 'package:smart_money_app/model/transactions.dart';
import 'package:smart_money_app/services/api.dart';
import 'package:provider/provider.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:http/http.dart' as http;
import 'package:smart_money_app/pages/spending/edit_transaction.dart';
import 'package:smart_money_app/providers/user_provider.dart';
import 'dart:math' as math;

Future<void> deleteTransaction(int transactionId, int userId) async {
  final response = await http.delete(Uri.parse(
      "https://smart-money-backend.onrender.com/api/user/$userId/transactions/$transactionId"));
  if (response.statusCode == 204) {
    // If the server returns a 204 response, user is successfully deleted
  }
}

Future promptTransaction(context, data, userId) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        scrollable: true,
        title: Center(
          child: Text(
            'Delete Transaction',
            style: TextStyle(
                color: Colors.lightBlue.shade600,
                fontWeight: FontWeight.w800,
                fontSize: 20),
          ),
        ),
        content: SizedBox(
          // width: 100,
          // height: 200,
          child: Column(
            children: [
              Text(
                data.name,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
              ),
              // Text(TextStyle(data.name)),
              // Text(data.cost),
              // Text(data.created_at),

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text('Do you want to delete this transaction?'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            TextButton(
              child: const Text(
                'Cancel',
                textAlign: TextAlign.left,
              ),
              onPressed: () {
                Navigator.of(context).pop(false); // closes prompt
              },
            ),
            TextButton(
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              onPressed: () async {
                await deleteTransaction(data.transactionId, userId)
                    .then((value) => {
                          if (context.mounted) {Navigator.of(context).pop()}
                        });
              },
            ),
          ]),
        ],
      );
    },
  );
}

class HistoryScreen extends StatefulWidget {
  HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _key = GlobalKey<ExpandableFabState>();
  @override
  Widget build(BuildContext context) {
    AsyncSnapshot.waiting();
    var userId = context.watch<UserProvider>().userID;

    DataRow getDataRow(index, data) {
      return DataRow(
        cells: <DataCell>[
          (DataCell(Text(
            data.name,
            maxLines: 6,
            softWrap: true,
          ))),
          DataCell(
            Text(
              '£${data.cost.toStringAsFixed(2)}',
              maxLines: 2,
              softWrap: false,
            ),
          ),
          DataCell(Text(
            data.createdAt,
            maxLines: 2,
            softWrap: false,
          )),
          DataCell(
            Icon(Icons.edit, color: Colors.lightBlue[500]),
            onTap: () async {
              await Navigator.of(context)
                  .push(
                MaterialPageRoute(
                    builder: (context) => EditTransaction(
                          name: data.name,
                          cost: data.cost,
                          imgUrl: data.imgUrl,
                          createdAt: data.createdAt,
                          transactionId: data.transactionId,
                          desc: data.desc,
                        )),
              )
                  .then((value) {
                // print(value);
                setState(() {});
              });
            },
          ),
          DataCell(
            Icon(Icons.delete_forever, color: Colors.lightBlue[500]),
            onTap: () async {
              await promptTransaction(context, data, userId)
                  .then((value) => {setState(() {})});
            },
          ),
        ],
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade900,
        title: Text("Spending History", style: TextStyle(color: Colors.white)),
        // actions: <Widget>[
        //   IconButton(
        //       icon: const Icon(Icons.edit),
        //       onPressed: () {
        //         setState(() {
        //           // isReadOnly = !isReadOnly;
        //         });
        //       }),
        // ],
      ),
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: _renderFloatingActionButton(context),
      body: FutureBuilder(
        future: UserServices().getAllUserTransactions(userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var results = snapshot.data as List<Transactions>;
            if (results.isNotEmpty) {
              return SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        width:
                            math.min(MediaQuery.of(context).size.width, 1000),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlue.shade500),
                          color: Colors.white,
                        ),
                        child: DataTable(
                          dataRowMaxHeight:
                              double.infinity, // Code to be changed.
                          dataRowMinHeight: 60, // Set the min required height.
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
                              'Date',
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
                      SizedBox(
                        //padding @bottom of list to make space for floating button
                        height: 80,
                      )
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
                width: 30,
                height: 30,
              ),
            );
          }
        },
      ),
    );
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
            Text('Add Transaction'),
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
            Text('View Data'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: Colors.blue.shade600,
              heroTag: null,
              onPressed: () {
                Navigator.pushNamed(context, '/graphview').then(
                  (value) {
                    setState(() {});
                  },
                );
                final state = _key.currentState;
                if (state != null) {
                  state.toggle();
                }
              },
              child: Icon(Icons.insights, color: Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            Text('Search'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: Colors.blue.shade600,
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.search, color: Colors.white),
            ),
          ],
        ),
        Row(
          children: [
            Text('Sort'),
            SizedBox(width: 20),
            FloatingActionButton.small(
              backgroundColor: Colors.blue.shade600,
              heroTag: null,
              onPressed: null,
              child: Icon(Icons.sort, color: Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
