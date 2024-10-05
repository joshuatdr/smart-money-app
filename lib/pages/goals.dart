import 'package:flutter/material.dart';
import 'package:smart_money_app/main.dart';
import 'package:smart_money_app/model/goals.dart';
import 'package:smart_money_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:smart_money_app/services/api.dart';

class GoalsPage extends StatefulWidget {
  @override
  State<GoalsPage> createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  List results = [];
  DataRow _getDataRow(index, data) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(data.name)), //add name of your columns here
        DataCell(Text('£${data.cost}')),
        DataCell(Text(data.createdAt)),
        DataCell(Icon(Icons.picture_in_picture, color: Colors.red[500])),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var appState = context.watch<MyAppState>();

// <<<<<<< context-userId
//     if (appState.goals.isEmpty) {
//       return Center(
//         child: Text('No Goals yet.'),
//       );
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(30),
//           child: Text('You have '
//               '${appState.favorites.length} favorites:'),
//         ),
//         Expanded(
//           // Make better use of wide windows with a grid.
//           child: GridView(
//             gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//               maxCrossAxisExtent: 400,
//               childAspectRatio: 400 / 80,
//             ),
//             children: [
//               for (var pair in appState.favorites)
//                 ListTile(
//                   leading: IconButton(
//                     icon: Icon(Icons.delete_outline, semanticLabel: 'Delete'),
//                     color: theme.colorScheme.primary,
//                     onPressed: () {
//                       appState.removeFavorite(pair);
//                     },
//                   ),
//                   title: Text(
//                     pair.asLowerCase,
//                     semanticsLabel: pair.asPascalCase,
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ],
// =======
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.orange,
        title:
            Text("Goals", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder(
        future: UserServices()
            .getAllUserGoals(context.watch<UserProvider>().userID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var results = snapshot.data as List<Goals>;
            if (results.isNotEmpty) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                ),
                child: DataTable(
                  dataRowMaxHeight: double.infinity, // Code to be changed.
                  dataRowMinHeight: 80, // Set the min required height.
                  dividerThickness: 1,
                  headingRowColor: WidgetStateColor.resolveWith(
                    (states) => const Color.fromARGB(255, 255, 201, 139),
                  ),
                  columnSpacing: 30,
                  columns: [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Cost')),
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Image')),
                  ],
                  rows: List.generate(
                    results.length,
                    (index) => _getDataRow(
                      index,
                      results[index],
                    ),
                  ),
                  showBottomBorder: true,
                ),
              );
            } else {
              return Row(
                children: const <Widget>[
                  SizedBox(
                    // ignore: sort_child_properties_last
                    child: CircularProgressIndicator(),
                    width: 30,
                    height: 30,
                  ),
                  Padding(
                    padding: EdgeInsets.all(40),
                    child: Text('No Data Found...'),
                  ),
                ],
              );
            }
          } else {
            return Row(
              children: const <Widget>[
                SizedBox(
                  // ignore: sort_child_properties_last
                  child: CircularProgressIndicator(),
                  width: 30,
                  height: 30,
                ),
                Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('Looking up your transactions...'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
