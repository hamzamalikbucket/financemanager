import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return
      Container(
      // padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.horizontal(left: Radius.zero,right:Radius.zero),
          color: Colors.grey[300],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child:
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.search,color: Colors.grey,),
              Expanded(
                child: TextField(
                  textAlign: TextAlign.center,
                  decoration: InputDecoration.collapsed(
                    hintText: ' Search',
                  ),
                  onChanged: (value) {

                  },
                ),
              ),
            ],
          ),
        )
    );
  }
  
}