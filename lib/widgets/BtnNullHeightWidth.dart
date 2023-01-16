import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class BtnNullHeightWidth extends StatelessWidget{
  String title;
  Color bgcolour;
  Color textcolour;
  late ValueChanged<String> value;
  late VoidCallback onPress;
  late double width;
  late double height;


  BtnNullHeightWidth({Key? key, required this.title,required this.bgcolour,required this.textcolour, required this.onPress,required this.width,required this.height})
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
                  borderRadius: BorderRadius.circular(24.0),
                  side: BorderSide(color: bgcolour, width:1.0))
        ),

        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textcolour, fontSize: 18, fontWeight: FontWeight.normal,),
        ),
      ),
    );
  }


}