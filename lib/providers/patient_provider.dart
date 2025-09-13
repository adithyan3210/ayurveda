import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../network/patients_network.dart';

enum PatientState { Initial, Loading, Loaded, Error }

class PatientProvider extends ChangeNotifier {
  PatientState _patientState = PatientState.Initial;
  List<Patient> _patientsData = [];
  List<Patient> _filteredPatients = [];
  String _errorMessage = '';
  String _search = '';
  final PatientService _patientService = PatientService();

  PatientState get patientState => _patientState;
  List<Patient> get patients =>
      _search.isEmpty ? _patientsData : _filteredPatients;
  String get errorMessage => _errorMessage;
  String get search => _search;

  int get patientsCount => _patientsData.length;

  Future<void> fetchPatients() async {
    _patientState = PatientState.Loading;
    notifyListeners();

    try {
      final response = await _patientService.fetchPatientList();

      _patientsData = response.patient;
      _patientState = PatientState.Loaded;
      _errorMessage = '';
      if (_search.isNotEmpty) {
        _filterPatients(_search);
      }
    } catch (e) {
      _patientState = PatientState.Error;
      _errorMessage = 'Error fetching patients: $e';
      _patientsData = [];
    }

    notifyListeners();
  }

  void searchPatients(String query) {
    _search = query.trim();
    _filterPatients(query);
    notifyListeners();
  }

  void _filterPatients(String query) {
    _filteredPatients = _patientsData.where((patient) {
      return patient.name.toLowerCase().startsWith(query.toLowerCase());
    }).toList();
  }

  void clearSearch() {
    _search = '';
    _filteredPatients = [];
    notifyListeners();
  }

  void reset() {
    _patientState = PatientState.Initial;
    _patientsData = [];
    _filteredPatients = [];
    _errorMessage = '';
    _search = '';
    notifyListeners();
  }
}
