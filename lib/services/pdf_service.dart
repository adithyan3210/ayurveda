import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  }) async {
    final pdf = pw.Document();

    // Add page to PDF
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              pw.SizedBox(height: 20),
              
              // Patient Information Section
              _buildSectionTitle('Patient Information'),
              pw.SizedBox(height: 10),
              _buildInfoRow('Name:', patientName),
              _buildInfoRow('Phone:', phoneNumber),
              _buildInfoRow('Address:', address),
              _buildInfoRow('Location:', location),
              _buildInfoRow('Branch:', branch),
              pw.SizedBox(height: 20),
              
              // Treatment Details Section
              _buildSectionTitle('Treatment Details'),
              pw.SizedBox(height: 10),
              _buildTreatmentTable(treatments),
              pw.SizedBox(height: 20),
              
              // Payment Information Section
              _buildSectionTitle('Payment Information'),
              pw.SizedBox(height: 10),
              _buildInfoRow('Total Amount:', '₹$totalAmount'),
              _buildInfoRow('Discount Amount:', '₹$discountAmount'),
              _buildInfoRow('Advance Amount:', '₹$advanceAmount'),
              _buildInfoRow('Balance Amount:', '₹$balanceAmount'),
              _buildInfoRow('Payment Method:', paymentOption),
              pw.SizedBox(height: 20),
              
              // Schedule Information Section
              _buildSectionTitle('Schedule Information'),
              pw.SizedBox(height: 10),
              _buildInfoRow('Treatment Date:', treatmentDate),
              _buildInfoRow('Treatment Time:', treatmentTime),
              pw.SizedBox(height: 30),
              
              // Footer
              _buildFooter(),
            ],
          );
        },
      ),
    );

    // Save PDF to device
    return await _savePDF(pdf);
  }

  static pw.Widget _buildHeader() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(20),
      decoration: pw.BoxDecoration(
        color: PdfColors.green100,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'AYURVEDA CLINIC',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Patient Registration Details',
            style: pw.TextStyle(
              fontSize: 16,
              color: PdfColors.green700,
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Generated on: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
            style: pw.TextStyle(
              fontSize: 12,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: pw.BoxDecoration(
        color: PdfColors.green50,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.green800,
        ),
      ),
    );
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(
              value,
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTreatmentTable(List<Map<String, dynamic>> treatments) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300),
      columnWidths: {
        0: const pw.FlexColumnWidth(1),
        1: const pw.FlexColumnWidth(3),
        2: const pw.FlexColumnWidth(1),
        3: const pw.FlexColumnWidth(1),
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.green100),
          children: [
            _buildTableCell('No.', isHeader: true),
            _buildTableCell('Treatment Name', isHeader: true),
            _buildTableCell('Male', isHeader: true),
            _buildTableCell('Female', isHeader: true),
          ],
        ),
        // Data rows
        ...treatments.asMap().entries.map((entry) {
          final index = entry.key;
          final treatment = entry.value;
          return pw.TableRow(
            children: [
              _buildTableCell('${index + 1}'),
              _buildTableCell(treatment['name'] ?? ''),
              _buildTableCell(treatment['male']?.toString() ?? '0'),
              _buildTableCell(treatment['female']?.toString() ?? '0'),
            ],
          );
        }).toList(),
      ],
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 11,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: isHeader ? PdfColors.green800 : PdfColors.black,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(15),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(5),
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'Thank you for choosing our services!',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.green800,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'For any queries, please contact us at +91-XXXXXXXXXX',
            style: pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  static Future<String> _savePDF(pw.Document pdf) async {
    try {
      // Get the directory for saving the file
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'patient_registration_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final filePath = '${directory.path}/$fileName';
      
      // Save the PDF
      final file = File(filePath);
      await file.writeAsBytes(await pdf.save());
      
      return filePath;
    } catch (e) {
      throw Exception('Failed to save PDF: $e');
    }
  }

  static Future<void> openPDF(String filePath) async {
    try {
      await OpenFile.open(filePath);
    } catch (e) {
      throw Exception('Failed to open PDF: $e');
    }
  }

  static Future<void> sharePDF(String filePath) async {
    try {
      await OpenFile.open(filePath);
    } catch (e) {
      throw Exception('Failed to share PDF: $e');
    }
  }
}
