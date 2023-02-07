import 'dart:convert';

import 'package:financemanager/Constants.dart';


import 'package:financemanager/Models/RecieptModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Screens/EditCreditScreen.dart';
import 'package:financemanager/Utils.dart';

import 'package:financemanager/widgets/TextWidget.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';


class CreditScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RecieptState();
  }


}
class RecieptState extends State<CreditScreen>{
  List<RecieptModel>rpayy=[];
  List<RecieptModel>_foundUsers=[];
  TextEditingController FromController = TextEditingController();
  DateTime openingdate = DateTime.now();
  String OpeningDate="";
  TextEditingController ToController = TextEditingController();
  DateTime closingdate = DateTime.now();
  String ClosingDate="";
  @override
  void initState() {
    // TODO: implement initState

    EasyLoading.show(
        status: "Loading"

    );



    setState(() {


      try{
        getPaymentList();
      }catch (e){
        confirmationPopup(context, "An error Occurred.Try again later!");

      }

    });



  }
  void _runFilter(String enteredKeyword) {
    List<RecieptModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = rpayy;
    } else {
      results = rpayy
          .where((user) =>
      user.AccountTitle.toLowerCase().contains(enteredKeyword.toLowerCase())||user.Amount.contains(enteredKeyword.toString())||user.Date.contains(enteredKeyword.toString()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }
  Future<void> getPaymentList() async {

    var url = Uri.parse('${Utils.baseUrl}getReciept');
    var response = await http.post(url,body: {"user_id":Utils.USER_ID.toString()}).timeout(const Duration(seconds: 30),onTimeout: (){

      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);


      setState(() {
        rpayy.clear();

        body.forEach((item){
          print(item);
          rpayy.add(RecieptModel.fromJson(item));
          _foundUsers=rpayy;

        });
      });




    } else {
      EasyLoading.dismiss();

      print(response.statusCode);


    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Column(
          children: [
            TextField(

              onChanged: (value) => _runFilter(value),
              style: TextStyle(color: Colors.white),
              showCursor: true,
              decoration: const InputDecoration(

                  labelText: 'Search-Date-Name-Amount',labelStyle: TextStyle(color: Colors.white), suffixIcon: Icon(Icons.search,color: Colors.white,)),
            ),
          ],
        ),

      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: MyColors.whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Column(
              children: [

                Expanded(

                  child: _foundUsers.isNotEmpty?ListView.builder(
                    itemCount: _foundUsers.length,
                    addRepaintBoundaries: true,
                    scrollDirection:Axis.vertical,
                    shrinkWrap: false,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      RecieptModel reciptmodel =_foundUsers[index];
                      return GestureDetector(
                        onLongPress: (){
                          showMenu(context: context,  position:RelativeRect.fromLTRB(100, 100, 100, 100),
                            items:[
                              PopupMenuItem(
                                value: "1",

                                child: const Text("Edit"),
                              ),
                              PopupMenuItem(
                                value: "2",
                                onTap: ()async{
                                  EasyLoading.show(status: "Loading");
                                  var url = Uri.parse(
                                      '${Utils.baseUrl}deletePayment');
                                  var response = await http
                                      .post(url, body: {
                                    "id": reciptmodel.ReceiptId
                                  }).timeout(const Duration(seconds: 30),
                                      onTimeout: () {
                                        return confirmationPopup(context,
                                            "Check your Internet Connection!");
                                      });

                                  if (response.statusCode == 200) {
                                    EasyLoading.dismiss();
                                    print(response.body);
                                    dynamic body =
                                    jsonDecode(response.body);
                                    String status = body['status'];
                                    if (status == "success") {
                                      setState(() {
                                        _foundUsers.removeAt(index);
                                      });
                                    } else {
                                      String error = body['message'];
                                      confirmationPopup(context, error);
                                    }
                                  } else {
                                    EasyLoading.dismiss();

                                    print(response.statusCode);
                                  }
                                },
                                child: Text("Delete"),
                              ),

                            ],



                          ).then<void>((String? itemSelected){
                            if(itemSelected==null){
                              return null;
                            }
                            if(itemSelected =="1"){
                              Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) => EditCreditScreen(),
                                  settings: RouteSettings(
                                    arguments:
                                    _foundUsers[index],
                                  ),
                                ),).then((value) {
                                initState();
                              });
                              //code here
                            }else{
                              //code here
                            }

                          });
                        },


                        child: Container(

                          child: Card(
                            color: MyColors.whiteColor,
                            elevation:2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: BorderSide(color: MyColors.blackColor24, width: 1.0)),
                            child:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Utils.FORM_HINT_PADDING,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextWidget(
                                          input: "REC-${reciptmodel.ReceiptId}",
                                          fontsize: 15,
                                          fontWeight: FontWeight.w600,
                                          textcolor: MyColors.blackColor8),
                                      TextWidget(
                                          input: reciptmodel.Date,
                                          fontsize: 15,
                                          fontWeight: FontWeight.w600,
                                          textcolor: MyColors.blackColor8),
                                    ],
                                  ),
                                  TextWidget(
                                      input: "Account:${reciptmodel.AccountTitle}",
                                      fontsize: 18,
                                      fontWeight: FontWeight.w800,
                                      textcolor: MyColors.blackColor8),
                                  TextWidget(
                                      input:"Description:${reciptmodel.Description}",
                                      fontsize: 12,
                                      fontWeight: FontWeight.w400,
                                      textcolor: MyColors.blackColor8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextWidget(
                                          input:"Amount:${reciptmodel.Amount}",
                                          fontsize: 15,
                                          fontWeight: FontWeight.bold,
                                          textcolor: MyColors.blackColor8),
                                    ],
                                  ),
                                  Utils.FORM_HINT_PADDING,

                                  Divider(
                                    thickness: 2.0,
                                    color: MyColors.blue,
                                  ),



                                ],
                              ),
                            ),

                          ),
                        ),
                      );
                    },
                  ): const Center(
                    child: Text(
                      'No record found',
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton:FloatingActionButton(
        onPressed:()async{
          await Navigator.pushNamed(context, Constants.addReceiptScreen);
          setState(() {
            rpayy.clear();
            initState();
          });

        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),

    );
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


}

