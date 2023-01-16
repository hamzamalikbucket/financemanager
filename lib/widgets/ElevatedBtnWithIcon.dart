import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ELevatedBtnWithIcon extends StatelessWidget{
  String title;
  Color bgcolour;
  Color textcolour;
  late ValueChanged<String> value;
  late VoidCallback onPress;
  late double width;
  late double height;


  ELevatedBtnWithIcon({Key? key, required this.title,required this.bgcolour,required this.textcolour, required this.onPress,})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton.icon(
        onPressed: ()=> onPress(),
        icon: Image.asset('assets/images/icon_small_x.png'),
        label:Image.asset('assets/images/icon_small_x.png'),



      ),
    );
  }


}