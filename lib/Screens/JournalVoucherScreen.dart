import 'dart:convert';

import 'package:financemanager/Constants.dart';
import 'package:financemanager/Models/JvModel.dart';

import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Utils.dart';
import 'package:financemanager/widgets/LedgerDrawer.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:financemanager/widgets/ToolbarImage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';

class JournalVoucherScreen extends StatefulWidget {
  const JournalVoucherScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return JVState();
  }
}

class JVState extends State<JournalVoucherScreen> {
  List<JvModel>  jVList= [];
  TextEditingController FromController = TextEditingController();
  DateTime openingdate = DateTime.now();
  String OpeningDate="";
  TextEditingController ToController = TextEditingController();
  DateTime closingdate = DateTime.now();
  String ClosingDate="";
  final GlobalKey<ScaffoldState> journalKey =
  GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState

    EasyLoading.show(
        status: "Loading"

    );



    setState(() {


      try{
        getJVList();

      }catch (e){
        confirmationPopup(context, "An error Occurred.Try again later!");

      }

    });



  }
  Future<void> getJVList() async {

    var url = Uri.parse('${Utils.baseUrl}getJv');
    var response = await http.post(url,body:{"user_id":Utils.USER_ID.toString()}).timeout(const Duration(seconds: 30),onTimeout: (){

      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);


      setState(() {

        body.forEach((item){
          print(item);
          jVList.add(JvModel.fromJson(item));

        });
      });




    } else {
      EasyLoading.dismiss();

      print(response.statusCode);


    }
  }


  @override
  Widget build(BuildContext context)  {
    return Scaffold(
      key:journalKey,
      appBar: ToolbarImage(appBar: AppBar(),),
      body: Column(
        mainAxisSize: MainAxisSize.min,

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
                    jVList.clear();
                    initState();


                  });


                }, icon:Icon(Icons.refresh,color: MyColors.blue,))

              ],
            ),
          ),

          Expanded(

              child: ScrollableTableView(
                columns:const [

                  TableViewColumn(
                    minWidth: 140,
                      labelFontSize: 20,
                      label:'ID'),

                  TableViewColumn(labelFontSize: 20,label:'Date'),

                  TableViewColumn(labelFontSize: 20,label:'Total Debit'),

                ],
                rows:jVList.map((book) => TableViewRow(cells: [

                  TableViewCell(
                    child: Center(child: Text("#${book.id}",style: TextStyle(color: MyColors.blue))),
                  ),

                  TableViewCell(
                    child: Text(book.date.toString()),
                  ),

                  TableViewCell(
                    child: Text(book.debit.toString()),
                  ),

                ])).toList(),


              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() async {
          await Navigator.pushNamed(context, Constants.viewJVScreen);
          setState(() {
            jVList.clear();
            initState();



          });
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
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
        DateFormat formatter = DateFormat('dd-MM-yyyy');
        OpeningDate = formatter.format(openingdate).toString();


      });
    }
    else{
      setState(() {

        DateFormat formatter = DateFormat('dd-MM-yyyy');
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
        DateFormat formatter = DateFormat('dd-MM-yyyy');
        ClosingDate = formatter.format(closingdate).toString();


      });
    }
    else{
      setState(() {

        DateFormat formatter = DateFormat('dd-MM-yyyy');
        ClosingDate = formatter.format(closingdate).toString();


      });

    }

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
