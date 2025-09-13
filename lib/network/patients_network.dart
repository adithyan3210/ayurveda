import 'dart:developer';
import 'package:ayurveda/core/api_list.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/shared_preference.dart';
import '../models/patient_model.dart';

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
}
