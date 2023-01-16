import 'dart:convert';

import 'package:bottom_loader/bottom_loader.dart';
import 'package:financemanager/Models/AccountModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Utils.dart';
import 'package:financemanager/widgets/BtnNullHeightWidth.dart';
import 'package:financemanager/widgets/EmailInputWidget.dart';
import 'package:financemanager/widgets/NameInputWidget.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:financemanager/widgets/Toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;

class AddReceiptScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddRecState();
  }


}
class AddRecState extends State<AddReceiptScreen>{
  final GlobalKey<FormState> RecieptKey = GlobalKey<FormState>();
  late String Title, Amount,desc,Date;
  TextEditingController FromController = TextEditingController();
  DateTime openingdate = DateTime.now();
  String OpeningDate="";
  List<AccountModel>account=[];
  late BottomLoader bl;
  var title;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      appBar: ToolbarBack(appBar: AppBar(), title: 'New Receipt',),
      body: SafeArea(

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Utils.APP_PADDING),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/logo.png",


                ),
                form(context),



              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget form(BuildContext context) {
    return Form(
        key: RecieptKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(

              child: DropdownButtonHideUnderline(
                child:
                DropdownButtonFormField(
                  value: title,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.views_btn,
                    contentPadding: EdgeInsets.all(10),
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

            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            NameInputWidget(
                title: "Amount",
                error: "Enter amount",
                isRequired: true,
                icon: Icons.payment,
                keyboardType: TextInputType.text,
                value: (val) {
                  Amount = val!;
                },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: false,
                hintcolour: MyColors.whiteColor),

            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            NameInputWidget(
                title: "Description",
                error: "Enter Desc",
                isRequired: false,
                icon: Icons.description,
                keyboardType: TextInputType.text,
                value: (val) {
                  desc = val!;
                },
                width: MediaQuery.of(context).size.width,
                validate: false,
                isPassword: false,
                hintcolour: MyColors.whiteColor),

            Utils.FORM_HINT_PADDING,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(

                  input: "Date",
                  fontsize: 16,
                  fontWeight: FontWeight.normal,
                  textcolor: MyColors.blackColor8,
                ),
                Container(
                  width: 100,
                  child: TextField(
                    style: TextStyle(
                      color: MyColors.blue,
                    ),
                    controller: FromController,
                    onTap: () async{
                      FocusScope.of(context).requestFocus(new FocusNode());
                      await selectDateFunction(context);
                      FromController.text = DateFormat('dd-MM-yyyy').format(openingdate);
                    },
                    onChanged: (String value){
                      OpeningDate=value;
                    },

                    decoration:InputDecoration(
                      border: InputBorder.none,
                      hintText:"${openingdate.year}-${openingdate.month}-${openingdate.day}",
                      hintStyle: TextStyle(color: MyColors.blue),


                    ),
                  ),
                ),

              ],
            ),
            Utils.FORM_HINT_PADDING,


            BtnNullHeightWidth(
              title: "Save",
              bgcolour: MyColors.blue,
              textcolour: MyColors.whiteColor,
              onPress: () {

                final form = RecieptKey.currentState;
                form!.save();
                if (form.validate()) {
                  bl.display();
                  if(desc.isEmpty){
                    setState(() {
                      desc=" no description Added";
                    });
                  }
                  if(OpeningDate.isEmpty){
                    setState(() {
                      DateFormat formatter = DateFormat('dd-MM-yyyy');
                      OpeningDate = formatter.format(openingdate).toString();

                    });

                  }

                  try{
                    addPayment();
                  }catch (e){
                    bl.close();
                    confirmationPopup(context, "An error Occurred.Try again later!");
                  }


                }
              },
              width: MediaQuery.of(context).size.width,
              height: 48,
            ),


          ],
        ));
  }
  Future<dynamic> addPayment() async {
    var url = Uri.parse('${Utils.baseUrl}addReciept');
    var response = await http
        .post(
      url,
      body: {"account_id": title, "amount": Amount,"description":desc,"op_date":OpeningDate,"user_id":Utils.USER_ID},

    )
        .timeout(const Duration(seconds: 60),onTimeout: (){
      bl.close();
      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      print(response.body);
      dynamic body = jsonDecode(response.body);
      String status=body['status'];
      String message=body['message'];
      if(status=="success"){

        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor:MyColors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        );
        bl.close();
        Navigator.pop(context);
      }
      else{
        bl.close();
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor:MyColors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }



    } else {
      bl.close();
      print(response.body);

      String error = "Error Occurred";
      print(error);

      confirmationPopup(context, error);
    }
  }
  Future<void> selectDateFunction(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: openingdate,
        firstDate: DateTime(2000, 8),
        lastDate: DateTime(2500));
    if (picked != null && picked != openingdate) {
      setState(() {
        openingdate = picked;
        DateFormat formatter = DateFormat('dd-MM-yyyy');
        OpeningDate = formatter.format(openingdate);


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