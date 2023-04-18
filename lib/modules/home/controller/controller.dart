import 'dart:convert';
import 'dart:developer';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:thermal_printer/core/models/user_information.dart';

class Controller {
  static Future<bool> printDocument(UserInformation userInformation) async {
    try {
      final doc = pw.Document();
      final image = await imageFromAssetBundle('assets/images/icon.png');

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Image(image, height: 30, width: 30),
                pw.SizedBox(height: 30),
                pw.Text(
                  'My document',
                  style: const pw.TextStyle(fontSize: 20),
                ),
                pw.SizedBox(height: 30),
                pw.Text(userInformation.name),
                pw.SizedBox(height: 15),
                pw.Text(userInformation.email),
                pw.SizedBox(height: 15),
                pw.Text(userInformation.phone),
                pw.SizedBox(height: 15),
                pw.Text(
                  'https://google.com',
                  style: pw.TextStyle(
                    color: PdfColor.fromHex(
                      '2c9cee',
                    ),
                  ),
                ),
              ],
            ); // Center
          },
        ),
      );

      return await Printing.layoutPdf(onLayout: (value) => doc.save());
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<bool> mobilePrintDocument(
    UserInformation userInformation,
    BluetoothPrint bluetoothPrint,
  ) async {
    try {
      Map<String, dynamic> config = {};
      List<LineText> list = [];
      ByteData data = await rootBundle.load('assets/images/icon.png');
      List<int> imageBytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      String base64Image = base64Encode(imageBytes);
      list.add(LineText(
          type: LineText.TYPE_IMAGE,
          content: base64Image,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      list.add(LineText(linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: userInformation.name,
          weight: 1,
          align: LineText.ALIGN_LEFT,
          linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: userInformation.email,
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: userInformation.phone,
          align: LineText.ALIGN_LEFT,
          linefeed: 1));
      list.add(LineText(linefeed: 1));

      return await bluetoothPrint.printReceipt(config, list);
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
