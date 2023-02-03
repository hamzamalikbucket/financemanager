import 'dart:convert';
import 'dart:io';

import 'package:bottom_loader/bottom_loader.dart';
import 'package:dio/dio.dart';
import 'package:financemanager/Constants.dart';
import 'package:financemanager/Models/ContainerModel.dart';
import 'package:financemanager/Screens/LedgerScreen.dart';
import 'package:financemanager/widgets/AppDrawer.dart';
import 'package:financemanager/widgets/BtnNullHeightWidth.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Models/AccountModel.dart';
import '../MyColors.dart';
import '../Utils.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _ScafoldHomeKey =
      new GlobalKey<ScaffoldState>();
  int Purchase = 0;
  int Sale = 0;
  int Debit = 0;
  int Credit = 0;
  int Diff = 0;
  int totalOtherExpense = 0;

  var title;
  var titlename;
  var containertitle;
  late BottomLoader bl;
  final GlobalKey<FormState> PayKey = GlobalKey<FormState>();
  final GlobalKey<FormState> ContKey = GlobalKey<FormState>();

  TextEditingController FromController = TextEditingController();
  DateTime openingdate = DateTime.now();
  String OpeningDate = "";
  TextEditingController ToController = TextEditingController();
  DateTime closingdate = DateTime.now();
  String ClosingDate = "";

  List<AccountModel> account = [];
  late List<bool> _isChecked;
  List multipleSelected = [];
  List<String> userChecked = [];

  List<ContainerModel> containerItems = [];
  String URL = "";
  late String _localPath;
  late bool _permissionReady;
  late TargetPlatform? platform;
  var dio = Dio();

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

    EasyLoading.show(status: "Loading");
    if (Platform.isAndroid) {
      platform = TargetPlatform.android;
    } else {
      platform = TargetPlatform.iOS;
    }
    setState(() {

      account.clear();
      containerItems.clear();
      try {
        getAccountList();
        getContainerList();
      } catch (e) {
        confirmationPopup(context, "An error Occurred.Try again later!");
      }
    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    setState(() {
      try {
        getAmounts();
        getAccountList();
        getContainerList();
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
      EasyLoading.dismiss();
      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);

      setState(() {
        account.clear();

        body.forEach((item) {
          print(item);
          account.add(AccountModel.fromJson(item));
          _isChecked = List<bool>.filled(account.length, false);
        });
      });
    } else {
      EasyLoading.dismiss();

      print(response.statusCode);
    }
  }

  Future<void> getContainerList() async {
    var url = Uri.parse('${Utils.baseUrl}getContainer');
    var response = await http
        .post(url, body: {"user_id": Utils.USER_ID.toString()}).timeout(
            const Duration(seconds: 30), onTimeout: () {
      EasyLoading.dismiss();
      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);

      setState(() {
        containerItems.clear();
        body.forEach((item) {
          print(item);
          containerItems.add(ContainerModel.fromJson(item));
        });
      });
    } else {
      EasyLoading.dismiss();

      print(response.statusCode);
    }
  }

  Future<void> getAmounts() async {
    var url = Uri.parse('${Utils.baseUrl}getTotalAmounts');
    var response = await http.post(url, body: {
      "user_id": Utils.USER_ID.toString(),
    }).timeout(const Duration(seconds: 30), onTimeout: () {
      EasyLoading.dismiss();
      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);
      setState(() {
        Purchase = body['totalPurchase'];
        Sale = body['totalSale'];
        Credit = body['totalCredit'];
        Debit = body['totalDebit'];
        Diff = body['totalDifference'];
        totalOtherExpense = body['totalOtherExpense'];
      });
    } else {
      EasyLoading.dismiss();

      print(response.statusCode);
    }
  }

  Future<void> getContainerDetail() async {
    var url = Uri.parse('${Utils.baseUrl}getContainerLeger');
    var response = await http.post(url, body: {
      "user_id": Utils.USER_ID.toString(),
      "container_id": containertitle
    }).timeout(const Duration(seconds: 30), onTimeout: () {
      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      bl.close();
      print(response.body);
      dynamic body = jsonDecode(response.body);
      setState(() {
        URL = body['url'];
      });

      _permissionReady = await _checkPermission();
      print(URL);
      Navigator.pop(context);
      if (_permissionReady) {
        await _prepareSaveDir();
        print("Downloading");
        try {
          String fileName = URL.substring(URL.lastIndexOf("/") + 1);
          await Dio().download(URL, _localPath + "/" + fileName);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'successfully saved to internal storage' + _localPath,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
          print("Download Completed.");
        } catch (e) {
          print("Download Failed.\n\n" + e.toString());
        }
      }
    } else {
      EasyLoading.dismiss();

      print(response.statusCode);
    }
  }
  Future<void> getAccountSummary() async {
    var url = Uri.parse('${Utils.baseUrl}getAccountSummary');
    var response = await http.post(url, body: {
      "user_id": Utils.USER_ID.toString(),
      "account_id": userChecked.toString(),
    }).timeout(const Duration(seconds: 30), onTimeout: () {
      bl.close();
      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      bl.close();
      print(response.body);
      dynamic body = jsonDecode(response.body);
      setState(() {
        URL = body['pdf'];
      });

      _permissionReady = await _checkPermission();
      print(URL);
      Navigator.pop(context);
      if (_permissionReady) {
        await _prepareSaveDir();
        print("Downloading");
        try {
          String fileName = URL.substring(URL.lastIndexOf("/") + 1);
          await Dio().download(URL, _localPath + "/" + fileName);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'successfully saved to internal storage' + _localPath,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
          print("Download Completed.");
        } catch (e) {
          print("Download Failed.\n\n" + e.toString());
        }
      }
    } else {
      EasyLoading.dismiss();

      print(response.statusCode);
    }
  }
  Future<void> getContainerSummary() async {
    var url = Uri.parse('${Utils.baseUrl}getContainerSummaryLeger');
    var response = await http.post(url, body: {
      "user_id": Utils.USER_ID.toString(),
      "container_id": userChecked.toString(),
    }).timeout(const Duration(seconds: 30), onTimeout: () {
      bl.close();
      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      bl.close();
      print(response.body);
      dynamic body = jsonDecode(response.body);
      setState(() {
        URL = body['url'];
      });

      _permissionReady = await _checkPermission();
      print(URL);
      Navigator.pop(context);
      if (_permissionReady) {
        await _prepareSaveDir();
        print("Downloading");
        try {
          String fileName = URL.substring(URL.lastIndexOf("/") + 1);
          await Dio().download(URL, _localPath + "/" + fileName);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'successfully saved to internal storage' + _localPath,
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
          print("Download Completed.");
        } catch (e) {
          print("Download Failed.\n\n" + e.toString());
        }
      }
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
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            icon: Image.asset(
              'assets/images/menuicon.png',
              color: MyColors.whiteColor,
              scale: 2,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
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
      body: SingleChildScrollView(
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
                      side: BorderSide(color: MyColors.nocolor, width: 1.0)),
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
                                      input: Debit.toString(),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Constants.AccountScreen)
                          .then((value) => initState());
                    },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(color: MyColors.gray, width: 1.0)),
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
                    onTap: () {
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
                            side: BorderSide(color: MyColors.blue, width: 1.0)),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Constants.PaymentScreen)
                          .then((value) => initState());
                    },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(color: MyColors.blue, width: 1.0)),
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
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Constants.recieptScreen)
                          .then((value) => initState());
                    },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(color: MyColors.gray, width: 1.0)),
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
                    onTap: () {
                      Navigator.pushNamed(context, Constants.jVScreen)
                          .then((value) => initState());
                    },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(color: MyColors.gray, width: 1.0)),
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
                    onTap: () {
                      Navigator.pushNamed(context, Constants.purchaseScreen)
                          .then((value) => initState());
                    },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(color: MyColors.gray, width: 1.0)),
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
                    onTap: () {
                      Navigator.pushNamed(context, Constants.saleScreen)
                          .then((value) => initState());
                    },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(color: MyColors.gray, width: 1.0)),
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
                    onTap: () {
                      Navigator.pushNamed(context, Constants.itemScreen)
                          .then((value) => initState());
                    },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(color: MyColors.gray, width: 1.0)),
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
                    onTap: () {
                      Navigator.pushNamed(context, Constants.containerScreen)
                          .then((value) => initState());
                    },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(color: MyColors.blue, width: 1.0)),
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
                  GestureDetector(
                    onTap:(){
                      setState(() {
                        userChecked.clear();
                      });
                      ContainerSummaryPopUp(context);
      },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(color: MyColors.gray, width: 1.0)),
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
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        userChecked.clear();
                      });
                      AccountPopUp(context);
                    },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(color: MyColors.blue, width: 1.0)),
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
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, Constants.viewOtherexpenses)
                          .then((value) => initState());
                    },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.gray,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(color: MyColors.gray, width: 1.0)),
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
                  GestureDetector(
                    onTap: () {
                      selectContainerPopUp(context);
                    },
                    child: SizedBox(
                      height: 150,
                      width: 120,
                      child: Card(
                        color: MyColors.blue,
                        elevation: 25,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2.0),
                            side: BorderSide(color: MyColors.blue, width: 1.0)),
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
                                  input: "Details",
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
                    child: Card(
                      color: MyColors.blue,
                      elevation: 25,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                          side: BorderSide(color: MyColors.blue, width: 1.0)),
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
        barrierLabel: "hello",
        builder: (context) {
          return AlertDialog(
            title: const Text('Choose Account'),
            content: Form(
              key: PayKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: MyColors.views_btn,
                          contentPadding: const EdgeInsets.all(10),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.0, style: BorderStyle.none),
                            borderRadius:
                                BorderRadius.all(Radius.circular(13.0)),
                          ),
                        ),
                        iconSize: 20,
                        hint: const Text("Select A/C Title"),
                        iconEnabledColor: MyColors.blue,
                        validator: (value) =>
                            value == null ? 'Choose Account Title' : null,
                        style: TextStyle(
                            color: MyColors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        isDense: true,
                        items: account.map((item) {
                          return DropdownMenuItem(
                            value: item.AccountId.toString(),
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
                            title = newValue
                                ?.substring(newValue.lastIndexOf("/") + 1);
                          });
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      TextWidget(
                        input: "Start Date",
                        fontsize: 16,
                        fontWeight: FontWeight.normal,
                        textcolor: MyColors.blackColor8,
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: FromController,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            await selectFromDate(context);
                            FromController.text =
                                DateFormat('dd-MM-yyyy').format(openingdate);
                          },
                          onChanged: (String value) {
                            OpeningDate = value;
                          },
                          style: TextStyle(color: MyColors.blue),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                "${openingdate.day}-${openingdate.month}-${openingdate.year}",
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
                        input: "End Date",
                        fontsize: 16,
                        fontWeight: FontWeight.normal,
                        textcolor: MyColors.blackColor8,
                      ),
                      SizedBox(
                        width: 100,
                        child: TextField(
                          controller: ToController,
                          onTap: () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            await selectToDate(context);
                            ToController.text =
                                DateFormat('dd-MM-yyyy').format(closingdate);
                          },
                          onChanged: (String value) {
                            ClosingDate = value;
                          },
                          style: TextStyle(color: MyColors.blue),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText:
                                "${closingdate.day}-${closingdate.month}-${closingdate.year}",
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    print("helloo");
                  });
                  Navigator.pop(context);
                },
                child: TextWidget(
                  input: "CANCEL",
                  fontsize: 16,
                  fontWeight: FontWeight.bold,
                  textcolor: MyColors.blackColor8,
                ),
              ),
              GestureDetector(
                onTap: () {
                  final form = PayKey.currentState;
                  form!.save();
                  if (form.validate()) {
                    bl.display();

                    if (OpeningDate.isEmpty) {
                      setState(() {
                        DateFormat formatter = DateFormat('yyyy-MM-dd');
                        OpeningDate = formatter.format(openingdate).toString();

                      });
                    }
                    if (ClosingDate.isEmpty) {
                      setState(() {
                        DateFormat formatter = DateFormat('yyyy-MM-dd');

                        ClosingDate = formatter.format(closingdate).toString();

                      });
                    }
                    bl.close();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LedgerScreen(),
                        settings: RouteSettings(
                          arguments: {
                            "id": title,
                            "account name": "test",
                            "from date": OpeningDate,
                            "to date": ClosingDate,
                          },
                        ),
                      ),
                    ).then((value) {
                      bl.close();
                    });
                  }
                },
                child: TextWidget(
                  input: "SHOW",
                  fontsize: 16,
                  fontWeight: FontWeight.bold,
                  textcolor: MyColors.blackColor8,
                ),
              ),
            ],
          );
        });
  }

  Future<void> selectContainerPopUp(BuildContext context) async {
    return showDialog(
        context: context,
        barrierLabel: "hello",
        builder: (context) {
          return AlertDialog(
            title: const Text('Choose Container'),
            content: Form(
              key: ContKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: MyColors.views_btn,
                          contentPadding: const EdgeInsets.all(10),
                          border: const OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 0.0, style: BorderStyle.none),
                            borderRadius:
                                BorderRadius.all(Radius.circular(13.0)),
                          ),
                        ),
                        iconSize: 20,
                        hint: const Text("Select Container"),
                        iconEnabledColor: MyColors.blue,
                        validator: (value) =>
                            value == null ? 'Choose Container' : null,
                        style: TextStyle(
                            color: MyColors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                        isDense: true,
                        items: containerItems.map((item) {
                          return DropdownMenuItem(
                            value: item.conatinerId.toString(),
                            child: Text(
                              item.ContainerName.toString(),
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            containertitle = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: TextWidget(
                  input: "CANCEL",
                  fontsize: 16,
                  fontWeight: FontWeight.bold,
                  textcolor: MyColors.blackColor8,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  final form = ContKey.currentState;
                  form!.save();
                  if (form.validate()) {
                    bl.display();
                    getContainerDetail();
                  }
                },
                child: TextWidget(
                  input: "SHOW",
                  fontsize: 16,
                  fontWeight: FontWeight.bold,
                  textcolor: MyColors.blackColor8,
                ),
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
    } else {
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
    } else {
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

  Future<void> AccountPopUp(BuildContext context) async {
    return showDialog(
        context: context,
        barrierLabel: "PopUp",
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState){
            return AlertDialog(
              title: const Text('Choose Account'),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: account.length,
                  addRepaintBoundaries: true,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    AccountModel accountmodle = account[index];

                    return ListTile(
                        title: Text(accountmodle.Title.toString()),
                        leading: Checkbox(
                          value: userChecked.contains(accountmodle.AccountId),
                          onChanged: (val) {
                            setState(() {
                              _onSelected(val!, accountmodle.AccountId.toString());
                            });

                          },
                        )
                        //you can use checkboxlistTile too
                        );
                  },
                ),
              ),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print("helloo");
                    });
                    Navigator.pop(context);
                  },
                  child: TextWidget(
                    input: "CANCEL",
                    fontsize: 16,
                    fontWeight: FontWeight.bold,
                    textcolor: MyColors.blackColor8,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print(userChecked.toString());
                    if(userChecked.isNotEmpty){
                      bl.display();
                      getAccountSummary();


                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Select Account',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                  child: TextWidget(
                    input: "SHOW",
                    fontsize: 16,
                    fontWeight: FontWeight.bold,
                    textcolor: MyColors.blackColor8,
                  ),
                ),
              ],
            );},
          );
        });
  }
  Future<void> ContainerSummaryPopUp(BuildContext context) async {
    return showDialog(
        context: context,
        barrierLabel: "Summary PopUp",
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState){
            return AlertDialog(
              title: const Text('Choose Containers'),
              content: Container(
                width: double.maxFinite,
                child: ListView.builder(
                  itemCount: containerItems.length,
                  addRepaintBoundaries: true,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    ContainerModel accountmodle = containerItems[index];

                    return ListTile(
                        title: Text(accountmodle.ContainerName.toString()),
                        leading: Checkbox(
                          value: userChecked.contains(accountmodle.conatinerId),
                          onChanged: (val) {
                            setState(() {
                              _onSelected(val!, accountmodle.conatinerId.toString());
                            });

                          },
                        )
                        //you can use checkboxlistTile too
                        );
                  },
                ),
              ),
              actions: <Widget>[
                GestureDetector(
                  onTap: () {
                    setState(() {
                      print("helloo");
                    });
                    Navigator.pop(context);
                  },
                  child: TextWidget(
                    input: "CANCEL",
                    fontsize: 16,
                    fontWeight: FontWeight.bold,
                    textcolor: MyColors.blackColor8,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print(userChecked.toString());
                    if(userChecked.isNotEmpty){
                      bl.display();
                      getContainerSummary();



                    }else{
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Select Container',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }
                  },
                  child: TextWidget(
                    input: "SHOW",
                    fontsize: 16,
                    fontWeight: FontWeight.bold,
                    textcolor: MyColors.blackColor8,
                  ),
                ),
              ],
            );},
          );
        });
  }

  void _onSelected(bool selected, String dataName) {
    if (selected == true) {
      setState(() {
        userChecked.add(dataName);
      });
    } else {
      setState(() {
        userChecked.remove(dataName);
      });
    }
  }
}
