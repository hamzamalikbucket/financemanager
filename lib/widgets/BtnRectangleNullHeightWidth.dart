import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../MyColors.dart';



class BtnRectangleNullHeightWidth extends StatelessWidget{
  String title;
  Color bgcolour;
  Color textcolour;
  late ValueChanged<String> value;
  late VoidCallback onPress;
  late double width;
  late double height;


  BtnRectangleNullHeightWidth({Key? key, required this.title,required this.bgcolour,required this.textcolour, required this.onPress,required this.width,required this.height})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(

      width: width,
     height: height,
      child: ElevatedButton(
        onPressed: ()=> onPress(),
        style:ElevatedButton.styleFrom(
            onSurface: bgcolour,
            primary: bgcolour,
          shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  side: BorderSide(color: MyColors.blackColor48, width:2.0))
        ),

        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textcolour, fontSize: 20, fontWeight: FontWeight.bold,fontFamily:'HK Grostesk',),
        ),
      ),
    );
  }


}