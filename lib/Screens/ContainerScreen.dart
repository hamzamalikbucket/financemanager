import 'dart:convert';

import 'package:bottom_loader/bottom_loader.dart';
import 'package:financemanager/Constants.dart';
import 'package:financemanager/Models/AccountModel.dart';
import 'package:financemanager/Models/ContainerModel.dart';
import 'package:financemanager/Models/ItemModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Screens/EditContainerScreen.dart';
import 'package:financemanager/Screens/ExpensesScreen.dart';
import 'package:financemanager/Utils.dart';
import 'package:financemanager/widgets/BtnNullHeightWidth.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:financemanager/widgets/Toolbar.dart';
import 'package:financemanager/widgets/ToolbarImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart'as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class ContainerScreen extends StatefulWidget{
  const ContainerScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ItemState();
  }


}
class ItemState extends State<ContainerScreen>{
  List<ContainerModel>items=[];
  late BottomLoader bl;

  @override
  void initState() {
    // TODO: implement initState

    EasyLoading.show(
        status: "Loading"

    );



    setState(() {


      try{
        getContainerList();

      }catch (e){
        confirmationPopup(context, "An error Occurred.Try again later!");

      }

    });



  }
  Future<void> getContainerList() async {

    var url = Uri.parse('${Utils.baseUrl}getContainer');
    var response = await http.post(url,body:{"user_id":Utils.USER_ID.toString()}).timeout(const Duration(seconds: 30),onTimeout: (){

      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);


      setState(() {
        items.clear();
        body.forEach((item){
          print(item);
          items.add(ContainerModel.fromJson(item));

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
      appBar: ToolbarBack(appBar: AppBar(), title: 'Container',),
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
                return  getContainerList();
              },

              child:ListView.builder(
                itemCount: items.length,
                addRepaintBoundaries: true,
                scrollDirection:Axis.vertical,
                shrinkWrap: false,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  ContainerModel conatinerModel = items[index];
                  return GestureDetector(
                    onLongPress: (){
                      showMenu(context: context,  position:RelativeRect.fromLTRB(100, 100, 100, 100),
                        items:[
                          PopupMenuItem(
                            value: "1",

                            child: const Text("Edit"),
                          ),
                          PopupMenuItem(
                            value: "2",
                            onTap: ()async{
                              EasyLoading.show(status: "Loading");
                              var url = Uri.parse(
                                  '${Utils.baseUrl}deleteContainer');
                              var response = await http
                                  .post(url, body: {
                                "id": conatinerModel.conatinerId
                              }).timeout(const Duration(seconds: 30),
                                  onTimeout: () {
                                    return confirmationPopup(context,
                                        "Check your Internet Connection!");
                                  });

                              if (response.statusCode == 200) {
                                EasyLoading.dismiss();
                                print(response.body);
                                dynamic body =
                                jsonDecode(response.body);
                                String status = body['status'];
                                if (status == "success") {
                                  setState(() {
                                    items.removeAt(index);
                                  });
                                } else {
                                  String error = body['message'];
                                  confirmationPopup(context, error);
                                }
                              } else {
                                EasyLoading.dismiss();

                                print(response.statusCode);
                              }
                            },
                            child: Text("Delete"),
                          ),

                        ],



                      ).then<void>((String? itemSelected){
                        if(itemSelected==null){
                          return null;
                        }
                        if(itemSelected =="1"){
                          Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => EditContainerScreen(),
                              settings: RouteSettings(
                                arguments:
                                items[index],
                              ),
                            ),).then((value) {
                            initState();
                          });
                          //code here
                        }else{
                          //code here
                        }

                      });
                    },


                    child: Container(

                      child: Card(
                        color: MyColors.whiteColor,
                        elevation:2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide(color: MyColors.blackColor24, width: 1.0)),
                        child:Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextWidget(
                                      input: conatinerModel.conatinerId!,
                                      fontsize: 18,
                                      fontWeight: FontWeight.w600,
                                      textcolor: MyColors.blackColor8),
                                  TextWidget(
                                      input: conatinerModel.ContainerName!,
                                      fontsize: 18,
                                      fontWeight: FontWeight.w600,
                                      textcolor: MyColors.blackColor8),
                                  IconButton(
                                    onPressed: () async{
                                      Navigator.push(context,
                                        MaterialPageRoute(
                                          builder: (context) => ExpensesScreen(),
                                          settings: RouteSettings(
                                            arguments:conatinerModel,
                                          ),
                                        ),);
                                      setState(() {
                                        items.clear();

                                        initState();
                                      });




                                    },
                                    icon: Icon(
                                      Icons.add,
                                      color: MyColors.blue,
                                      size: 20,
                                    ),
                                  ),
                                ],
                              ),

                              Utils.FORM_HINT_PADDING,







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
          await Navigator.pushNamed(context, Constants.addcontainerScreen);
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

