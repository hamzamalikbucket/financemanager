import 'dart:convert';

import 'package:bottom_loader/bottom_loader.dart';
import 'package:financemanager/Constants.dart';
import 'package:financemanager/Models/AccountModel.dart';
import 'package:financemanager/Models/ItemModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Utils.dart';
import 'package:financemanager/widgets/BtnNullHeightWidth.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:financemanager/widgets/ToolbarImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class ItemScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ItemState();
  }


}
class ItemState extends State<ItemScreen>{
  List<ItemModel>items=[];
  late BottomLoader bl;


  @override
  void initState() {
    // TODO: implement initState

    EasyLoading.show(
        status: "Loading"

    );



    setState(() {


      try{
        getItemList();

      }catch (e){
        confirmationPopup(context, "An error Occurred.Try again later!");

      }

    });



  }
  Future<void> getItemList() async {

    var url = Uri.parse('${Utils.baseUrl}getItem');
    var response = await http.post(url,body:{"user_id":Utils.USER_ID.toString()}).timeout(const Duration(seconds: 30),onTimeout: (){

      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);


      setState(() {

        body.forEach((item){
          print(item);
          items.add(ItemModel.fromJson(item));

        });
      });




    } else {
      EasyLoading.dismiss();

      print(response.statusCode);


    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ToolbarImage(appBar: AppBar(),),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: MyColors.whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: RefreshIndicator(
              onRefresh:(){
                items.clear();
                return  getItemList();
              },

              child:ListView.builder(
                itemCount: items.length,
                addRepaintBoundaries: true,
                scrollDirection:Axis.vertical,
                shrinkWrap: false,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  ItemModel itemModel = items[index];
                  return GestureDetector(
                    /* onTap: (){
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => OrderDetail(),
                            settings: RouteSettings(
                              arguments: od,
                            ),
                          ),);
                      },*/


                    child: Container(

                      child: Card(
                        color: MyColors.whiteColor,
                        elevation:2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: MyColors.blackColor24, width: 1.0)),
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              TextWidget(
                                  input: itemModel.ItemName!,
                                  fontsize: 15,
                                  fontWeight: FontWeight.w600,
                                  textcolor: MyColors.blackColor8),

                              Utils.FORM_HINT_PADDING,



                              Divider(
                                thickness: 2.0,
                                color: MyColors.blue,
                              ),



                            ],
                          ),
                        ),

                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton:FloatingActionButton(
        onPressed:()async{
          await Navigator.pushNamed(context, Constants.addItemScreen);
          setState(() {
            items.clear();

            initState();
          });

        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),

    );
  }
  confirmationPopup(BuildContext dialogContext, String? error) {

    var alertStyle = const AlertStyle(
      animationType: AnimationType.grow,
      overlayColor: Colors.black87,
      isCloseButton: true,
      isOverlayTapDismiss: true,
      titleStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
      descStyle: TextStyle(fontWeight: FontWeight.normal, fontSize: 18),
      animationDuration: Duration(milliseconds: 400),
    );

    Alert(context: dialogContext, style: alertStyle, title: error, buttons: [
      DialogButton(
        onPressed: () {
          Navigator.pop(dialogContext);
        },
        color: MyColors.redColor,
        child: const Text(
          "Try Again",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      )
    ]).show();
  }


}

