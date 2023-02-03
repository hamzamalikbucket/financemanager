import 'package:financemanager/Models/ContainerModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Utils.dart';
import 'package:financemanager/widgets/BtnNullHeightWidth.dart';
import 'package:financemanager/widgets/NameInputWidget.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:financemanager/widgets/Toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../Constants.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';
import 'package:bottom_loader/bottom_loader.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddOtherExpenseScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddExpensesState();
  }


}
class AddExpensesState extends State<AddOtherExpenseScreen>{
  final GlobalKey<FormState> AddKey = GlobalKey<FormState>();
  late BottomLoader bl;
  late String Title, amount;
  TextEditingController FromController = TextEditingController();



  @override
  void initState() {
    super.initState();
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

    return Scaffold(

      appBar: ToolbarBack(appBar: AppBar(), title:"Add Other Expenses",),
      body: SafeArea(

        child: Padding(
          padding: const EdgeInsets.all(Utils.APP_PADDING),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
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
        key: AddKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NameInputWidget(
                title: "Description",
                error: "Enter Description",
                isRequired: true,
                icon: Icons.title,
                keyboardType: TextInputType.text,
                value: (val) {
                  Title = val!;
                },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: false,
                hintcolour: MyColors.whiteColor),
            NameInputWidget(
                title: "Amount",
                error: "Enter Amount",
                isRequired: true,
                icon: Icons.add,
                keyboardType: TextInputType.number,
                value: (val) {
                  amount = val!;
                },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: false,
                hintcolour: MyColors.whiteColor),
            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,




            BtnNullHeightWidth(
              title: "Save",
              bgcolour: MyColors.blue,
              textcolour: MyColors.whiteColor,
              onPress: () {

                final form = AddKey.currentState;
                form!.save();
                if (form.validate()) {
                  bl.display();


                  try{
                    addItem();
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

  Future<dynamic> addItem() async {
    var url = Uri.parse('${Utils.baseUrl}addOtherExpense');
    var response = await http
        .post(
      url,
      body: {"user_id":Utils.USER_ID.toString(),"description":Title.toString(),"amount":amount},

    )
        .timeout(const Duration(seconds: 60),onTimeout: (){
      bl.close();
      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      print(response.body);
      dynamic body = jsonDecode(response.body);
      String status=body['status'];

      if(status=="sucess"){
        String message=body['message'];

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
            msg: "An Error occurred ",
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