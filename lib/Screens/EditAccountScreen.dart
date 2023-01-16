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

import '../Models/AccountModel.dart';

class EditAccountScreen extends StatefulWidget{
  const EditAccountScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return EditState();
  }


}
class EditState extends State<EditAccountScreen>{
  final GlobalKey<FormState> editFormKey = GlobalKey<FormState>();
  late BottomLoader bl;
  late String Title, balance,Phone,Date;
  TextEditingController FromController = TextEditingController();
  DateTime openingdate = DateTime.now();
  String OpeningDate="";
  TextEditingController? titleController;
  TextEditingController phoneController=TextEditingController();
  TextEditingController balanceController=TextEditingController();
  late AccountModel accountModel;

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
    accountModel= ModalRoute.of(context)!.settings.arguments as AccountModel;


    return Scaffold(

      appBar: ToolbarBack(appBar: AppBar(), title: accountModel.Title!,),
      body: SafeArea(

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Utils.APP_PADDING),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
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
    phoneController.text=accountModel.PhoneNumber!;
    return Form(
        key: editFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NameInputWidget(
                title: "Title",
                error: "Enter Account Title",
                isRequired: true,
                initialval: accountModel.Title!,
                icon: Icons.title,
                keyboardType: TextInputType.text,
                value: (val) {
                  Title = val!;
                },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: false,
                hintcolour: MyColors.whiteColor),
            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            NameInputWidget(
                title: "Opening balance",
                error: "Enter Opening balance",
                isRequired: true,
               initialval: accountModel.OpeningBalance!,
                icon: Icons.account_balance,
                keyboardType: TextInputType.text,
                value: (val) {
                  balance = val!;
                },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: false,
                hintcolour: MyColors.whiteColor),

            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            NameInputWidget(
                title: "Phone",
                error: "Enter Phone Number",
                isRequired: false,
                icon: Icons.phone,
               initialval: accountModel.PhoneNumber!,
                keyboardType: TextInputType.text,
                value: (val) {
                  Phone = val!;
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
                    controller: FromController,
                    onTap: () async{
                      FocusScope.of(context).requestFocus(new FocusNode());
                      await selectfromdate(context);
                      FromController.text = DateFormat('yyyy-MM-dd').format(openingdate);
                    },
                    onChanged: (String value){
                      OpeningDate=value;
                    },
                    style:TextStyle(color: MyColors.blue) ,

                    decoration:InputDecoration(
                      border: InputBorder.none,
                      hintText:openingdate.year.toString()+"-"+openingdate.month.toString()+"-"+openingdate.day.toString(),
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

                final form = editFormKey.currentState;
                form!.save();
                if (form.validate()) {
                  bl.display();
                  if(Phone.isEmpty){
                    setState(() {
                      Phone="0";
                    });
                  }
                  if(OpeningDate.isEmpty){
                    setState(() {
                      DateFormat formatter = DateFormat('dd-MM-yyyy');
                      OpeningDate = formatter.format(openingdate);

                    });

                  }

                  try{
                    editAccountApi();
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

  }
  Future<dynamic> editAccountApi() async {
    var url = Uri.parse(Utils.baseUrl +'editAccount');
    var response = await http
        .post(
      url,
      body: {"gid": Utils.USER_ID, "title": Title,"balance":balance,"op_date":OpeningDate.toString(),"phone":Phone,"id":accountModel.AccountId},

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