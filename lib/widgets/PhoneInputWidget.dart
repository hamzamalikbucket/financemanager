import 'package:flutter/material.dart';

import '../MyColors.dart';



class PhoneInputWidget extends StatelessWidget {
  String title;
  late Color hintcolour;
  bool isPassword = false;
  bool validate = true;
  TextInputType keyboardType = TextInputType.text;
  ValueChanged<String?> value;
  bool isRequired = false;
  String? error;
  int? maxlength;

  PhoneInputWidget(
      {Key? key,
      required this.title,
      required this.isRequired,
      required this.keyboardType,
      required this.value,
      this.error,
        this.maxlength,
      required this.validate,
      required this.isPassword,
      required this.hintcolour})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isPassword,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      maxLength: maxlength,
      decoration: InputDecoration(
          filled: true,
          fillColor: MyColors.whiteColor,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: const BorderSide(
                color: Colors.white,
              )),
          hintText: title,
          alignLabelWithHint: true,





          /*  labelText: title,*/
          hintStyle: TextStyle(color: hintcolour)),
      validator: (value) {
        if (validate && value!.length < 10) {
          return ;
        }
      },
      onSaved: value,
    );
  }
}
