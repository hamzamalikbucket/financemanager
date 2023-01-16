import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

import '../MyColors.dart';


class PasswordInputWidget extends StatelessWidget {
  String title;
  late Color hintcolour;
  bool isPassword = false;

  bool validate = true;
  TextInputType keyboardType = TextInputType.text;
  ValueChanged<String?> value;
  bool isRequired = false;
  String? error;
  TextEditingController? controller;

  double width;
  IconData? icon;


  PasswordInputWidget(
      {Key? key,
        required this.title,
        required this.isRequired,
        required this.keyboardType,
        required this.value,
        required this.width,
        required this.validate,
        required this.isPassword,
        required this.hintcolour,
        this.icon,
        this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Theme(
            data: ThemeData(

            ),

            child: Container(
              width: width,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                color: MyColors.whiteColor,
                borderRadius: BorderRadius.circular(10.0),


              ),
              child: TextFormField(
                style: TextStyle(color:hintcolour),
                controller: controller,
                obscureText: isPassword,
                textInputAction: TextInputAction.done,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap:() {

                      },
                      child: Icon(
                        icon,
                        size: 30.0,
                        color:MyColors.blackColor24,
                      ),
                    ),

                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide(color: MyColors.blackColor24,)),
                    hintText: title,
                    alignLabelWithHint: true,
                    /* labelText: title,*/
                    hintStyle: TextStyle(color: hintcolour)),
                validator: (value) {
                  if (validate || value!.isEmpty) {
                    return'Enter' + title;



                  }
                },
                onSaved: value,
              ),
            ),
          )
        ],
      ),
    );
  }
}