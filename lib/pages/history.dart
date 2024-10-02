import 'package:flutter/material.dart';
import '../model/transactions.dart';
import '../services/api.dart';

class HistoryScreen extends StatefulWidget {
HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
 /*List<Map> _books = [
    {
      'id': 100,
      'title': 'Flutter Basics',
      'author': 'David John'
    },
    {
      'id': 102,
      'title': 'Git and GitHub',
      'author': 'Merlin Nick'
    },
    {
      'id': 101,
      'title': 'Flutter Basics',
      'author': 'David John'
    },
     {
      'id': 100,
      'title': 'Flutter Basics',
      'author': 'David John'
    },
    {
      'id': 102,
      'title': 'Git and GitHub',
      'author': 'Merlin Nick'
    },
    {
      'id': 101,
      'title': 'Flutter Basics',
      'author': 'David John'
    },
     {
      'id': 100,
      'title': 'Flutter Basics',
      'author': 'David John'
    },
    {
      'id': 102,
      'title': 'Git and GitHub',
      'author': 'Merlin Nick'
    },
    {
      'id': 101,
      'title': 'Flutter Basics',
      'author': 'David John'
    },
     {
      'id': 100,
      'title': 'Flutter Basics',
      'author': 'David John'
    },
    {
      'id': 102,
      'title': 'Git and GitHub',
      'author': 'Merlin Nick'
    },
    {
      'id': 101,
      'title': 'Flutter Basics',
      'author': 'David John'
    },
  ];*/

 List results = [];
  DataRow _getDataRow(index, data) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(data.name)),//add name of your columns here
        DataCell(Text(data.cost.toString())),
      ],
    );
  }




  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
            child: Text("Transaction History", style: TextStyle(color: Colors.white))),
            actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),

            onPressed:(){
              setState(() {
               // isReadOnly = !isReadOnly;
            });
}
          ),
        ],
      ),
        body: FutureBuilder(
          future: UserServices().getAllUserTransactions(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var results = snapshot.data as List<Transactions>;
              if (results.length != 0) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DataTable(
                    headingRowColor: WidgetStateColor.resolveWith(
                      (states) => Colors.blue,
                    ),
                    columnSpacing: 30,
                    columns: [
                      DataColumn(label: Text('Campaigns')),
                      DataColumn(label: Text('Leads')),
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
                    child: Text('No Data Found...'),
                  ),
                ],
              );
            }
          },
        ),
      );
 
  }

}

/*
DataTable _createDataTable() {
    return DataTable(columns: _createColumns(), rows: _createRows());
  }
List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text('ID')),
      DataColumn(label: Text('Book')),
      DataColumn(label: Text('Author')),
      DataColumn(label: Text('Category'))
    ];
  }
List<DataRow> _createRows() {
    return _books
        .map((book) => DataRow(cells: [
              DataCell(Text('#' + book['id'].toString())),
              DataCell(Text(book['title'])),
              DataCell(Text(book['author'])),
              DataCell(FlutterLogo())
            ]))
        .toList();
  }
}*/
