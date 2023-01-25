import 'package:flutter/material.dart';

class MyColors{
  static Color primaryColor = colorFromHex("#005294");
  static Color black = colorFromHex("#000000");
  static Color orangeColor = colorFromHex('#FC832B');
  static Color gray = colorFromHex('#999999');
  static Color blue = colorFromHex('#4CAECF');

  static Color redColor = colorFromHex('#FF5050');
  static Color greenColor = colorFromHex('#bfdbd1');
  static Color darkgreenColor =colorFromHex('#039195');
  static Color yellowColor = colorFromHex('#fff985');

  static Color whiteColor = Colors.white;
  static Color nocolor = Colors.transparent;
  static Color blueColor = colorFromHex('#206382');
  static Color lightblueColor = colorFromHex('#57A3B461');
  static Color navyblue = colorFromHex('#072C50');
  static Color darkblueColor = colorFromHex('#3DB4EA');
  static Color blue_button_colour = colorFromHex('#57A3B4');
  static Color blue_button_toggle_color = colorFromHex('#57A3B461');
  static Color facebook_button_color = colorFromHex('#4460A0');
  static Color rating_btn = colorFromHex('#FFE8D4');

  static Color views_btn = colorFromHex('#E9E9E9');
  static Color views_text = colorFromHex('#8B8B8B');
  static Color rating_text_color = colorFromHex('#FF8921');
  static Color quantity_btn = colorFromHex('#D4F8FF');
  static Color quantity_text_color = colorFromHex('#44C3DB');
  static Color price_tag_color = colorFromHex('#AC1E1E');
  static Color blue_container_color = colorFromHex('#6DCADF');
  static Color bin_red_color = colorFromHex('#800000');
  static Color border_shade = colorFromHex('#B6B9B7');



  static Color blackColor = Colors.black;
  static Color blackColor80 = Colors.black87;
  static Color blackColor48 = Colors.black45;
  static Color blackColor24 = Colors.black26;
  static Color blackColor12 = Colors.black12;
  static Color blackColor8 = colorFromHex('#4F5152');
  static Color blackColor5 = colorFromHex('#161545');
  static Color blackColor4 = colorFromHex('#f5f5f5');
  static Color blackdim = colorFromHex('#00000099');
  static Color cardcolor = colorFromHex('#EEEFEF');
  static Color tabblack = colorFromHex('#606060');
  static Color conblack = colorFromHex('#2C2C2E');

  static Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));

  }


}