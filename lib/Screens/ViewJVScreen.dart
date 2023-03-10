import 'dart:convert';


import 'package:financemanager/Constants.dart';
import 'package:financemanager/Models/JvModel.dart';

import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Utils.dart';
import 'package:financemanager/widgets/LedgerDrawer.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:financemanager/widgets/Toolbar.dart';
import 'package:financemanager/widgets/ToolbarImage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scrollable_table_view/scrollable_table_view.dart';

class ViewJVScreen extends StatefulWidget {
  const ViewJVScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ViewJVState();
  }
}

class ViewJVState extends State<ViewJVScreen> {
  final GlobalKey<ScaffoldState> jvKey =
  GlobalKey<ScaffoldState>();
  List<JvModel>  results= [





  ];
  TextEditingController fromController = TextEditingController();
  DateTime openingDate = DateTime.now();
  String OpeningDate="";
  TextEditingController ToController = TextEditingController();
  DateTime closingDate = DateTime.now();
  String ClosingDate="";
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
          results.add(JvModel.fromJson(item));

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
      key: jvKey,
      appBar:ToolbarBack(appBar: AppBar(


      ), title:"New Voucher",

      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,

        children: [

          Padding(
            padding: const EdgeInsets.only(left:12.0,right:12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(

                  children: [
                    TextWidget(

                      input: "Date :  ",
                      fontsize: 16,
                      fontWeight: FontWeight.normal,
                      textcolor: MyColors.blackColor8,
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: fromController,
                        onTap: () async{
                          FocusScope.of(context).requestFocus(FocusNode());
                          await selectFromDate(context);
                          fromController.text = DateFormat('dd-MM-yyyy').format(openingDate);
                        },
                        onChanged: (String value){
                          OpeningDate=value;
                        },
                        style:TextStyle(color: MyColors.blue) ,

                        decoration:InputDecoration(
                          border: InputBorder.none,
                          hintText:"${openingDate.day}-${openingDate.month}-${openingDate.year}",
                          hintStyle: TextStyle(color: MyColors.blue),

                        ),
                      ),
                    ),
                  ],
                ),

                IconButton(onPressed: (){
                  Fluttertoast.showToast(
                      msg: "Voucher Saved",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      backgroundColor:MyColors.blue,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                  Navigator.pop(context);



                }, icon:Icon(Icons.save,color: MyColors.blue,))

              ],
            ),
          ),

          Expanded(

              child:  ScrollableTableView(
                columns:[

                  const TableViewColumn(label:'A/C'),

                  const TableViewColumn(label:'Description'),


                  const TableViewColumn(label:'Debit'),
                  const TableViewColumn(label:'Credit'),


                ],
                rows: results.map((book) => TableViewRow(cells: [
                  TableViewCell(
                    child: Center(child: Text(book.accountName.toString(),style: TextStyle(color: MyColors.blue))),
                  ),

                  TableViewCell(
                    child: Text(book.description.toString()),
                  ),
                  TableViewCell(
                    child: Text(book.debit.toString()),
                  ),
                  TableViewCell(
                    child: Text(book.credit.toString()),
                  ),

                ])).toList(),


              )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:() async {
          await Navigator.pushNamed(context, Constants.addJVScreen);
          setState(() {
            results.clear();
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
        initialDate: openingDate,
        firstDate: DateTime(1800),
        lastDate: DateTime(5500));
    if (picked != null && picked != openingDate) {
      setState(() {
        openingDate = picked;
        DateFormat formatter = DateFormat('dd-MM-yyyy');
        OpeningDate = formatter.format(openingDate).toString();


      });
    }
    else{
      setState(() {

        DateFormat formatter = DateFormat('dd-MM-yyyy');
        OpeningDate = formatter.format(openingDate).toString();


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
