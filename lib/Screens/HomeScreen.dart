import 'dart:convert';

import 'package:financemanager/Constants.dart';
import 'package:financemanager/widgets/AppDrawer.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../MyColors.dart';
import '../Utils.dart';
import 'package:http/http.dart'as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
   return HomeState();

  }

}
class HomeState extends State<HomeScreen>{
  final GlobalKey<ScaffoldState> _ScafoldHomeKey =
  new GlobalKey<ScaffoldState>();
   int Purchase=0;
   int Sale=0;
   int Debit=0;
   int Credit=0;
   int Diff=0;
   int totalOtherExpense=0;


  @override
  void initState() {
    // TODO: implement initState


    EasyLoading.show(
        status: "Loading"

    );
    setState(() {
      try{
        getAmounts();

      }catch (e){
        confirmationPopup(context, "An error Occurred.Try again later!");

      }


    });







  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    setState(() {

      try{
        getAmounts();

      }catch (e){
        confirmationPopup(context, "An error Occurred.Try again later!");

      }




    });


  }
  Future<void> getAmounts() async {


    var url = Uri.parse('${Utils.baseUrl}getTotalAmounts');
    var response = await http.post(url,body:{"user_id":Utils.USER_ID.toString(),}).timeout(const Duration(seconds: 30),onTimeout: (){

      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);
      setState(() {
        Purchase=body['totalPurchase'];
        Sale=body['totalSale'];
        Credit=body['totalCredit'];
        Debit=body['totalDebit'];
        Diff=body['totalDifference'];
        totalOtherExpense=body['totalOtherExpense'];


      });




    } else {
      EasyLoading.dismiss();

      print(response.statusCode);


    }
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _ScafoldHomeKey,
      drawer: AppDrawer(),
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
                input: "Menu",
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

      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 80,
                    width: 180,
                    child: Card(
                      color: MyColors.blue,
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: MyColors.blue,
                              width: 1.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    input: "Debit",
                                    fontsize: 16,
                                    fontWeight: FontWeight.bold,
                                    textcolor: MyColors.whiteColor),
                                Image.asset(
                                  "assets/images/earnings.png",
                                  height: 30,
                                  width: 30,
                                  color: MyColors.whiteColor,
                                ),
                              ],
                            ),
                            TextWidget(
                                input:Debit!
                                    .toString(),
                                fontsize: 20,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    width: 180,
                    child: Card(
                      color: MyColors.facebook_button_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: MyColors.nocolor, width: 1.0)),
                      elevation: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    input: "Credit",
                                    fontsize: 16,
                                    fontWeight: FontWeight.bold,
                                    textcolor: MyColors.whiteColor),
                                Image.asset(
                                  "assets/images/earnings.png",
                                  height: 30,
                                  width: 30,
                                  color: MyColors.whiteColor,
                                ),

                              ],
                            ),
                            TextWidget(
                                input: Credit!.toString(),
                                fontsize: 20,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Utils.FORM_HINT_PADDING,
              Utils.FORM_HINT_PADDING,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 80,
                    width: 180,
                    child: Card(
                      color: MyColors.blue,
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: MyColors.blue,
                              width: 1.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    input: "Purchase",
                                    fontsize: 16,
                                    fontWeight: FontWeight.bold,
                                    textcolor: MyColors.whiteColor),
                                Image.asset(
                                  "assets/images/order.png",
                                  height: 30,
                                  width: 30,
                                  color: MyColors.whiteColor,
                                ),
                              ],
                            ),
                            TextWidget(
                                input: Purchase!.toString(),
                                fontsize: 20,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    width: 180,
                    child: Card(
                      color: MyColors.facebook_button_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: MyColors.nocolor, width: 1.0)),
                      elevation: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    input: "Sale",
                                    fontsize: 16,
                                    fontWeight: FontWeight.bold,
                                    textcolor: MyColors.whiteColor),
                                Image.asset(
                                  "assets/images/sellers.png",
                                  height: 30,
                                  width: 30,
                                  color: MyColors.whiteColor,
                                ),

                              ],
                            ),
                            TextWidget(
                                input: Sale!.toString(),
                                fontsize: 20,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Utils.FORM_HINT_PADDING,
              Utils.FORM_HINT_PADDING,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 80,
                    width: 180,
                    child: Card(
                      color: MyColors.blue,
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: MyColors.blue,
                              width: 1.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    input: "Stock",
                                    fontsize: 16,
                                    fontWeight: FontWeight.bold,
                                    textcolor: MyColors.whiteColor),
                                Image.asset(
                                  "assets/images/margins.png",
                                  height: 30,
                                  width: 30,
                                  color: MyColors.whiteColor,
                                ),
                              ],
                            ),
                            TextWidget(
                                input: "100",
                                fontsize: 20,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    width: 180,
                    child: Card(
                      color: MyColors.facebook_button_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: MyColors.nocolor, width: 1.0)),
                      elevation: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    input: "Difference",
                                    fontsize: 16,
                                    fontWeight: FontWeight.bold,
                                    textcolor: MyColors.whiteColor),
                                Image.asset(
                                  "assets/images/margins.png",
                                  height: 30,
                                  width: 30,
                                  color: MyColors.whiteColor,
                                ),

                              ],
                            ),
                            TextWidget(
                                input: Diff!.toString(),
                                fontsize: 20,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Utils.FORM_HINT_PADDING,
              Utils.FORM_HINT_PADDING,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 80,
                    width: 180,
                    child: Card(
                      color: MyColors.blue,
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: MyColors.blue,
                              width: 1.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    input: "Other Expenses",
                                    fontsize: 16,
                                    fontWeight: FontWeight.w600,
                                    textcolor: MyColors.whiteColor),
                                Image.asset(
                                  "assets/images/earnings.png",
                                  height: 30,
                                  width: 30,
                                  color: MyColors.whiteColor,
                                ),
                              ],
                            ),
                            TextWidget(
                                input: totalOtherExpense!.toString(),
                                fontsize: 20,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 80,
                    width: 180,
                    child: Card(
                      color: MyColors.facebook_button_color,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: MyColors.nocolor, width: 1.0)),
                      elevation: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                TextWidget(
                                    input: "Diff. Debit-Credit",
                                    fontsize: 16,
                                    fontWeight: FontWeight.w500,
                                    textcolor: MyColors.whiteColor),
                                Image.asset(
                                  "assets/images/earnings.png",
                                  height: 30,
                                  width: 30,
                                  color: MyColors.whiteColor,
                                ),

                              ],
                            ),
                            TextWidget(
                                input: Diff!.toString(),
                                fontsize: 20,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Utils.FORM_HINT_PADDING,
              Utils.FORM_HINT_PADDING,
              Divider(
                color: MyColors.gray,
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, Constants.AccountScreen).then((value) => initState());
                      },
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyColors.blue,
                                width: 1.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Utils.FORM_HINT_PADDING,
                              TextWidget(
                                  input: "Accounts",
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  textcolor: MyColors.whiteColor),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, Constants.ledgerScreen).then((value) => initState());
                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyColors.blue,
                                width: 1.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Utils.FORM_HINT_PADDING,
                              TextWidget(
                                  input: "Ledger",
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  textcolor: MyColors.whiteColor),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, Constants.PaymentScreen).then((value) => initState());

                      },
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyColors.blue,
                                width: 1.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Utils.FORM_HINT_PADDING,

                              TextWidget(
                                  input: "Payment",
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  textcolor: MyColors.whiteColor),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              Utils.FORM_HINT_PADDING,
              Utils.FORM_HINT_PADDING,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, Constants.recieptScreen).then((value) => initState());
                      },
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyColors.blue,
                                width: 1.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Utils.FORM_HINT_PADDING,
                              TextWidget(
                                  input: "Receipt",
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  textcolor: MyColors.whiteColor),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, Constants.jVScreen).then((value) => initState());

                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyColors.blue,
                                width: 1.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Utils.FORM_HINT_PADDING,
                              TextWidget(
                                  input: "Journal",
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  textcolor: MyColors.whiteColor),
                              TextWidget(
                                  input: "Voucher",
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  textcolor: MyColors.whiteColor),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap:() {
                      Navigator.pushNamed(context, Constants.purchaseScreen).then((value) => initState());


                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyColors.blue,
                                width: 1.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Utils.FORM_HINT_PADDING,
                              TextWidget(
                                  input: "Purchase",
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  textcolor: MyColors.whiteColor),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              Utils.FORM_HINT_PADDING,
              Utils.FORM_HINT_PADDING,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap:(){
                      Navigator.pushNamed(context, Constants.saleScreen).then((value) => initState());

        },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyColors.blue,
                                width: 1.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Utils.FORM_HINT_PADDING,
                              TextWidget(
                                  input: "Sale",
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  textcolor: MyColors.whiteColor),


                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, Constants.itemScreen).then((value) => initState());
                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyColors.blue,
                                width: 1.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Utils.FORM_HINT_PADDING,
                              TextWidget(
                                  input: "Items",
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  textcolor: MyColors.whiteColor),

                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      Navigator.pushNamed(context, Constants.containerScreen).then((value) => initState());

                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyColors.blue,
                                width: 1.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                              Utils.FORM_HINT_PADDING,
                              TextWidget(
                                  input: "Containers",
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  textcolor: MyColors.whiteColor),


                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
              Utils.FORM_HINT_PADDING,
              Utils.FORM_HINT_PADDING,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Card(
                      color: MyColors.blue,
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: MyColors.blue,
                              width: 1.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Utils.FORM_HINT_PADDING,
                            TextWidget(
                                input: "Container",
                                fontsize: 16,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),
                            TextWidget(
                                input: "Summary",
                                fontsize: 16,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),

                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 120,
                    width: 120,
                    child: Card(
                      color: MyColors.blue,
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: MyColors.blue,
                              width: 1.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Utils.FORM_HINT_PADDING,
                            TextWidget(
                                input: "Account",
                                fontsize: 16,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),
                            TextWidget(
                                input: "Summary",
                                fontsize: 16,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),


                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap:(){
                      Navigator.pushNamed(context, Constants.viewOtherexpenses).then((value) => initState());

                    },
                    child: SizedBox(
                      height: 120,
                      width: 120,
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(
                                color: MyColors.blue,
                                width: 1.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Utils.FORM_HINT_PADDING,
                              TextWidget(
                                  input: "Other",
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  textcolor: MyColors.whiteColor),
                              TextWidget(
                                  input: "Expenses",
                                  fontsize: 16,
                                  fontWeight: FontWeight.w700,
                                  textcolor: MyColors.whiteColor),


                            ],
                          ),
                        ),
                      ),
                    ),
                  ),


                ],
              ),
              Utils.FORM_HINT_PADDING,
              Utils.FORM_HINT_PADDING,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 120,
                    width: 150,
                    child: Card(
                      color: MyColors.blue,
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(
                              color: MyColors.blue,
                              width: 1.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[

                            Utils.FORM_HINT_PADDING,
                            TextWidget(
                                input: "Container",
                                fontsize: 16,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),
                            TextWidget(
                                input: "expenses",
                                fontsize: 16,
                                fontWeight: FontWeight.w700,
                                textcolor: MyColors.whiteColor),


                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),


            ],

          ),
        ),
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