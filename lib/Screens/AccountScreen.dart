import 'dart:convert';

import 'package:bottom_loader/bottom_loader.dart';
import 'package:financemanager/Constants.dart';
import 'package:financemanager/Models/AccountModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Screens/EditAccountScreen.dart';
import 'package:financemanager/Utils.dart';
import 'package:financemanager/widgets/BtnNullHeightWidth.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:financemanager/widgets/ToolbarImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';

class AccountScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AccountState();
  }
}

class AccountState extends State<AccountScreen> {
  List<AccountModel> account = [];
  late BottomLoader bl;

  List<AccountModel> _foundUsers = [];

  Offset _tapPosition = Offset.zero;
  void _getTapPosition(TapDownDetails details) {
    final RenderBox referenceBox = context.findRenderObject() as RenderBox;
    setState(() {
      _tapPosition = referenceBox.globalToLocal(details.globalPosition);
    });
  }

  @override
  void initState() {
    // TODO: implement initState


    EasyLoading.show(status: "Loading");

    setState(() {
      try {
        getAccountList();
      } catch (e) {
        confirmationPopup(context, "An error Occurred.Try again later!");
      }
    });
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<AccountModel> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = account;
    } else {
      results = account
          .where((user) =>
          user.Title!.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  Future<void> getAccountList() async {
    var url = Uri.parse('${Utils.baseUrl}getAccounts');
    var response = await http
        .post(url, body: {"gid": Utils.USER_ID.toString()}).timeout(
            const Duration(seconds: 30), onTimeout: () {
      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);

      setState(() {
        body.forEach((item) {
          print(item);
          account.add(AccountModel.fromJson(item));
          _foundUsers=account;
          _foundUsers.sort((a,b){
           return  a.Title.toString().compareTo(b.Title.toString());


          });




        });
      });
    } else {
      EasyLoading.dismiss();

      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    final RenderObject? overlay =
    Overlay.of(context)?.context.findRenderObject();
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            TextField(

              onChanged: (value) => _runFilter(value),
              style: TextStyle(color: Colors.white),
              showCursor: true,
              decoration: const InputDecoration(

                  labelText: 'Search',labelStyle: TextStyle(color: Colors.white), suffixIcon: Icon(Icons.search,color: Colors.white,)),
            ),
          ],
        ),

      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: MyColors.whiteColor,
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: RefreshIndicator(
              onRefresh: () {
                account.clear();
                return getAccountList();
              },
              child:_foundUsers.isNotEmpty? ListView.builder(
                itemCount: _foundUsers.length,
                addRepaintBoundaries: true,
                scrollDirection: Axis.vertical,
                shrinkWrap: false,

                physics: const AlwaysScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  AccountModel accountmodle = _foundUsers[index];

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
                    onLongPress: (){

                      showMenu(context: context, position: RelativeRect.fromRect(
                          Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 180, 180),
                          Rect.fromLTWH(50, 50, overlay!.paintBounds.size.width,
                              overlay.paintBounds.size.height)),
                          items:<PopupMenuEntry>[
                      PopupMenuItem(
                        value: account[index],
                        onTap: ()async{
                          Navigator.pushNamed(context, Constants.AddAccountScreen);

                        },

                        child: const Text("Edit"),
                      ),
                      PopupMenuItem(
                      value: this.account[index],
                        onTap: ()async{
                          EasyLoading.show(status: "Loading");
                          var url = Uri.parse(
                              '${Utils.baseUrl}deleteAccount');
                          var response = await http
                              .post(url, body: {
                            "id": accountmodle.AccountId
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
                                account.removeAt(index);
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
                        child: const Text("Delete"),
                      ),
                      PopupMenuItem(

                      value: account[index],
                        child: const Text("Ledger"),
                      ),
                      ],


                      );


                    },


                    child:SizedBox(
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              radius:30.0 ,
                              backgroundColor: MyColors.orangeColor,
                              child:  TextWidget(
                                  input: accountmodle.Title![0],
                                  fontsize: 20,
                                  fontWeight: FontWeight.w300,
                                  textcolor: MyColors.whiteColor),

                            ),
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextWidget(
                                    input: accountmodle.Title!,
                                    fontsize: 20,
                                    fontWeight: FontWeight.w800,
                                    textcolor: MyColors.blackColor8),
                                TextWidget(
                                    input: "Balance:" +
                                        accountmodle.OpeningBalance!,
                                    fontsize: 10,
                                    fontWeight: FontWeight.normal,
                                    textcolor: MyColors.blackColor8),



                              ],
                            )

                          ),
                          Divider(
                            thickness: 1.0,
                            color: MyColors.gray,
                          ),
                        ],
                      ),
                    )




                  );

                },
              ): const Center(
                child: Text(
                  'No results found',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, Constants.AddAccountScreen);
          setState(() {
            account.clear();

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
  void _showContextMenu(BuildContext context) async {
    final RenderObject? overlay =
    Overlay.of(context)?.context.findRenderObject();

    final result = await showMenu(
        context: context,

        // Show the context menu at the tap location
        position: RelativeRect.fromRect(
            Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
            Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                overlay.paintBounds.size.height)),

        // set a list of choices for the context menu
        items: [
          const PopupMenuItem(
            value: 'Edit',
            child: Text('Edit'),
          ),
          const PopupMenuItem(
            value: 'Delete',
            child: Text('Delete'),
          ),
          const PopupMenuItem(
            value: 'Ledger',
            child: Text('Ledger'),
          ),
        ]);

    // Implement the logic for each choice here
    switch (result) {
      case 'favorites':
        debugPrint('Add To Favorites');
        break;
      case 'comment':
        debugPrint('Write Comment');
        break;
      case 'hide':
        debugPrint('Hide');
        break;
    }
  }
}
