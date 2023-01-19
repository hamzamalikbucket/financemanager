import 'package:data_table_2/data_table_2.dart';
import 'package:financemanager/Constants.dart';
import 'package:financemanager/Models/LedgerModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/widgets/LedgerDrawer.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:financemanager/widgets/ToolbarImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';

import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LedgerState();
  }
}

class LedgerState extends State<LedgerScreen> {

  List<LedgerModel> results = [
    LedgerModel(
        "1", "22-09-2023", "description", "15", "800", "100", "100", "0"),
    LedgerModel(
        "2", "22-09-2023", "description", "15", "800", "100", "100", "0"),
   ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: LedgerDrawer(),
      appBar:AppBar(
        leading: Builder(
            builder: (context) {
              return IconButton(
                icon: Image.asset(
                  'assets/images/menuicon.png',
                  color: MyColors.whiteColor,
                  scale: 2,
                ),
                onPressed: (){ Scaffold.of(context).openDrawer();
                },

              );
            }
        ),

        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
                input: "Ledger",
                fontsize: 16,
                fontWeight: FontWeight.normal,
                textcolor: MyColors.whiteColor),
          ],
        ),


        iconTheme: IconThemeData(
          color: MyColors.whiteColor,
          //change your color here
        ),
      ),
      body: _createDataTable(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, Constants.AddAccountScreen);
        },
        tooltip: 'Add',
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }

  DataTable _createDataTable() {
    return

      DataTable2(
      columns: _createColumns(),
      rows: _createRows(),
      columnSpacing: 4,
      dataRowHeight: 80,
      horizontalMargin: 5,
      minWidth: 1000,


      border: TableBorder.all(color: MyColors.gray),
      showBottomBorder: true,

      headingTextStyle:
          const TextStyle(fontWeight: FontWeight.bold, color: Colors.white,),
      headingRowColor:
          MaterialStateProperty.resolveWith((states) => MyColors.blue),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      const DataColumn2(label: Center(child: Text('ID'))),
      const DataColumn2(label: Center(child: Text('Date'))),
      const DataColumn2(label: Center(child: Text('Description'))),
      const DataColumn2(label: Center(child: Text('Weight'))),
      const DataColumn2(label: Center(child: Text('Rate'))),
      const DataColumn2(label: Center(child: Text('Debit'))),
      const DataColumn2(label: Center(child: Text('Credit'))),
      const DataColumn2(label: Center(child: Text('Balance'))),
    ];
  }

  List<DataRow> _createRows() {
    return results
        .map((book) => DataRow(cells: [
              DataCell(Center(child: Text('#${book.id}'))),
              DataCell(Center(child: Text(book.date.toString()))),
              DataCell(Center(child: Text(book.description.toString()))),
              DataCell(Center(child: Text(book.weight.toString()))),
              DataCell(Center(child: Text(book.rate.toString()))),
              DataCell(Center(child: Text(book.debit.toString()))),
              DataCell(Center(child: Text(book.credit.toString()))),
              DataCell(Center(child: Text(book.balance.toString()))),
            ]))
        .toList();
  }
}
