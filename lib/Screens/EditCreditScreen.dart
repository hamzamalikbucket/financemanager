import 'dart:convert';

import 'package:bottom_loader/bottom_loader.dart';
import 'package:financemanager/Models/AccountModel.dart';
import 'package:financemanager/Models/PaymentModel.dart';
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
import 'package:http/http.dart'as http;
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Constants.dart';
import '../Models/RecieptModel.dart';

class EditCreditScreen extends StatefulWidget{
  const EditCreditScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditPayState();
  }


}
class EditPayState extends State<EditCreditScreen>{
  final GlobalKey<FormState> edtPayKey = GlobalKey<FormState>();

  late String  Amount,Desc,Date;
  TextEditingController FromController = TextEditingController();
  DateTime openingDate = DateTime.now();
  String openingDateString="";
  var title;
  late BottomLoader bl;

  late RecieptModel recpmodel;

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









  }

  @override
  Widget build(BuildContext context) {
    recpmodel= ModalRoute.of(context)!.settings.arguments as RecieptModel;
    setState(() {
      title=recpmodel.AccountId;
    });

    return Scaffold(

      appBar: ToolbarBack(appBar: AppBar(), title: recpmodel.AccountTitle,),
      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(Utils.APP_PADDING),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              form(context),



            ],
          ),
        ),
      ),
    );
  }
  Widget form(BuildContext context) {
    return Form(
        key: edtPayKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NameInputWidget(
                initialval: recpmodel.AccountTitle,
                title: "Account",
                error: "Enter account",
                isRequired: true,
                isenabled: false,
                icon: Icons.payment,
                keyboardType: TextInputType.text,
                value: (val) {

                },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: false,
                hintcolour: MyColors.whiteColor),

            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            NameInputWidget(
                initialval: recpmodel.Amount,
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
                initialval: recpmodel.Description,
                title: "Description",
                error: "Enter Desc",
                isRequired: false,
                icon: Icons.description,
                keyboardType: TextInputType.text,
                value: (val) {

                  Desc = val!;
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
                      await selectfromdate(context);
                      FromController.text = DateFormat('dd-MM-yyyy').format(openingDate);
                    },
                    onChanged: (String value){
                      openingDateString=value;
                    },

                    decoration:InputDecoration(
                      border: InputBorder.none,
                      hintText:openingDate.day.toString()+"-"+openingDate.month.toString()+"-"+openingDate.year.toString(),
                      hintStyle: TextStyle(color: MyColors.blue),


                    ),
                  ),
                ),

              ],
            ),
            Utils.FORM_HINT_PADDING,


            BtnNullHeightWidth(
              title: "Update",
              bgcolour: MyColors.blue,
              textcolour: MyColors.whiteColor,
              onPress: () {
                //(is_teacher)?Navigator.pushReplacementNamed(context, Constants.signup_page),
                final form = edtPayKey.currentState;
                form!.save();
                if (form.validate()) {
                  print(title);
                  bl.display();
                  if(Desc.isEmpty){
                    setState(() {
                      Desc=" no description Added";
                    });
                  }
                  if(openingDateString.isEmpty){
                    setState(() {
                      DateFormat formatter = DateFormat('dd-MM-yyyy');
                      openingDateString = formatter.format(openingDate).toString();

                    });

                  }
                  print(openingDateString);
                  print(Desc);


                  try{
                    editPayment();
                  }catch (e){
                    bl.close();
                    confirmationPopup(context, "An error Occurred.Try again later!");
                  }



                }
              },
              width: MediaQuery.of(context).size.width,
              height: 48,
            ),
            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,

          ],
        ));
  }
  Future<void> selectfromdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: openingDate,
        firstDate: DateTime(2000, 8),
        lastDate: DateTime(2500));
    if (picked != null && picked != openingDate) {
      setState(() {
        openingDate = picked;
        DateFormat formatter = DateFormat('dd-MM-yyyy');
        openingDateString = formatter.format(openingDate);


      });
    }

  }
  Future<dynamic> editPayment() async {
    var url = Uri.parse('${Utils.baseUrl}editReciept');
    var response = await http
        .post(
      url,
      body: {"account_id": title, "amount": Amount,"description":Desc,"op_date":openingDateString,"user_id":Utils.USER_ID,"id":recpmodel.ReceiptId},

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
      if(status=="sucess"){

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
    ;
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