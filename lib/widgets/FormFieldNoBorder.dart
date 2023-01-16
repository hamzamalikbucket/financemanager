import 'package:flutter/material.dart';

import '../MyColors.dart';

class FormFieldNoBorder extends StatelessWidget {
  String title;
  late Color hintcolour;
  bool isPassword = false;
  bool validate = true;
  TextInputType keyboardType = TextInputType.text;
  ValueChanged<String?> value;
  bool isRequired = false;
  String? error;

  double width;


  FormFieldNoBorder(
      {Key? key,
        required this.title,
        required this.isRequired,
        required this.keyboardType,
        required this.value,
        required this.width,
        required this.validate,
        required this.isPassword,
        required this.hintcolour})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      textInputAction: TextInputAction.done,
      keyboardType: keyboardType,



      decoration: InputDecoration(
        hintText: title,
        fillColor: MyColors.whiteColor,
        filled: true,
        hintStyle: TextStyle(color: hintcolour,fontSize: 12),
        border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white,)),
          alignLabelWithHint: true,
          ),

      validator: (value) {
        if (validate && value!.isEmpty) {
          return 'Please enter ' + title;
        }
      },
      onSaved: value,
    );
  }
}
