import 'dart:convert';

import 'package:data_table_2/data_table_2.dart';
import 'package:financemanager/Constants.dart';
import 'package:financemanager/Models/AccountModel.dart';
import 'package:financemanager/Models/LedgerModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Utils.dart';
import 'package:financemanager/widgets/LedgerDrawer.dart';
import 'package:financemanager/widgets/TextWidget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart'as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';


import 'package:rflutter_alert/rflutter_alert.dart';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LedgerState();
  }
}

class LedgerState extends State<LedgerScreen> {



  List<LedgerModel> results = [];
  late AccountModel accountModel;
  dynamic variabe;
  String accountid="";
  String todate="";
  String fromdate="";
  double containHeight=80.0;
  int previousbalance=0;
  int totalcredit=0;
  int totaldebit=0;
  int closingbaacne=0;

  @override
  void initState() {
    // TODO: implement initState

    EasyLoading.show(status: "Loading");

    setState(() {
      try {
        results.clear();

      } catch (e) {
        confirmationPopup(context, "An error Occurred.Try again later!");
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    variabe= ModalRoute.of(context)!.settings.arguments;

    print(variabe['from date']);



    setState(() {
      accountid=variabe['id'];
      fromdate=variabe['from date'];
      todate=variabe['to date'];

      results.clear();



      try{
        getLedgerList();


      }catch (e){
        confirmationPopup(context, "An error Occurred.Try again later!");

      }



    });

  }
  Future<void> getLedgerList() async {

    var url = Uri.parse('${Utils.baseUrl}getLedger');
    var response = await http.post(url,body: {"user_id":Utils.USER_ID.toString(),"account_id":accountid,"from_date":fromdate,"to_date":todate}).timeout(const Duration(seconds: 30),onTimeout: (){

      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);
      dynamic data = body['data'];





      setState(() {
        previousbalance= body['previousBalance'];
        totalcredit=body['totalCredit'];
        totaldebit=body['totalDebit'];
        closingbaacne=body['closingBalance'];


        data.forEach((item){
          print(item);
          results.add(LedgerModel.fromJson(item));

        });
      });




    } else {
      EasyLoading.dismiss();

      print(response.statusCode);


    }
  }
  @override
  Widget build(BuildContext context) {

    variabe= ModalRoute.of(context)!.settings.arguments;
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
      bottomSheet: GestureDetector(
          onVerticalDragEnd: (dragUpdateDetails) {
            setState(() {
              containHeight=250;
            });
          },
        onVerticalDragDown: (dragUpdateDetails){
          setState(() {
            containHeight=250;
          });

        },
        child: Container(
            height: containHeight,
            width: MediaQuery.of(context).size.width,
            color: MyColors.whiteColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextWidget(
                    input: "Previous$previousbalance",
                    fontsize: 15,
                    fontWeight: FontWeight.w500,
                    textcolor: MyColors.black),
                TextWidget(
                    input: "Debit$totaldebit",
                    fontsize: 15,
                    fontWeight: FontWeight.w500,
                    textcolor: MyColors.black),
                TextWidget(
                    input: "Credit$totalcredit",
                    fontsize: 15,
                    fontWeight: FontWeight.w500,
                    textcolor: MyColors.black),

             ],
            )
        ),
      ),
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
    return DataTable2(
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
              DataCell(Center(child: Text(book.id.toString(),style: TextStyle(color: MyColors.blue),))),
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
  confirmationPopup(BuildContext dialogContext, String? error) {
    var alertStyle = const AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(context: dialogContext, style: alertStyle, title: error, buttons: [
      DialogButton(
        onPressed: () {
          Navigator.pop(dialogContext);
        },
        color: MyColors.redColor,
        child: const Text(
          "Try Again",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      )
    ]).show();
  }




}
