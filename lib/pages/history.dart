//import 'dart:io';

import 'package:flutter/material.dart';
import '../model/transactions.dart';
import '../services/api.dart';

class HistoryScreen extends StatefulWidget {
HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
 List results = [];
  DataRow _getDataRow(index, data) {
    return DataRow(
      cells: <DataCell>[
        DataCell(Text(data.name)),//add name of your columns here
        DataCell(Text('£'+ data.cost.toString())),
        DataCell(Text(data.createdAt)),
        DataCell(Icon(Icons.picture_in_picture, color: Colors.red[500])),
      ],
    );
  }
/*
bool sort = true;
List<data>? = filterData; 

onsortColumn(int columnIndex, bool ascending){
  if (columnIndex == 0){
    if(ascending){
      filterData!.sort((a,b)=>a.name!.compareTo(b.name!));
    } else {
      filterData!.sort((a,b)=>b.name!.compareTo(a.name!));
    }
  }
}*/


  @override
  //filterData = myData

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
                    border: Border.all(color: Colors.orange),
                  ),
                  child: DataTable(
          dataRowMaxHeight: double.infinity,       // Code to be changed.
          dataRowMinHeight: 80,                    // Set the min required height.
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
