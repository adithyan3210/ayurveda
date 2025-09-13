import 'package:flutter/material.dart';
import '../models/patient_model.dart';
import '../models/treatment_model.dart';
import '../models/branch_model.dart';
import '../network/patients_network.dart';

enum PatientState { Initial, Loading, Loaded, Error }

enum TreatmentState { Initial, Loading, Loaded, Error }

enum BranchState { Initial, Loading, Loaded, Error }

enum RegisterState { Initial, Loading, Success, Error }

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

  RegisterState _registerState = RegisterState.Initial;
  String _registerError = '';

  final PatientService _patientService = PatientService();

  // Getters
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

  RegisterState get registerState => _registerState;
  String get registerError => _registerError;

  String? _nameError;
  String? _phoneError;
  String? _addressError;
  String? _totalAmountError;
  String? _discountError;
  String? _advanceError;
  String? _balanceError;
  String? _treatmentDateError;
  String? _treatmentTimeError;
  String? _locationError;

 
  String? get nameError => _nameError;
  String? get phoneError => _phoneError;
  String? get addressError => _addressError;
  String? get totalAmountError => _totalAmountError;
  String? get discountError => _discountError;
  String? get advanceError => _advanceError;
  String? get balanceError => _balanceError;
  String? get treatmentDateError => _treatmentDateError;
  String? get treatmentTimeError => _treatmentTimeError;
  String? get locationError => _locationError;
  String? get branchError => _balanceError;

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
    } catch (e) {
      _branchState = BranchState.Error;
      _branchesData = [];
    }

    notifyListeners();
  }

  Future<bool> registerPatient({
    required String name,
    required String executive,
    required String payment,
    required String phone,
    required String address,
    required double totalAmount,
    required double discountAmount,
    required double advanceAmount,
    required double balanceAmount,
    required String dateTime,
    required List<String> male,
    required List<String> female,
    required String branch,
    required List<String> treatments,
  }) async {
    _registerState = RegisterState.Loading;
    _registerError = '';
    notifyListeners();

    try {
      final success = await _patientService.registerPatient(
        name: name,
        excecutive: executive,
        payment: payment,
        phone: phone,
        address: address,
        totalAmount: totalAmount,
        discountAmount: discountAmount,
        advanceAmount: advanceAmount,
        balanceAmount: balanceAmount,
        dateNdTime: dateTime,
        male: male,
        female: female,
        branch: branch,
        treatments: treatments,
      );

      if (success) {
        _registerState = RegisterState.Success;
        //await fetchPatients();
      } else {
        _registerState = RegisterState.Error;
        _registerError = 'Failed to register patient';
      }
    } catch (e) {
      _registerState = RegisterState.Error;
      _registerError = e.toString();
    }

    notifyListeners();
    return _registerState == RegisterState.Success;
  }

  void resetRegisterState() {
    _registerState = RegisterState.Initial;
    _registerError = '';
    notifyListeners();
  }

  void setNameError(String? error) {
    _nameError = error;
    notifyListeners();
  }

  void setPhoneError(String? error) {
    _phoneError = error;
    notifyListeners();
  }

  void setAddressError(String? error) {
    _addressError = error;
    notifyListeners();
  }

  void setTotalAmountError(String? error) {
    _totalAmountError = error;
    notifyListeners();
  }

  void setDiscountError(String? error) {
    _discountError = error;
    notifyListeners();
  }

  void setAdvanceError(String? error) {
    _advanceError = error;
    notifyListeners();
  }

  void setBalanceError(String? error) {
    _balanceError = error;
    notifyListeners();
  }

  void setTreatmentDateError(String? error) {
    _treatmentDateError = error;
    notifyListeners();
  }

  void setBranchError(String? error) {
    notifyListeners();
  }

  void setTreatmentTimeError(String? error) {
    _treatmentTimeError = error;
    notifyListeners();
  }

  void setLocationError(String? error) {
    _locationError = error;
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

    _registerState = RegisterState.Initial;
    _registerError = '';

    notifyListeners();
  }

  void clearAllFieldErrors() {
    _nameError = null;
    _phoneError = null;
    _addressError = null;
    _totalAmountError = null;
    _discountError = null;
    _advanceError = null;
    _balanceError = null;
    _treatmentDateError = null;
    _treatmentTimeError = null;
    notifyListeners();
  }
}
