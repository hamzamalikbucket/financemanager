import 'dart:ui';

import 'package:flutter/material.dart';

import '../MyColors.dart';
import 'package:fluttertoast/fluttertoast.dart';


class NameInputWidget extends StatelessWidget {
  String title;
  late Color hintcolour;
  Color? errorcolor;
  bool isPassword = false;



  bool validate = true;
  TextInputType keyboardType = TextInputType.text;
  ValueChanged<String?> value;
  ValueChanged<String?>? changevalue;

  bool isRequired = false;
  String? error;
  TextEditingController? controller;

  double width;
  IconData? icon;
  String? initialval;
  bool? isenabled=true;


  NameInputWidget(
      {Key? key,
        required this.title,
        required this.isRequired,
        required this.keyboardType,
        required this.value,
        required this.width,
        required this.validate,
        required this.isPassword,
        required this.hintcolour,
        this.error,
        this.errorcolor,
        this.icon,
        this.controller,
        this.initialval,
        this.isenabled,
        this.changevalue

     })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      showCursor: true,
      initialValue: initialval,
      enabled: isenabled,

      controller: controller,
      obscureText: isPassword,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      style: TextStyle(color:MyColors.blue),



      decoration: InputDecoration(


          prefixIcon: Icon(
            icon,

            color:MyColors.blue,
          ),

          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: MyColors.blue),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: MyColors.blue),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: MyColors.blue),
          ),
          hintText: title,
          labelText: title,
          labelStyle:TextStyle(color: MyColors.blue) ,
          hintStyle: TextStyle(color: MyColors.gray),


          errorStyle: TextStyle(
            color:errorcolor,
          ),
),
      validator: (value) {
        if (validate && value!.length<1) {
          return error;



        }
      },
      onSaved: value,
      onChanged: changevalue,

    );
  }
}