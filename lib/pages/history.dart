import 'package:flutter/material.dart';
import '../model/transactions.dart';
import '../services/api.dart';

class HistoryScreen extends StatefulWidget {
HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
 List<Map> _books = [
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
  ];
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
        body: ListView(
          children: [
            _createDataTable()
          ],
        ),
      );
  }
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
}
