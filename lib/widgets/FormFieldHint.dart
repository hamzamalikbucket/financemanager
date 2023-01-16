import 'package:flutter/material.dart';

import '../MyColors.dart';

class FromFieldHint extends StatelessWidget {
  String hint;

  FromFieldHint({Key? key, required this.hint}):
      super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:15.0),
      child: Text(hint,
        style: TextStyle(
          fontSize: 12,
          color: MyColors.blackColor48,
        ),
      ),
    );
  }
}
