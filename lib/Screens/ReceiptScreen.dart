import 'dart:convert';

import 'package:financemanager/Constants.dart';


import 'package:financemanager/Models/RecieptModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Utils.dart';

import 'package:financemanager/widgets/TextWidget.dart';
import 'package:financemanager/widgets/ToolbarImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:rflutter_alert/rflutter_alert.dart';


class ReceiptScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return RecieptState();
  }


}
class RecieptState extends State<ReceiptScreen>{
  List<RecieptModel>rpayy=[];
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

    var url = Uri.parse('${Utils.baseUrl}getReciept');
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
          rpayy.add(RecieptModel.fromJson(item));

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
      appBar: ToolbarImage(appBar: AppBar(),),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: MyColors.whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: ListView.builder(
              itemCount: rpayy.length,
              addRepaintBoundaries: true,
              scrollDirection:Axis.vertical,
              shrinkWrap: false,
              physics: AlwaysScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                RecieptModel reciptmodel = rpayy[index];
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
                            TextWidget(
                                input: reciptmodel.AccountTitle,
                                fontsize: 15,
                                fontWeight: FontWeight.w600,
                                textcolor: MyColors.blackColor8),
                            TextWidget(
                                input:"Amount:"+reciptmodel.Amount,
                                fontsize: 10,
                                fontWeight: FontWeight.bold,
                                textcolor: MyColors.blackColor8),
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


}

