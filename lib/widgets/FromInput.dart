import 'package:flutter/material.dart';

import '../MyColors.dart';
import 'package:fluttertoast/fluttertoast.dart';


class FromInput extends StatelessWidget {
  String title;
  late Color hintcolour;
  bool isPassword = false;

  bool validate = true;
  TextInputType keyboardType = TextInputType.text;
  ValueChanged<String?> value;
  bool isRequired = false;
  String? error;
  TextEditingController? controller;
  VoidCallback? onmainIconTap,onChangesIConTap;

  double width;
  IconData? mainicon;
  int?maxlength;



  FromInput(
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
        this.maxlength,
        this.mainicon,
        this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(color:hintcolour),
      controller: controller,
      obscureText: isPassword,
      textInputAction: TextInputAction.done,
      keyboardType: keyboardType,
      maxLength: maxlength,
      decoration: InputDecoration(
        fillColor: MyColors.whiteColor,
          filled: true,

          suffixIcon: GestureDetector(
            onTap:() {


            },
            child: Icon(
              mainicon,
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
        if (validate && value!.length<8) {
        return error;



        }
      },
      onSaved: value,
    );
  }
}
