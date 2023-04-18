import 'dart:developer';
import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
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
                pw.UrlLink(
                  child: pw.Text(
                    'Clique aqui',
                    style: pw.TextStyle(
                      color: PdfColor.fromHex(
                        '2c9cee',
                      ),
                    ),
                  ),
                  destination: 'https://google.com',
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
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'A Title',
          weight: 1,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'this is conent left',
          weight: 0,
          align: LineText.ALIGN_LEFT,
          linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_TEXT,
          content: 'this is conent right',
          align: LineText.ALIGN_RIGHT,
          linefeed: 1));
      list.add(LineText(linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_BARCODE,
          content: 'A12312112',
          size: 10,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      list.add(LineText(linefeed: 1));
      list.add(LineText(
          type: LineText.TYPE_QRCODE,
          content: 'qrcode i',
          size: 10,
          align: LineText.ALIGN_CENTER,
          linefeed: 1));
      list.add(LineText(linefeed: 1));

      //ByteData data = await rootBundle.load("assets/images/guide3.png");
      //List<int> imageBytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      //String base64Image = base64Encode(imageBytes);
      //list.add(LineText(type: LineText.TYPE_IMAGE, content: base64Image, align: LineText.ALIGN_CENTER, linefeed: 1));
      return await bluetoothPrint.printReceipt(config, list);
    } catch (e) {
      log(e.toString());
      return false;
    }
  }
}
