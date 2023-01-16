import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BtnDefinedWidth extends StatelessWidget{
  late String title;
  late Color bgcolour;
  late Color textcolour;
  late ValueChanged<String> value;
  late VoidCallback onPress;
  late double width;


  BtnDefinedWidth({Key? key, required this.title,required this.bgcolour,required this.textcolour, required this.onPress,required this.width})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      width:width ,
      height: 45,
      child: ElevatedButton(
        onPressed: ()=> onPress(),
        style:ElevatedButton.styleFrom(
            onSurface: bgcolour,
            primary: bgcolour,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color: bgcolour, width:2.0))
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textcolour, fontSize: 18, fontWeight: FontWeight.bold,fontFamily:'HK Grostesk',),
        ),
      ),
    );
  }


}