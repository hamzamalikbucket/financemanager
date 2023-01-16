

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:financemanager/MyColors.dart';

class BtnImg extends StatelessWidget {
  late String title;
  late String ImagePath;
  late Color bgcolour;
  late Color textcolour;
  late ValueChanged<String> value;
  late VoidCallback onPress;

  BtnImg({
    Key? key,
    required this.title,
    required this.bgcolour,
    required this.textcolour,
    required this.onPress,
    required this.ImagePath,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 48,
      child: ElevatedButton(
        onPressed: () => onPress(),
        style: ElevatedButton.styleFrom(
            backgroundColor: bgcolour,
            foregroundColor: bgcolour,
            disabledForegroundColor: bgcolour,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
                side: BorderSide(color: bgcolour, width: 2.0))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              ImagePath,
              width: 50,
              height: 50,
            ),
            Text(
              title,
              style: TextStyle(
                color: textcolour,
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
