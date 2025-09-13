import 'package:flutter/material.dart';
import '../network/login_network.dart';
import '../core/shared_preference.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _usernameError;
  String? _passwordError;
  
  // Register screen error fields
  String? _nameError;
  String? _phoneError;
  String? _addressError;
  String? _totalAmountError;
  String? _discountError;
  String? _advanceError;
  String? _balanceError;
  String? _treatmentDateError;
  String? _treatmentTimeError;
  String? _branchError;
  String? _treatmentError;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get usernameError => _usernameError;
  String? get passwordError => _passwordError;
  
  // Register screen error getters
  String? get nameError => _nameError;
  String? get phoneError => _phoneError;
  String? get addressError => _addressError;
  String? get totalAmountError => _totalAmountError;
  String? get discountError => _discountError;
  String? get advanceError => _advanceError;
  String? get balanceError => _balanceError;
  String? get treatmentDateError => _treatmentDateError;
  String? get treatmentTimeError => _treatmentTimeError;
  String? get branchError => _branchError;
  String? get treatmentError => _treatmentError;

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final api = ApiService();
      final result = await api.login(email, password);
      if (result) {
        await saveLoginStatus(true);
        return true;
      } else {
        _errorMessage = 'Invalid credentials';
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setUsernameError(String? message) {
    _usernameError = message;
    notifyListeners();
  }

  void setPasswordError(String? message) {
    _passwordError = message;
    notifyListeners();
  }

  // Register screen error setters
  void setNameError(String? message) {
    _nameError = message;
    notifyListeners();
  }

  void setPhoneError(String? message) {
    _phoneError = message;
    notifyListeners();
  }

  void setAddressError(String? message) {
    _addressError = message;
    notifyListeners();
  }

  void setTotalAmountError(String? message) {
    _totalAmountError = message;
    notifyListeners();
  }

  void setDiscountError(String? message) {
    _discountError = message;
    notifyListeners();
  }

  void setAdvanceError(String? message) {
    _advanceError = message;
    notifyListeners();
  }

  void setBalanceError(String? message) {
    _balanceError = message;
    notifyListeners();
  }

  void setTreatmentDateError(String? message) {
    _treatmentDateError = message;
    notifyListeners();
  }

  void setTreatmentTimeError(String? message) {
    _treatmentTimeError = message;
    notifyListeners();
  }

  void setBranchError(String? message) {
    _branchError = message;
    notifyListeners();
  }

  void setTreatmentError(String? message) {
    _treatmentError = message;
    notifyListeners();
  }

  void clearFieldErrors() {
    _usernameError = null;
    _passwordError = null;
    notifyListeners();
  }

  void clearRegisterFieldErrors() {
    _nameError = null;
    _phoneError = null;
    _addressError = null;
    _totalAmountError = null;
    _discountError = null;
    _advanceError = null;
    _balanceError = null;
    _treatmentDateError = null;
    _treatmentTimeError = null;
    _branchError = null;
    _treatmentError = null;
    notifyListeners();
  }
}
