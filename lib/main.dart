import 'package:financemanager/MyColors.dart';
import 'package:financemanager/Screens/AccountScreen.dart';
import 'package:financemanager/Screens/AddAccountScreen.dart';
import 'package:financemanager/Screens/AddExpensesScreen.dart';
import 'package:financemanager/Screens/AddItemScreen.dart';
import 'package:financemanager/Screens/AddJvScreen.dart';
import 'package:financemanager/Screens/AddPaymentScreen.dart';
import 'package:financemanager/Screens/AddPurchaseScreen.dart';
import 'package:financemanager/Screens/AddSaleScreen.dart';
import 'package:financemanager/Screens/HomeScreen.dart';
import 'package:financemanager/Screens/ItemScreen.dart';
import 'package:financemanager/Screens/JournalVoucherScreen.dart';
import 'package:financemanager/Screens/OtherExpenesScreen.dart';
import 'package:financemanager/Screens/PaymentScreen.dart';
import 'package:financemanager/Screens/PurchaseDetail.dart';
import 'package:financemanager/Screens/ReceiptScreen.dart';
import 'package:financemanager/Screens/SaleScreen.dart';
import 'package:financemanager/Screens/ViewJVScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'Constants.dart';
import 'Screens/AddContainerScreen.dart';
import 'Screens/AddRecieptScreen.dart';
import 'Screens/ContainerScreen.dart';
import 'Screens/ExpensesScreen.dart';
import 'Screens/LedgerScreen.dart';
import 'Screens/LoginScreen.dart';
import 'Screens/PurchaseScreen.dart';
import 'Screens/SignUp.dart';
import 'Screens/Splash.dart';

void main() {
  runApp(const MyApp());

  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.cyan
    ..backgroundColor = Colors.white
    ..indicatorColor = Colors.cyan
    ..textColor = Colors.cyan
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Manager',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,

      ),
        initialRoute: Constants.splash,
        builder: EasyLoading.init(),

        routes: {
          Constants.splash: (context) =>Splash(),
          Constants.loginscreen: (context) =>const Login(),
          Constants.signUpScreen: (context) =>const SignUp(),
          Constants.homeScreen: (context) =>const HomeScreen(),
          Constants.AccountScreen: (context) =>AccountScreen(),
          Constants.AddAccountScreen: (context) =>AddAccountScreen(),
          Constants.PaymentScreen: (context) =>PaymentScreen(),
          Constants.addPaymentScreen: (context) =>AddPaymentScreen(),
          Constants.recieptScreen: (context) =>ReceiptScreen(),
          Constants.addReceiptScreen: (context) =>AddReceiptScreen(),
          Constants.itemScreen: (context) =>ItemScreen(),
          Constants.addItemScreen: (context) =>AddItemScreen(),
          Constants.ledgerScreen: (context) =>const LedgerScreen(),
          Constants.jVScreen: (context) =>const JournalVoucherScreen(),
          Constants.viewJVScreen: (context) =>const ViewJVScreen(),
          Constants.addJVScreen: (context) =>const AddJvScreen(),
          Constants.purchaseScreen: (context) =>const PurchaseScreen(),
          Constants.addPurchaseScreen: (context) =>const AddPurchaseScreen(),
          Constants.saleScreen: (context) =>const SaleScreen(),
          Constants.addSaleScreen: (context) =>const AddSaleScreen(),
          Constants.containerScreen: (context) =>const ContainerScreen(),
          Constants.addcontainerScreen: (context) =>AddContainerScreen(),
          Constants.viewexpenses: (context) =>ExpensesScreen(),
          Constants.addexpenses: (context) =>AddExpensesScreen(),
          Constants.viewOtherexpenses: (context) =>OtherExpenseScreen(),
          Constants.purchaseDetailScreen: (context) =>PurchaseDetailScreen(),
          Constants.pdfledger: (context) =>PurchaseDetailScreen(),














        }

    );
  }
}

