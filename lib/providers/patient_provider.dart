import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../models/treatment_model.dart';
import '../models/branch_model.dart';
import '../network/patients_network.dart';

enum PatientState { Initial, Loading, Loaded, Error }

enum TreatmentState { Initial, Loading, Loaded, Error }

enum BranchState { Initial, Loading, Loaded, Error }

class PatientProvider extends ChangeNotifier {
  PatientState _patientState = PatientState.Initial;
  List<Patient> _patientsData = [];
  List<Patient> _filteredPatients = [];
  String _errorMessage = '';
  String _search = '';

  TreatmentState _treatmentState = TreatmentState.Initial;
  List<Treatment> _treatmentsData = [];
  String _treatmentError = '';

  BranchState _branchState = BranchState.Initial;
  List<BranchModel> _branchesData = [];
  String _branchError = '';

  final PatientService _patientService = PatientService();

  PatientState get patientState => _patientState;
  List<Patient> get patients =>
      _search.isEmpty ? _patientsData : _filteredPatients;
  String get errorMessage => _errorMessage;
  String get search => _search;
  int get patientsCount => _patientsData.length;

  TreatmentState get treatmentState => _treatmentState;
  List<Treatment> get treatments => _treatmentsData;
  String get treatmentError => _treatmentError;

  BranchState get branchState => _branchState;
  List<BranchModel> get branches => _branchesData;
  String get branchError => _branchError;

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

  Future<void> fetchTreatments() async {
    _treatmentState = TreatmentState.Loading;
    notifyListeners();

    try {
      final response = await _patientService.getTreatmentList();
      _treatmentsData = response.treatments;
      _treatmentState = TreatmentState.Loaded;
      _treatmentError = '';
    } catch (e) {
      _treatmentState = TreatmentState.Error;
      _treatmentError = 'Error fetching treatments: $e';
      _treatmentsData = [];
    }

    notifyListeners();
  }

  Future<void> fetchBranches() async {
    _branchState = BranchState.Loading;
    notifyListeners();

    try {
      final response = await _patientService.getBranchList();
      _branchesData = response.branches;
      _branchState = BranchState.Loaded;
      _branchError = '';
    } catch (e) {
      _branchState = BranchState.Error;
      _branchError = 'Error fetching branches: $e';
      _branchesData = [];
    }

    notifyListeners();
  }

  void reset() {
    _patientState = PatientState.Initial;
    _patientsData = [];
    _filteredPatients = [];
    _errorMessage = '';
    _search = '';

    _treatmentState = TreatmentState.Initial;
    _treatmentsData = [];
    _treatmentError = '';

    _branchState = BranchState.Initial;
    _branchesData = [];
    _branchError = '';

    notifyListeners();
  }
}
