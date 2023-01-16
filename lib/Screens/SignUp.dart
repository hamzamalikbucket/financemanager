
import 'package:bottom_loader/bottom_loader.dart';
import 'package:financemanager/Screens/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../MyColors.dart';
import '../Utils.dart';
import '../widgets/BtnNullHeightWidth.dart';
import '../widgets/EmailInputWidget.dart';
import '../widgets/NameInputWidget.dart';
import '../widgets/TextWidget.dart';
import '../widgets/Toolbar.dart';
import 'package:http/http.dart'as http;
import 'dart:convert';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignUpState();
  }
}

class SignUpState extends State<SignUp> {
  final GlobalKey<FormState> signUpKey = GlobalKey<FormState>();
  late String email, pass,conPass,name;
  late BottomLoader bl;
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(Utils.APP_PADDING),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',

                            ),
                            TextWidget(
                                input: "Enter credentials to create an account",
                                fontsize: 17,
                                fontWeight: FontWeight.w500,
                                textcolor: MyColors.black),
                          ],
                        ),
                      ),

                      SizedBox(child: form(context)),
                      Utils.FORM_HINT_PADDING,
                      Utils.FORM_HINT_PADDING,


                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget form(BuildContext context) {
    return Form(
        key: signUpKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            NameInputWidget(
                title: "Name",
                error: "Enter Your name",
                isRequired: true,
                icon: Icons.person,
                keyboardType: TextInputType.text,
                value: (val) {
                  name = val!;
                },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: false,
                hintcolour: MyColors.whiteColor),
            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            EmailInputWidget(
                title: "Email",
                error: "Enter Valid Email",
                isRequired: true,
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
                value: (val) {
                  email = val!;
                },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: false,
                hintcolour: MyColors.whiteColor),
            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            NameInputWidget(
                title: "Password",
                error: "Enter Your Password",
                isRequired: true,
                icon: Icons.lock,
                keyboardType: TextInputType.text,
                value: (val) {
                  pass = val!;
                },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: true,
                hintcolour: MyColors.whiteColor),
            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,


            BtnNullHeightWidth(
              title: "SignUp",
              bgcolour: MyColors.blue,
              textcolour: MyColors.whiteColor,
              onPress: () {
                //(is_teacher)?Navigator.pushReplacementNamed(context, Constants.signup_page),
                final form = signUpKey.currentState;
                form!.save();
                if (form.validate()) {
                  bl.display();

                  try{
                    signup();
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextWidget(
                    input: "Already have an account?",
                    fontsize: 15,
                    fontWeight: FontWeight.w500,
                    textcolor: MyColors.black),
                GestureDetector(
                  onTap: (){
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>Login(),
                      ),
                          (route) =>false,
                    );
                  },
                  child: TextWidget(
                      input: "Sign in",
                      fontsize: 15,
                      fontWeight: FontWeight.w500,
                      textcolor: MyColors.blue),
                ),
              ],
            ),
          ],
        ));
  }
  Future<dynamic> signup() async {
    String token;
    var url = Uri.parse(Utils.baseUrl +'register');
    var response = await http
        .post(
      url,
      body: {"email": email, "password": pass,"phone_number":"03008640090","name":name},

    )
        .timeout(const Duration(seconds: 10),onTimeout: (){
      bl.close();
      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      print(response.body);
      dynamic body = jsonDecode(response.body);
      dynamic status=body['status'];


        if(status=="sucess"){
          String message=body['message'];
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
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => Login(),
            ),
                (route) => false,
          );
        }
        else{
          String message=body['message'];
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
      dynamic body = jsonDecode(response.body);
      String error = body['message'];
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
