import 'dart:convert';

import 'package:bottom_loader/bottom_loader.dart';
import 'package:financemanager/Constants.dart';
import 'package:financemanager/Screens/LedgerScreen.dart';
import 'package:financemanager/widgets/AppDrawer.dart';
import 'package:financemanager/widgets/BtnNullHeightWidth.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

import '../Models/AccountModel.dart';
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

  var title;
  late BottomLoader bl;
  final GlobalKey<FormState> PayKey = GlobalKey<FormState>();

  TextEditingController FromController = TextEditingController();
  DateTime openingdate = DateTime.now();
  String OpeningDate="";
  TextEditingController ToController = TextEditingController();
  DateTime closingdate = DateTime.now();
  String ClosingDate="";

  List<AccountModel>account=[];


  @override
  void initState() {
    // TODO: implement initState
    bl = BottomLoader(context,
        isDismissible: true,
        showLogs: true,
        loader: CircularProgressIndicator(
          color: MyColors.blue,
        ));
    bl.style(
        message: 'Please Wait...',
        backgroundColor: MyColors.darkgreenColor,
        messageTextStyle: TextStyle(
            color: MyColors.darkgreenColor,
            fontSize: 19.0,
            fontWeight: FontWeight.w600));


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
        getAccountList();

      }catch (e){
        confirmationPopup(context, "An error Occurred.Try again later!");

      }




    });


  }
  Future<void> getAccountList() async {

    var url = Uri.parse('${Utils.baseUrl}getAccounts');
    var response = await http.post(url,body: {"gid":Utils.USER_ID.toString()}).timeout(const Duration(seconds: 30),onTimeout: (){

      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);


      setState(() {

        body.forEach((item){
          print(item);
          account.add(AccountModel.fromJson(item));

        });
      });




    } else {
      EasyLoading.dismiss();

      print(response.statusCode);


    }
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
              SizedBox(
                child: Card(

                  color: MyColors.facebook_button_color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(
                          color: MyColors.nocolor, width: 1.0)),
                  elevation: 25,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 80,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextWidget(
                                      input: "Debit",
                                      fontsize: 16,
                                      fontWeight: FontWeight.bold,
                                      textcolor: MyColors.whiteColor),
                                  TextWidget(
                                      input:Debit
                                          .toString(),
                                      fontsize: 20,
                                      fontWeight: FontWeight.w700,
                                      textcolor: MyColors.whiteColor),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextWidget(
                                      input: "Credit",
                                      fontsize: 16,
                                      fontWeight: FontWeight.bold,
                                      textcolor: MyColors.whiteColor),

                                  TextWidget(
                                      input: Credit.toString(),
                                      fontsize: 20,
                                      fontWeight: FontWeight.w700,
                                      textcolor: MyColors.whiteColor),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 80,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextWidget(
                                      input: "Purchase",
                                      fontsize: 16,
                                      fontWeight: FontWeight.bold,
                                      textcolor: MyColors.whiteColor),
                                  TextWidget(
                                      input: Purchase.toString(),
                                      fontsize: 20,
                                      fontWeight: FontWeight.w700,
                                      textcolor: MyColors.whiteColor),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextWidget(
                                      input: "Sale",
                                      fontsize: 16,
                                      fontWeight: FontWeight.bold,
                                      textcolor: MyColors.whiteColor),
                                  TextWidget(
                                      input: Sale.toString(),
                                      fontsize: 20,
                                      fontWeight: FontWeight.w700,
                                      textcolor: MyColors.whiteColor),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 80,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextWidget(
                                      input: "Stock",
                                      fontsize: 16,
                                      fontWeight: FontWeight.bold,
                                      textcolor: MyColors.whiteColor),
                                  TextWidget(
                                      input: "100",
                                      fontsize: 20,
                                      fontWeight: FontWeight.w700,
                                      textcolor: MyColors.whiteColor),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextWidget(
                                      input: "Difference",
                                      fontsize: 16,
                                      fontWeight: FontWeight.bold,
                                      textcolor: MyColors.whiteColor),

                                  TextWidget(
                                      input: Diff.toString(),
                                      fontsize: 20,
                                      fontWeight: FontWeight.w700,
                                      textcolor: MyColors.whiteColor),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),


                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 80,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextWidget(
                                      input: "Other Expenses",
                                      fontsize: 16,
                                      fontWeight: FontWeight.w600,
                                      textcolor: MyColors.whiteColor),
                                  TextWidget(
                                      input: totalOtherExpense.toString(),
                                      fontsize: 20,
                                      fontWeight: FontWeight.w700,
                                      textcolor: MyColors.whiteColor),

                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80,
                            width: 180,
                            child: Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextWidget(
                                      input: "Diff. Debit-Credit",
                                      fontsize: 16,
                                      fontWeight: FontWeight.w500,
                                      textcolor: MyColors.whiteColor),
                                  TextWidget(
                                      input: Diff.toString(),
                                      fontsize: 20,
                                      fontWeight: FontWeight.w700,
                                      textcolor: MyColors.whiteColor),

                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Utils.FORM_HINT_PADDING,
              Utils.FORM_HINT_PADDING,
              Divider(
                color: MyColors.gray,
                thickness: 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: 150,
                    width: 120,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, Constants.AccountScreen).then((value) => initState());
                      },
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(
                                color: MyColors.gray,
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
                      ledgerPopUp(context);
                      //Navigator.pushNamed(context, Constants.ledgerScreen).then((value) => initState());
                    },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
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
                    height: 150,
                    width: 120,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, Constants.PaymentScreen).then((value) => initState());

                      },
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
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


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 150,
                    width: 120,
                    child: GestureDetector(
                      onTap: (){
                        Navigator.pushNamed(context, Constants.recieptScreen).then((value) => initState());
                      },
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(
                                color: MyColors.gray,
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
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(
                                color: MyColors.gray,
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
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(
                                color: MyColors.gray,
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap:(){
                      Navigator.pushNamed(context, Constants.saleScreen).then((value) => initState());

        },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(
                                color: MyColors.gray,
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
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(
                                color: MyColors.gray,
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
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
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


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 150,
                    width: 120,
                    child: Card(
                      color: MyColors.gray,
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          side: BorderSide(
                              color: MyColors.gray,
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
                    height: 150,
                    width: 120,
                    child: Card(
                      color: MyColors.blue,
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
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
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(
                                color: MyColors.gray,
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

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 150,
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
  Future<void> ledgerPopUp(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Choose Options'),

            content: Form(
              key:PayKey,
              child: Column(


                children: [
                  SizedBox(

                    child: DropdownButtonHideUnderline(
                      child:
                      DropdownButtonFormField(
                        value: title,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: MyColors.views_btn,
                          contentPadding: const EdgeInsets.all(10),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 0.0,
                                style: BorderStyle.none),
                            borderRadius:
                            BorderRadius.all(
                                Radius.circular(13.0)),
                          ),
                        ),
                        iconSize: 20,
                        hint: const Text("A/C Title"),
                        iconEnabledColor: MyColors.blue,
                        validator: (value) => value == null
                            ? 'Choose Account Title'
                            : null,
                        style: TextStyle(
                            color: MyColors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        isDense: true,


                        items: account.map((item) {
                          return DropdownMenuItem(
                            value:item.AccountId.toString(),
                            child: Text(
                              item.Title.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            title= newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  Row(
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


                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                    ],
                  ),

                ],
              ),
            ),
            actions: <Widget>[
              BtnNullHeightWidth(
                title: "Save",
                bgcolour: MyColors.blue,
                textcolour: MyColors.whiteColor,
                onPress: () {
                  //(is_teacher)?Navigator.pushReplacementNamed(context, Constants.signup_page),
                  final form = PayKey.currentState;
                  form!.save();
                  if (form.validate()) {
                    print(title);
                    bl.display();

                    if(OpeningDate.isEmpty){
                      setState(() {

                        OpeningDate = openingdate.toString();

                      });

                    }
                    if(ClosingDate.isEmpty){
                      setState(() {

                        ClosingDate = closingdate.toString();

                      });

                    }


                    Navigator.push(context,
                      MaterialPageRoute(
                        builder: (context) => LedgerScreen(),
                        settings: RouteSettings(
                          arguments: {
                            "id":title,
                            "from date":OpeningDate,
                            "to date":ClosingDate,
                          },

                        ),
                      ),);



                  }
                },
                width: MediaQuery.of(context).size.width,
                height: 48,
              ),



            ],
          );
        });
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

}