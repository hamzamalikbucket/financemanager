import 'dart:convert';

import 'package:bottom_loader/bottom_loader.dart';
import 'package:financemanager/Models/AccountModel.dart';
import 'package:financemanager/Models/ContainerModel.dart';
import 'package:financemanager/Models/ItemModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Utils.dart';
import 'package:financemanager/widgets/BtnNullHeightWidth.dart';

import 'package:financemanager/widgets/NameInputWidget.dart';
import 'package:financemanager/widgets/TextWidget.dart';
import 'package:financemanager/widgets/Toolbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;
import 'package:rflutter_alert/rflutter_alert.dart';


class AddPurchaseScreen extends StatefulWidget{
  const AddPurchaseScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return AddPurchaseState();
  }


}
class AddPurchaseState extends State<AddPurchaseScreen>{
  final GlobalKey<FormState> puraddKey = GlobalKey<FormState>();

  late String  totalWeight,Desc,Date,lessWeight,netWeight,purchaseRate;
  TextEditingController FromController = TextEditingController();
  DateTime openingDate = DateTime.now();
  String openingDateString="";
  var itemtitle;
  var title;
  var containertitle;
  late BottomLoader bl;

  List<AccountModel>account=[];
  List<ItemModel>items=[];
  List<ContainerModel>containerList=[];
  TextEditingController totalWeightControllr=TextEditingController();
  TextEditingController lessWeightControllr=TextEditingController();
  TextEditingController netWeightControllr=TextEditingController();
  TextEditingController totalAmountControllr=TextEditingController();
  int Totalmount=0;
  int netweig=0;

  @override
  void initState() {
    // TODO: implement initState
    bl = BottomLoader(context,
        isDismissible: true,
        showLogs: true,
        loader: CircularProgressIndicator(
          color: MyColors.blue,
        ));
    bl.style(
        message: 'Please Wait...',
        backgroundColor: MyColors.darkgreenColor,
        messageTextStyle: TextStyle(
            color: MyColors.darkgreenColor,
            fontSize: 19.0,
            fontWeight: FontWeight.w600));

    EasyLoading.show(
        status: "Loading"

    );



    setState(() {


      try{
        getAccountList();
        getContainerList();
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
  Future<void> getAccountList() async {

    var url = Uri.parse('${Utils.baseUrl}getAccounts');
    var response = await http.post(url,body: {"gid":Utils.USER_ID.toString()}).timeout(const Duration(seconds: 30),onTimeout: (){

      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200) {
      EasyLoading.dismiss();
      print(response.body);
      dynamic body = jsonDecode(response.body);


      setState(() {

        body.forEach((item){
          print(item);
          account.add(AccountModel.fromJson(item));

        });
      });




    } else {
      EasyLoading.dismiss();

      print(response.statusCode);


    }
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

        body.forEach((item){
          print(item);
          containerList.add(ContainerModel.fromJson(item));

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

      appBar: ToolbarBack(appBar: AppBar(), title: 'Add Purchase Invoice',),
      body: SafeArea(

        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Utils.APP_PADDING),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [

                form(context),



              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget form(BuildContext context) {
    return Form(
        key: puraddKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(

              child: DropdownButtonHideUnderline(
                child:
                DropdownButtonFormField(
                  value: title,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.views_btn,
                    contentPadding: EdgeInsets.all(10),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 0.0,
                          style: BorderStyle.none),
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(13.0)),
                    ),
                  ),
                  iconSize: 20,
                  hint: const Text("Supplier"),
                  iconEnabledColor: MyColors.blue,
                  validator: (value) => value == null
                      ? 'Choose Supplier'
                      : null,
                  style: TextStyle(
                      color: MyColors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  isDense: true,


                  items: account.map((item) {
                    return DropdownMenuItem(
                      value:item.AccountId.toString(),
                      child: Text(
                        item.Title.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      title= newValue;
                    });
                  },
                ),
              ),
            ),
            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            SizedBox(

              child: DropdownButtonHideUnderline(
                child:
                DropdownButtonFormField(
                  value: containertitle,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.views_btn,
                    contentPadding: EdgeInsets.all(10),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 0.0,
                          style: BorderStyle.none),
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(13.0)),
                    ),
                  ),
                  iconSize: 20,
                  hint: const Text("Container"),
                  iconEnabledColor: MyColors.blue,
                  validator: (value) => value == null
                      ? 'Add Container'
                      : null,
                  style: TextStyle(
                      color: MyColors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  isDense: true,


                  items: containerList.map((item) {
                    return DropdownMenuItem(
                      value:item.conatinerId.toString(),
                      child: Text(
                        item.conatinerId .toString()+item.ContainerName.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      containertitle= newValue;
                    });
                  },
                ),
              ),
            ),

            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            SizedBox(

              child: DropdownButtonHideUnderline(
                child:
                DropdownButtonFormField(
                  value: itemtitle,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: MyColors.views_btn,
                    contentPadding: EdgeInsets.all(10),
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 0.0,
                          style: BorderStyle.none),
                      borderRadius:
                      BorderRadius.all(
                          Radius.circular(13.0)),
                    ),
                  ),
                  iconSize: 20,
                  hint: const Text("Item"),
                  iconEnabledColor: MyColors.blue,
                  validator: (value) => value == null
                      ? 'Add Item'
                      : null,
                  style: TextStyle(
                      color: MyColors.blue,
                      fontSize: 14,
                      fontWeight: FontWeight.w600),
                  isDense: true,


                  items: items.map((item) {
                    return DropdownMenuItem(
                      value:item.ItemId.toString(),
                      child: Text(
                        item.ItemName.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      itemtitle= newValue;
                    });
                  },
                ),
              ),
            ),


            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,

            NameInputWidget(
                title: "Total Weight",
                error: "Enter weight",
                controller: totalWeightControllr,
                isRequired: true,
                icon: Icons.payment,


                keyboardType: TextInputType.text,
                value: (val) {
                  totalWeight = val!;
                },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: false,
                hintcolour: MyColors.whiteColor),

            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            NameInputWidget(
                title: "Less Weight",
                error: "Enter weight",
                isRequired: true,
                controller: lessWeightControllr,

                icon: Icons.payment,
                keyboardType: TextInputType.text,
                value: (val) {
                  lessWeight = val!;

                },
    changevalue: (val){
    netWeightControllr.text=(int.parse(totalWeightControllr.text)-int.parse(lessWeightControllr.text)).toString();

    },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: false,


                hintcolour: MyColors.whiteColor),
            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            NameInputWidget(
                title: "Net Weight",
                error: "Enter weight",
                isRequired: true,
                isenabled: false,
                controller: netWeightControllr,
                icon: Icons.payment,
                keyboardType: TextInputType.text,
                value: (val) {
                  netWeight = val!;
                },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: false,
                hintcolour: MyColors.whiteColor),

            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,

            NameInputWidget(
                title: "Purchase Rate",
                error: "Enter rate",
                isRequired: true,
                icon: Icons.payment,
                keyboardType: TextInputType.text,
                value: (val) {
                  purchaseRate = val!;

                },
                changevalue: (val){
                  setState(() {
                    Totalmount=int.parse(netWeightControllr.text)*int.parse(val!);
                    totalAmountControllr.text=Totalmount.toString();
                  }); },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: false,
                hintcolour: MyColors.whiteColor),

            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            NameInputWidget(
                title: "Total Amount",
                error: "Amount",
                isRequired: true,
                isenabled: false,
                controller: totalAmountControllr,
                icon: Icons.payment,
                keyboardType: TextInputType.text,
                value: (val) {
                  Totalmount= int.parse(val!);
                },
                width: MediaQuery.of(context).size.width,
                validate: true,
                isPassword: false,
                hintcolour: MyColors.whiteColor),
            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,
            NameInputWidget(
                title: "Description",
                error: "Enter Desc",
                isRequired: false,
                icon: Icons.description,
                keyboardType: TextInputType.text,
                value: (val) {

                  Desc = val!;
                },
                width: MediaQuery.of(context).size.width,
                validate: false,
                isPassword: false,
                hintcolour: MyColors.whiteColor),


            Utils.FORM_HINT_PADDING,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                TextWidget(

                  input: "Date",
                  fontsize: 16,
                  fontWeight: FontWeight.normal,
                  textcolor: MyColors.blackColor8,
                ),
                Container(
                  width: 100,
                  child: TextField(
                    style: TextStyle(
                      color: MyColors.blue,
                    ),
                    controller: FromController,
                    onTap: () async{
                      FocusScope.of(context).requestFocus(new FocusNode());
                      await selectfromdate(context);
                      FromController.text = DateFormat('dd-MM-yyyy').format(openingDate);
                    },
                    onChanged: (String value){
                      openingDateString=value;
                    },

                    decoration:InputDecoration(
                      border: InputBorder.none,
                      hintText:openingDate.year.toString()+"-"+openingDate.month.toString()+"-"+openingDate.day.toString(),
                      hintStyle: TextStyle(color: MyColors.blue),


                    ),
                  ),
                ),

              ],
            ),
            BtnNullHeightWidth(
              title: "Add",
              bgcolour: MyColors.blue,
              textcolour: MyColors.whiteColor,
              onPress: () {
                //(is_teacher)?Navigator.pushReplacementNamed(context, Constants.signup_page),
                final form = puraddKey.currentState;
                form!.save();
                if (form.validate()) {
                  print(itemtitle);
                  bl.display();
                  if(Desc.isEmpty){
                    setState(() {
                      Desc=" no description Added";
                    });
                  }
                  if(openingDateString.isEmpty){
                    setState(() {
                      DateFormat formatter = DateFormat('dd-MM-yyyy');
                      openingDateString = formatter.format(openingDate).toString();

                    });

                  }
                  print(openingDateString);
                  print(Desc);
                  print(netWeight);


                  try{
                    addPurchase();
                  }catch (e){
                    bl.close();
                    confirmationPopup(context, "An error Occurred.Try again later!");
                  }



                }
              },
              width: MediaQuery.of(context).size.width,
              height: 48,
            ),
            Utils.FORM_HINT_PADDING,
            Utils.FORM_HINT_PADDING,

          ],
        ));
  }
  Future<void> selectfromdate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: openingDate,
        firstDate: DateTime(2000, 8),
        lastDate: DateTime(2500));
    if (picked != null && picked != openingDate) {
      setState(() {
        openingDate = picked;
        DateFormat formatter = DateFormat('dd-MM-yyyy');
        openingDateString = formatter.format(openingDate);


      });
    }

  }
  Future<dynamic> addPurchase() async {
    var url = Uri.parse('${Utils.baseUrl}addPurchase');
    var response = await http
        .post(
      url,
      body: {"account_id": title, "amount": totalWeight,"description":Desc,"op_date":openingDateString,"user_id":Utils.USER_ID,"rate":purchaseRate,"total_weight":totalWeight,"less_weight":lessWeight,"net_weight":netWeight,"container_id":containertitle,"item_id":itemtitle},

    )
        .timeout(const Duration(seconds: 60),onTimeout: (){
      bl.close();
      return confirmationPopup(context, "Check your Internet Connection!");
    });

    if (response.statusCode == 200){
      print(response.body);
      dynamic body = jsonDecode(response.body);
      String status=body['status'];
      String message=body['message'];
      if(status=="sucess"){

        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor:MyColors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        );
        Navigator.pop(context);
        bl.close();

      }
      else{
        bl.close();
        Fluttertoast.showToast(
            msg: message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.SNACKBAR,
            timeInSecForIosWeb: 1,
            backgroundColor:MyColors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        );

      }



    } else {
      bl.close();
      print(response.body);

      String error = "Error Occurred";
      print(error);

      confirmationPopup(context, error);
    }
    ;
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