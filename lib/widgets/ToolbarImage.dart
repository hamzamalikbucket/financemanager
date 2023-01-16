import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../MyColors.dart';

class ToolbarImage extends StatelessWidget implements PreferredSizeWidget{
  final AppBar appBar;
  const ToolbarImage({Key? key,required this.appBar})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return (
        AppBar(
          automaticallyImplyLeading: true,

          backgroundColor: MyColors.whiteColor,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                height: 50,
              ),

            ],
          ),
          iconTheme: IconThemeData(
            color: MyColors.darkgreenColor,

            //change your color here
          ),
        ));
  }

  @override
  Size get preferredSize => new Size.fromHeight(appBar.preferredSize.height);


}