import 'dart:typed_data';
import 'package:data_table_2/data_table_2.dart';
import 'package:financemanager/Models/LedgerModel.dart';
import 'package:financemanager/MyColors.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;




Future<Uint8List> makePdf(LedgerModel invoice) async {
  final imageLogo = MemoryImage((await rootBundle.load('https://www.nfet.net/nfet.jpg')).buffer.asUint8List());


  final pdf = Document();
  pdf.addPage(
      Page(
          build: (context) {
            return Column(
                children: [
                  SizedBox(
                    height: 150,
                    width: 150,
                    child: Image(imageLogo),
                  )
                ]
            );
          }
      ),
  );


  return pdf.save();

}



Widget PaddedText(
    final String text, {
      final TextAlign align = TextAlign.left,
    }) =>
    Padding(
      padding: EdgeInsets.all(10),
      child: Text(
        text,
        textAlign: align,
      ),
    );