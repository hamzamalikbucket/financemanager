import 'dart:convert';

import 'package:bottom_loader/bottom_loader.dart';
import 'package:financemanager/Constants.dart';
import 'package:financemanager/Models/AccountModel.dart';
import 'package:financemanager/Models/PurchaseModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Screens/EditAccountScreen.dart';
import 'package:financemanager/Screens/PurchaseDetail.dart';
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

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PurchaseState();
  }
}

class PurchaseState extends State<PurchaseScreen> {

  List<AccountModel> purchases = [];
  late BottomLoader bl;

  @override
  void initState() {
    // TODO: implement initState

    EasyLoading.show(status: "Loading");

    setState(() {
      try {
        getAccountList();
      } catch (e) {
        confirmationPopup(context, "An error Occurred.Try again later!");
      }
    });
  }

  Future<void> getAccountList() async {
    var url = Uri.parse('${Utils.baseUrl}getAccounts');
    var response = await http
        .post(url, body: {"gid": Utils.USER_ID.toString()}).timeout(
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
          purchases.add(AccountModel.fromJson(item));

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
        appBar: ToolbarBack(appBar: AppBar(), title: 'Purchase Invoice',),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: MyColors.whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: RefreshIndicator(
              onRefresh: () {
                purchases.clear();
                return getAccountList();
              },
              child: ListView.builder(
                itemCount: purchases.length,
                addRepaintBoundaries: true,
                scrollDirection: Axis.vertical,
                shrinkWrap: false,
                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  AccountModel purchaseModel = purchases[index];
                  return GestureDetector(
                     onTap: (){
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => PurchaseDetailScreen(),
                            settings: RouteSettings(
                              arguments: purchases[index],

                            ),
                          ),);
                      },

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
                                      input: purchaseModel.Title!,
                                      fontsize: 15,
                                      fontWeight: FontWeight.w600,
                                      textcolor: MyColors.blackColor8),
                                 /* SizedBox(
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => EditAccountScreen(),
                                                settings: RouteSettings(
                                                  arguments: purchases[index],
                                                ),
                                              ),
                                            ).then((value) {
                                              purchases.clear();
                                              initState();
                                            });


                                          },
                                          icon: Icon(
                                            Icons.edit_note,
                                            color: MyColors.blue,
                                            size: 20,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            EasyLoading.show(status: "Loading");
                                            var url = Uri.parse(
                                                '${Utils.baseUrl}deleteAccount');
                                            var response = await http
                                                .post(url, body: {
                                              "id": purchaseModel.purchaseId
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
                                                  purchases.removeAt(index);
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
                                          icon: Icon(
                                            Icons.delete_forever,
                                            color: MyColors.bin_red_color,
                                            size: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),*/
                                ],
                              ),
                              Utils.FORM_HINT_PADDING,

                            /*  Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidget(
                                      input: "Total Amount:${purchaseModel.totalAmount!}",
                                      fontsize: 10,
                                      fontWeight: FontWeight.bold,
                                      textcolor: MyColors.blackColor8),
                                ],
                              ),*/

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
