import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:open_filex/open_filex.dart';

class PDFService {
  static Future<String> generatePatientRegistrationPDF({
    required String patientName,
    required String phoneNumber,
    required String address,
    required String location,
    required String branch,
    required List<Map<String, dynamic>> treatments,
    required String totalAmount,
    required String discountAmount,
    required String advanceAmount,
    required String balanceAmount,
    required String paymentOption,
    required String treatmentDate,
    required String treatmentTime,
    required String bookedOn,
  }) async {
    final pdf = pw.Document();

    final logo = pw.MemoryImage(
      (await rootBundle.load('assets/images/logo.webp')).buffer.asUint8List(),
    );
    final signatureImage = pw.MemoryImage(
      (await rootBundle.load('assets/icons/sign.webp')).buffer.asUint8List(),
    );
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => [
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Container(height: 80, width: 80, child: pw.Image(logo)),
              pw.SizedBox(width: 12),
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text(
                      "KUMARAKOM",
                      style: pw.TextStyle(
                        fontSize: 18.sp,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      "Cheepunkal P.O. Kumarakom, Kerala - 686563",
                      style: pw.TextStyle(
                        fontSize: 12.sp,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xff9A9A9A),
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      "e-mail: unknown@gmail.com",
                      style: pw.TextStyle(
                        fontSize: 12.sp,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xff9A9A9A),
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      "Mob: +91 9876543210 | +91 9876543210",
                      style: pw.TextStyle(
                        fontSize: 12.sp,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromInt(0xff9A9A9A),
                      ),
                    ),
                    pw.SizedBox(height: 2),
                    pw.Text(
                      "GST No: 32AABCU9603R1ZW",
                      style: pw.TextStyle(
                        fontSize: 12.sp,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 20),
          pw.Divider(color: PdfColor.fromInt(0x4D000000)),

          pw.Container(
            padding: const pw.EdgeInsets.all(12),
            child: pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "Patient Details",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.green,
                        fontSize: 14,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Text("Name: $patientName"),
                    pw.Text("Address: $address"),
                    pw.Text("Location: $location"),
                    pw.Text("WhatsApp number: $phoneNumber"),
                  ],
                ),

                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Booked On: $bookedOn"),
                    pw.Text("Treatment Date: $treatmentDate"),
                    pw.Text("Treatment Time: $treatmentTime"),
                    pw.Text("Payment: $paymentOption"),
                  ],
                ),
              ],
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Divider(color: PdfColor.fromInt(0x4D000000)),
          pw.Table.fromTextArray(
            headers: ["Treatment", "Price", "Male", "Female", "Total"],
            headerStyle: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
            headerDecoration: pw.BoxDecoration(color: PdfColors.green),
            cellHeight: 28,
            cellAlignments: {
              0: pw.Alignment.centerLeft,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
              3: pw.Alignment.center,
              4: pw.Alignment.centerRight,
            },
            data: treatments.map((t) {
              final price = double.tryParse(t["price"].toString()) ?? 0;
              final male = int.tryParse(t["male"].toString()) ?? 0;
              final female = int.tryParse(t["female"].toString()) ?? 0;
              final total = price * (male + female);
              return [
                t["name"],
                "₹$price",
                male.toString(),
                female.toString(),
                "₹$total",
              ];
            }).toList(),
          ),
          pw.SizedBox(height: 20),

          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.end,
                children: [
                  pw.Text(
                    "Total Amount: ₹$totalAmount",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  pw.Text("Discount: ₹$discountAmount"),
                  pw.Text("Advance: ₹$advanceAmount"),
                  pw.Divider(),
                  pw.Text(
                    "Balance: ₹$balanceAmount",
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 14,
                      color: PdfColors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
          pw.SizedBox(height: 30),

          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            children: [
              pw.Text(
                "Thank you for choosing us",
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                "Your well-being is our commitment, and we're honored\nyou’ve entrusted us with your health journey",
                textAlign: pw.TextAlign.center,
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
              ),
              pw.SizedBox(height: 20),

              // Optional Signature Image
              pw.Image(signatureImage, height: 40),
              pw.SizedBox(height: 10),
              pw.Text(
                "*Booking amount is non-refundable, and it's important to arrive on the allotted time for your treatment*",
                style: pw.TextStyle(fontSize: 9, color: PdfColors.grey),
                textAlign: pw.TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );

    // SAVE PDF
    final output = await getApplicationDocumentsDirectory();
    final file = File(
      "${output.path}/Patient_${patientName.replaceAll(" ", "_")}_${DateTime.now().millisecondsSinceEpoch}.pdf",
    );
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }

  static Future<void> openPDF(String filePath) async {
    await OpenFilex.open(filePath);
  }
}
