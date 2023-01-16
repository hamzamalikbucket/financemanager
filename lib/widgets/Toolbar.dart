import 'dart:io';

import 'package:flutter/material.dart';

import '../MyColors.dart';
import 'TextWidget.dart';

class ToolbarBack extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final AppBar appBar;

  const ToolbarBack({Key? key, required this.title,required  this.appBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return (
        AppBar(
//`true` if you want Flutter to automatically add Back Button when needed,
          automaticallyImplyLeading: true,
            centerTitle: true,
          title:Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextWidget(
                  input: title,
                  fontsize: 16,
                  fontWeight: FontWeight.normal,
                  textcolor: MyColors.whiteColor),





            ],
          ),
          iconTheme: IconThemeData(
            color: MyColors.whiteColor,

            //change your color here
          ),
        ));
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);
}
