import 'dart:developer';
import 'package:ayurveda/core/api_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/shared_preference.dart';
import '../models/branch_model.dart';
import '../models/patient_model.dart';
import '../models/treatment_model.dart';

class PatientService {
  Future<PatientResponse> fetchPatientList() async {
    final url = Uri.parse(patientListUrl);
    try {
      final token = await getToken();

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      log('PATIENT LIST BODY => ${response.body}');
      final Map<String, dynamic> data = jsonDecode(response.body);
      return PatientResponse.fromJson(data);
    } catch (e) {
      print('PATIENT LIST EXCEPTION => $e');
      throw Exception('Failed to fetch patient list: $e');
    }
  }

  Future<TreatmentResponse> getTreatmentList() async {
    final url = Uri.parse(treatmentListUrl);
    try {
      final token = await getToken();

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      log('TREATMENT LIST BODY => ${response.body}');
      final Map<String, dynamic> data = jsonDecode(response.body);
      return TreatmentResponse.fromJson(data);
    } catch (e) {
      print('TREATMENT LIST EXCEPTION => $e');
      throw Exception('Failed to fetch treatment list: $e');
    }
  }

  Future<BranchResponse> getBranchList() async {
    final url = Uri.parse(branchListUrl);
    try {
      final token = await getToken();

      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      log('BRANCH LIST BODY => ${response.body}');
      final Map<String, dynamic> data = jsonDecode(response.body);
      return BranchResponse.fromJson(data);
    } catch (e) {
      print('BRANCH LIST EXCEPTION => $e');
      throw Exception('Failed to fetch branch list: $e');
    }
  }

  Future<bool> registerPatient({
    required String name,
    required String excecutive,
    required String payment,
    required String phone,
    required String address,
    required double totalAmount,
    required double discountAmount,
    required double advanceAmount,
    required double balanceAmount,
    required String dateNdTime,
    required List<String> male,
    required List<String> female,
    required String branch,
    required List<String> treatments,
  }) async {
    final url = Uri.parse(registerUrl);

    try {
      final token = await getToken();

      final body = {
        "name": name,
        "excecutive": excecutive,
        "payment": payment,
        "phone": phone,
        "address": address,
        "total_amount": totalAmount.toString(),
        "discount_amount": discountAmount.toString(),
        "advance_amount": advanceAmount.toString(),
        "balance_amount": balanceAmount.toString(),
        "date_nd_time": dateNdTime,
        "id": "",
        "male": male.join(","),
        "female": female.join(","),
        "branch": branch.toString(),
        "treatments": treatments.join(","),
      };
      log("REGISTER PATIENT PAYLOAD => ${jsonEncode(body)}");
      final response = await http.post(
        url,
        headers: {'Authorization': 'Bearer $token'},
        body: jsonEncode(body),
      );

      log("REGISTER PATIENT BODY => ${response.body}");

      final data = jsonDecode(response.body);

      return true;
    } catch (e) {
      log("REGISTER PATIENT EXCEPTION => $e");
      throw Exception("Failed to register patient: $e");
    }
  }
}
