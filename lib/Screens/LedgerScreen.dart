import 'dart:convert';
import 'dart:io';

import 'package:data_table_2/data_table_2.dart';
import 'package:financemanager/Constants.dart';
import 'package:financemanager/Models/AccountModel.dart';
import 'package:financemanager/Models/LedgerModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Screens/LedgerPdfView.dart';
import 'package:financemanager/Utils.dart';
import 'package:financemanager/widgets/LedgerDrawer.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart'as http;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';


import 'package:flutter/foundation.dart';

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
  String accountName="";
  double containHeight=255.0;
  int previousbalance=0;
  int totalcredit=0;
  int totaldebit=0;
  int closingbaacne=0;
  String savePath = "";
  TextEditingController FromController = TextEditingController();
  DateTime openingdate = DateTime.now();
  String OpeningDate="";
  TextEditingController ToController = TextEditingController();
  DateTime closingdate = DateTime.now();
  String ClosingDate="";
  String URL="";
  late String _localPath;
  late bool _permissionReady;
  late TargetPlatform? platform;
  var dio = Dio();

  @override
  void initState() {
    // TODO: implement initState

    EasyLoading.show(status: "Loading");
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }

    setState(() {
      DateFormat formatter = DateFormat('yyyy-MM-dd');
      OpeningDate = formatter.format(openingdate).toString();
      ClosingDate = formatter.format(closingdate).toString();
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
      accountName=variabe['account name'];
      print(accountid);

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
        results.clear();
        previousbalance= body['previousBalance'];
        totalcredit=body['totalCredit'];
        totaldebit=body['totalDebit'];
        closingbaacne=body['closingBalance'];
        URL=body['url'];



        data.forEach((item){
          print(item);
          results.add(LedgerModel.fromJson(item));

        });
      });




    } else {
      EasyLoading.dismiss();
      print(response.statusCode);
      return confirmationPopup(context, response.statusCode.toString());



    }
  }
  Future<void> getLedgerrefreshList() async {

    var url = Uri.parse('${Utils.baseUrl}getLedger');
    var response = await http.post(url,body: {"user_id":Utils.USER_ID.toString(),"account_id":accountid,"from_date":OpeningDate,"to_date":ClosingDate}).timeout(const Duration(seconds: 30),onTimeout: (){

      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);
      dynamic data = body['data'];





      setState(() {
        results.clear();
        previousbalance= body['previousBalance'];
        totalcredit=body['totalCredit'];
        totaldebit=body['totalDebit'];
        closingbaacne=body['closingBalance'];
        URL=body['url'];



        data.forEach((item){
          print(item);
          results.add(LedgerModel.fromJson(item));

        });
      });




    } else {
      EasyLoading.dismiss();
      print(response.statusCode);
      return confirmationPopup(context, response.statusCode.toString());



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
                input: accountName.toString(),
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left:12.0,right:12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(

                  input: "From",
                  fontsize: 16,
                  fontWeight: FontWeight.normal,
                  textcolor: MyColors.blackColor8,
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: FromController,
                    onTap: () async{
                      FocusScope.of(context).requestFocus(FocusNode());
                      await selectFromDate(context);
                      FromController.text = DateFormat('dd-MM-yyyy').format(openingdate);
                    },
                    onChanged: (String value){
                      OpeningDate=value;
                    },
                    style:TextStyle(color: MyColors.blue) ,

                    decoration:InputDecoration(
                      border: InputBorder.none,
                      hintText:"${openingdate.day}-${openingdate.month}-${openingdate.year}",
                      hintStyle: TextStyle(color: MyColors.blue),

                    ),
                  ),
                ),
                TextWidget(

                  input: "To",
                  fontsize: 16,
                  fontWeight: FontWeight.normal,
                  textcolor: MyColors.blackColor8,
                ),
                SizedBox(
                  width: 100,
                  child: TextField(
                    controller: ToController,
                    onTap: () async{
                      FocusScope.of(context).requestFocus(FocusNode());
                      await selectToDate(context);
                      ToController.text = DateFormat('dd-MM-yyyy').format(closingdate);
                    },
                    onChanged: (String value){
                      ClosingDate=value;
                    },
                    style:TextStyle(color: MyColors.blue) ,

                    decoration:InputDecoration(
                      border: InputBorder.none,
                      hintText:"${closingdate.day}-${closingdate.month}-${closingdate.year}",
                      hintStyle: TextStyle(color: MyColors.blue),

                    ),
                  ),
                ),
                IconButton(onPressed: (){
                  setState(() {
                    accountid=variabe['id'];
                    EasyLoading.show(status: "Loading");
                    getLedgerrefreshList();


                  });


                }, icon:Icon(Icons.refresh,color: MyColors.blue,))

              ],
            ),
          ),

          Expanded(child: _createDataTable()),
        ],
      ),
      bottomSheet: GestureDetector(
          onVerticalDragEnd: (dragUpdateDetails) {
            setState(() {
              containHeight=170;

            });
          },
       onVerticalDragUpdate: (dragUpdateDetails){
         setState(() {
           containHeight=100;

         });
       },
        child: Container(
            height: containHeight,
            width: MediaQuery.of(context).size.width,
            color: MyColors.whiteColor,

            child: Padding(
              padding: const EdgeInsets.only(left:5.0,right:5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      TextWidget(
                          input: accountName,
                          fontsize: 15,
                          fontWeight: FontWeight.w500,
                          textcolor: MyColors.black),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                          input: "Previous",
                          fontsize: 15,
                          fontWeight: FontWeight.w500,
                          textcolor: MyColors.black),
                      TextWidget(
                          input: previousbalance.toString(),
                          fontsize: 15,
                          fontWeight: FontWeight.w500,
                          textcolor: MyColors.black),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                          input: "Debit",
                          fontsize: 15,
                          fontWeight: FontWeight.w500,
                          textcolor: MyColors.black),
                      TextWidget(
                          input: totaldebit.toString(),
                          fontsize: 15,
                          fontWeight: FontWeight.w500,
                          textcolor: MyColors.black),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                          input: "Credit",
                          fontsize: 15,
                          fontWeight: FontWeight.w500,
                          textcolor: MyColors.black),
                      TextWidget(
                          input: totalcredit.toString(),
                          fontsize: 15,
                          fontWeight: FontWeight.w500,
                          textcolor: MyColors.black),
                    ],
                  ),
                  Divider(
                    thickness: 2.0,
                    color: MyColors.gray,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                          input: "Closing",
                          fontsize: 15,
                          fontWeight: FontWeight.w500,
                          textcolor: MyColors.black),
                      TextWidget(
                          input:closingbaacne .toString(),
                          fontsize: 15,
                          fontWeight: FontWeight.w500,
                          textcolor: MyColors.black),
                    ],
                  ),

               ],
              ),
            )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: ()async {

          _permissionReady = await _checkPermission();
          print(URL);
          if (_permissionReady) {


            await _prepareSaveDir();
            print("Downloading");
            try {
              String fileName = URL.substring(URL.lastIndexOf("/") + 1);
              await Dio().download(URL,
                  _localPath + "/" + fileName);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'successfully saved to internal storage'+_localPath,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
              print("Download Completed.");
            } catch (e) {
              print("Download Failed.\n\n" + e.toString());
            }
          }
          },
        tooltip: 'Add',
        child: const Icon(Icons.picture_as_pdf),
      ),


    );
  }

  ScrollableTableView _createDataTable() {
    return ScrollableTableView(
      columns: _createColumns(),
      rows: _createRows(),


    );


     /* DataTable2(
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
    );*/
  }

  List<TableViewColumn> _createColumns() {
    return [

      const TableViewColumn(label:'V No'),
      const TableViewColumn(label:'Date'),
      const TableViewColumn(label:'Description'),
      const TableViewColumn(label:'Weight'),
      const TableViewColumn(label:'Rate'),
      const TableViewColumn(label:'Debit'),
      const TableViewColumn(label:'Credit'),
      const TableViewColumn(label:'Balance'),

    ];
  }

  List<TableViewRow> _createRows() {
    return results
        .map((book) => TableViewRow(cells: [
        TableViewCell(
        child: Center(child: Text(book.id.toString(),style: TextStyle(color: MyColors.blue))),
    ),
        TableViewCell(
        child: Text(book.date.toString()),
    ),
        TableViewCell(
        child: Text(book.description.toString()),
    ),
        TableViewCell(
        child: Text(book.weight.toString()),
    ),
        TableViewCell(
        child: Text(book.rate.toString()),
    ),
        TableViewCell(
        child: Text(book.debit.toString()),
    ),
        TableViewCell(
        child: Text(book.credit.toString()),
    ),
        TableViewCell(
        child: Text(book.balance.toString()),
    ),
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
  Future<void> selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: openingdate,
        firstDate: DateTime(1800),
        lastDate: DateTime(5500));
    if (picked != null && picked != openingdate) {
      setState(() {
        openingdate = picked;
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        OpeningDate = formatter.format(openingdate).toString();


      });
    }
    else{
      setState(() {

        DateFormat formatter = DateFormat('yyyy-MM-dd');
        OpeningDate = formatter.format(openingdate).toString();


      });

    }

  }
  Future<void> selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: closingdate,
        firstDate: DateTime(1800),
        lastDate: DateTime(5500));
    if (picked != null && picked != closingdate) {
      setState(() {
        closingdate = picked;
        DateFormat formatter = DateFormat('yyyy-MM-dd');
        ClosingDate = formatter.format(closingdate).toString();


      });
    }
    else{
      setState(() {

        DateFormat formatter = DateFormat('yyyy-MM-dd');
        ClosingDate = formatter.format(closingdate).toString();


      });

    }

  }
  Future<bool> _checkPermission() async {
    if (platform == TargetPlatform.android) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }
  Future<void> _prepareSaveDir() async {
    _localPath = (await _findLocalPath())!;

    print(_localPath);
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  Future<String?> _findLocalPath() async {
    if (platform == TargetPlatform.android) {
      return "/sdcard/download/";
    } else {
      var directory = await getTemporaryDirectory();
      return directory.path + Platform.pathSeparator + 'Download';
    }
  }







}
