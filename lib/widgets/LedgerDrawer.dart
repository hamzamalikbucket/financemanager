import 'package:financemanager/Utils.dart';
import 'package:flutter/material.dart';
import '../MyColors.dart';

import '../Constants.dart';

import '../main.dart';
import 'BtnNullHeightWidth.dart';
import 'TextWidget.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class LedgerDrawer extends StatelessWidget {
  const LedgerDrawer({super.key});


  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: MyColors.blue,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _createHeader(context),
            _createDrawerItem(
              icon: Image.asset("assets/images/earnings.png",color: MyColors.whiteColor),
              text: 'Credit',
              onTap: () {
                /*Navigator.pushNamed(context, Constants.homeScreen);
                */
              }

            ),

            _createDrawerItem(
              icon: Image.asset("assets/images/earnings.png",color: MyColors.whiteColor),
              text: 'Debit',
              onTap: () {
                 // Navigator.pushNamed(context, Constants.homeScreen);
              }
            ),

            _createDrawerItem(
              icon: Image.asset("assets/images/sellers.png",color: MyColors.whiteColor),
              text: 'Sale',
              onTap: () =>
                  {

                  }
            ),

            _createDrawerItem(
                icon: Image.asset("assets/images/order.png",color: MyColors.whiteColor),
                text: 'Purchase',
                onTap: (){



                }

            ),

          ],
        ),
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return Container(
      color: MyColors.whiteColor,
      child: DrawerHeader(
          child: Row(



              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',

                ),

              ])),
    );
  }

  Widget _createDrawerItem(
      {required Image icon,
        required String text,
        GestureTapCallback? onTap}) {
    return ListTile(
      title: Row(
        children: <Widget>[
          IconButton(
            icon:icon,




            onPressed:()=>{
              onTap
            },


          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              text,
              style: TextStyle(
                color: MyColors.whiteColor,
              ),
            ),
          )
        ],
      ),
      onTap: onTap,
    );
  }
  confirmationPopup(BuildContext dialogContext) {
    var alertStyle = AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(
        context: dialogContext,
        style: alertStyle,
        title: "This will head you",
        desc: "to login!!",
        buttons: [
          DialogButton(
            child: Text(
              "Confirm",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {

              Navigator.pushReplacementNamed(dialogContext, Constants.loginscreen);
            },
            color:MyColors.darkgreenColor,
          ),
          DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            color:MyColors.redColor,
          )
        ]).show();
  }

}
