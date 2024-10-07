import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/add_transaction.dart';
import '../model/transactions.dart';
import '../services/api.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:http/http.dart' as http;

Future<void> deleteTransaction(int transactionId, int userId) async {
  final response = await http.delete(Uri.parse(
      "https://smart-money-backend.onrender.com/api/user/$userId/transactions/$transactionId"));
  if (response.statusCode == 204) {
    // If the server returns a 204 response, user is successfully deleted
  }

  print('deleteTransaction');
}

Future promptTransaction(context, data, userId) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(child: const Text('Delete Transaction')),
        content: SizedBox(
          width: 100,
          height: 200,
          child: Column(
            children: [
              Text(data.name),
              // Text(data.cost),
              // Text(data.created_at),

              const Text('Do you want to delete this transaction?'),
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
              await deleteTransaction(data.transactionId, userId)
                  .then((value) => {
                        if (context.mounted) {Navigator.of(context).pop()}
                      });
            },
          ),
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
  @override
  Widget build(BuildContext context) {
    AsyncSnapshot.waiting();
    var userId = context.watch<UserProvider>().userID;

    DataRow getDataRow(index, data) {
      return DataRow(
        cells: <DataCell>[
          DataCell(Text(data.name)), //add name of your columns here
          DataCell(Text('£${data.cost}')),
          DataCell(Text(data.createdAt)),
          DataCell(
            Icon(Icons.image_outlined, color: Colors.lightBlue[500]),
          ),
          DataCell(
            Icon(Icons.edit, color: Colors.lightBlue[500]),
            // onTap: () async {
            //   await promptTransaction(context, data, userId)
            //       .then((value) => {setState(() {})});
            // },
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade900,
        title:
            Text("Transaction History", style: TextStyle(color: Colors.white)),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlue.shade600,
        heroTag: null,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionScreen()),
          ).then(
            (value) {
              setState(() {});
            },
          );
        },
      ),
      body: FutureBuilder(
        future: UserServices().getAllUserTransactions(userId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var results = snapshot.data as List<Transactions>;
            if (results.isNotEmpty) {
              return Center(
                child: Column(
                  children: [
                    SingleChildScrollView(
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.lightBlue.shade500),
                        ),
                        child: DataTable(
                          dataRowMaxHeight:
                              double.infinity, // Code to be changed.
                          dataRowMinHeight: 80, // Set the min required height.
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
                              'Image',
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
                child: Text("No transactions yet!"),
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
}
