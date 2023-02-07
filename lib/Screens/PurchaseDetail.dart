import 'dart:convert';

import 'package:bottom_loader/bottom_loader.dart';
import 'package:financemanager/Constants.dart';
import 'package:financemanager/Models/AccountModel.dart';
import 'package:financemanager/Models/PurchaseModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Screens/EditAccountScreen.dart';
import 'package:financemanager/Utils.dart';
import 'package:financemanager/widgets/BtnNullHeightWidth.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:financemanager/widgets/Toolbar.dart';
import 'package:financemanager/widgets/ToolbarImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class PurchaseDetailScreen extends StatefulWidget {
  const PurchaseDetailScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return DetailState();
  }
}

class DetailState extends State<PurchaseDetailScreen> {
  List<PurchaseModel> purchasesdetail = [];
  late BottomLoader bl;
  late AccountModel accountModel;

  @override
  void initState() {
    // TODO: implement initState

    EasyLoading.show(status: "Loading");

    setState(() {
      try {
        purchasesdetail.clear();

      } catch (e) {
        confirmationPopup(context, "An error Occurred.Try again later!");
      }
    });
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    accountModel= ModalRoute.of(context)!.settings.arguments as AccountModel;

    setState(() {

      purchasesdetail.clear();


      try{
        getPurchaseDetail();

      }catch (e){
        confirmationPopup(context, "An error Occurred.Try again later!");

      }



    });

  }


  Future<void> getPurchaseDetail() async {
    var url = Uri.parse('${Utils.baseUrl}getSalePurchase');
    var response = await http
        .post(url, body: {"user_id": Utils.USER_ID.toString(),"status":"purchase","account_id":accountModel.AccountId}).timeout(
        const Duration(seconds: 30), onTimeout: () {
      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);

      setState(() {
        body.forEach((item) {
          print(item);
          purchasesdetail.add(PurchaseModel.fromJson(item));


        });
      });
    } else {
      EasyLoading.dismiss();


      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    accountModel= ModalRoute.of(context)!.settings.arguments as AccountModel;
    return Scaffold(
      appBar: ToolbarBack(appBar: AppBar(), title: 'Purchase Invoice',),
      body: Padding(
        padding: const EdgeInsets.all(3.0),
        child: RefreshIndicator(
          onRefresh: () {
            purchasesdetail.clear();
            return getPurchaseDetail();
          },
          child: ListView.builder(
            itemCount: purchasesdetail.length,
            addRepaintBoundaries: true,
            scrollDirection: Axis.vertical,
            shrinkWrap: false,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              PurchaseModel purchaseModel = purchasesdetail[index];
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
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                            color: MyColors.blackColor24, width: 1.0)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                  input: "PIN-:${purchaseModel.purchaseId!}",
                                  fontsize: 15,
                                  fontWeight: FontWeight.bold,
                                  textcolor: MyColors.blackColor8),


                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                  input: purchaseModel.containerTitle!,
                                  fontsize: 15,
                                  fontWeight: FontWeight.w800,
                                  textcolor: MyColors.blackColor8),
                              TextWidget(
                                  input: purchaseModel.purchaseDate!,
                                  fontsize: 15,
                                  fontWeight: FontWeight.w600,
                                  textcolor: MyColors.blackColor8),

                            ],
                          ),
                          Utils.FORM_HINT_PADDING,

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                  input: "item Name:${purchaseModel.itemTitle!}",
                                  fontsize: 15,
                                  fontWeight: FontWeight.bold,
                                  textcolor: MyColors.blackColor8),
                              TextWidget(
                                  input: "item weight:${purchaseModel.netWeight!}",
                                  fontsize: 15,
                                  fontWeight: FontWeight.bold,
                                  textcolor: MyColors.blackColor8),
                              TextWidget(
                                  input: "item rate:${purchaseModel.purchaseRate!}",
                                  fontsize: 15,
                                  fontWeight: FontWeight.bold,
                                  textcolor: MyColors.blackColor8),
                            ],
                          ),
                          Utils.FORM_HINT_PADDING,
                          Utils.FORM_HINT_PADDING,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextWidget(
                                  input: "Total Amount:${purchaseModel.totalAmount!}",
                                  fontsize: 15,
                                  fontWeight: FontWeight.w600,
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
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, Constants.addPurchaseScreen);
          setState(() {

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