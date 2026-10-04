import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
class PdfService {
  Future<Uint8List> simpleDocument({required String title,required List<String> lines}) async { final doc=pw.Document(); doc.addPage(pw.Page(build:(_)=>pw.Column(crossAxisAlignment:pw.CrossAxisAlignment.start,children:[pw.Text(title,style:pw.TextStyle(fontSize:22)),pw.SizedBox(height:20),...lines.map(pw.Text.new)]))); return doc.save(); }
  Future<void> printBytes(Uint8List bytes) async => Printing.layoutPdf(onLayout:(_)=>bytes);
}
