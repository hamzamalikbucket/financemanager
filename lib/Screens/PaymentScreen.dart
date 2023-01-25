import 'dart:convert';

import 'package:bottom_loader/bottom_loader.dart';
import 'package:financemanager/Constants.dart';
import 'package:financemanager/Models/AccountModel.dart';

import 'package:financemanager/Models/PaymentModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Screens/EditPaymentScreen.dart';
import 'package:financemanager/Utils.dart';

import 'package:financemanager/widgets/TextWidget.dart';
import 'package:financemanager/widgets/Toolbar.dart';
import 'package:financemanager/widgets/ToolbarImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class PaymentScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PaymentState();
  }


}
class PaymentState extends State<PaymentScreen>{
  List<PaymentModel>payy=[];
  TextEditingController FromController = TextEditingController();
  DateTime openingdate = DateTime.now();
  String OpeningDate="";
  TextEditingController ToController = TextEditingController();
  DateTime closingdate = DateTime.now();
  String ClosingDate="";
  Offset _tapPosition = Offset.zero;
  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }



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
  Future<void> getPaymentList() async {

    var url = Uri.parse('${Utils.baseUrl}getPayment');
    var response = await http.post(url,body: {"user_id":Utils.USER_ID.toString()}).timeout(const Duration(seconds: 30),onTimeout: (){

      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);


      setState(() {

        body.forEach((item){
          print(item);
          payy.add(PaymentModel.fromJson(item));

        });
      });




    } else {
      EasyLoading.dismiss();

      print(response.statusCode);


    }
  }
  @override
  Widget build(BuildContext context) {
    final RenderObject? overlay =
    Overlay.of(context)?.context.findRenderObject();
    return Scaffold(
      appBar: ToolbarBack(appBar: AppBar(),title: "Payment",),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: MyColors.whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: RefreshIndicator(
              onRefresh:(){
                payy.clear();
                return  getPaymentList();
              },
              child: Column(
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
                              ToController.text = DateFormat('dd-MM-yyyy').format(openingdate);
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
                            payy.clear();
                            initState();


                          });


                        }, icon:Icon(Icons.refresh,color: MyColors.blue,))

                      ],
                    ),
                  ),
                  Expanded(
                    child: payy.isNotEmpty?
                    ListView.builder(
                      itemCount: payy.length,
                      addRepaintBoundaries: true,
                      scrollDirection:Axis.vertical,
                      shrinkWrap: false,
                      physics: AlwaysScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        PaymentModel paymodel = payy[index];
                        return GestureDetector(
                          /* onTap: (){
                              Navigator.push(context,
                                MaterialPageRoute(
                                  builder: (context) => OrderDetail(),
                                  settings: RouteSettings(
                                    arguments: od,
                                  ),
                                ),);
                            },*/
                          onLongPress: (){

                            showMenu(context: context, position: RelativeRect.fromRect(
                                Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 180, 180),
                                Rect.fromLTWH(50, 50, overlay!.paintBounds.size.width,
                                    overlay.paintBounds.size.height)),
                              items:<PopupMenuEntry>[
                                PopupMenuItem(
                                  value: payy[index],
                                  onTap: (){


                                  },

                                  child: const Text("Edit"),
                                ),
                                PopupMenuItem(
                                  value: this.payy[index],
                                  onTap: ()async{
                                    EasyLoading.show(status: "Loading");
                                    var url = Uri.parse(
                                        '${Utils.baseUrl}deletePayment');
                                    var response = await http
                                        .post(url, body: {
                                      "id": paymodel.PaymentId
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
                                          payy.removeAt(index);
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
                                PopupMenuItem(
                                  value: payy[index],
                                  child: const Text("Ledger"),
                                ),
                              ],


                            );
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
                                            input:"Pay-${paymodel.PaymentId!}",
                                            fontsize: 15,
                                            fontWeight: FontWeight.w600,
                                            textcolor: MyColors.blackColor8),
                                        TextWidget(
                                            input:paymodel.Date!,
                                            fontsize: 15,
                                            fontWeight: FontWeight.w600,
                                            textcolor: MyColors.blackColor8),

                                      ],
                                    ),
                                    TextWidget(
                                        input:"Account:${paymodel.AccountTitle!}",
                                        fontsize: 18,
                                        fontWeight: FontWeight.w800,
                                        textcolor: MyColors.blackColor8),
                                    TextWidget(
                                        input:"Description:${paymodel.Description!}",
                                        fontsize: 12,
                                        fontWeight: FontWeight.w400,
                                        textcolor: MyColors.blackColor8),
                                    Row(mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextWidget(
                                            input:"Amount:${paymodel.Amount!}",
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
                        'No Payment found',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton:FloatingActionButton(
        onPressed:() async {
          await Navigator.pushNamed(context, Constants.addPaymentScreen);
      setState(() {
        payy.clear();

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

