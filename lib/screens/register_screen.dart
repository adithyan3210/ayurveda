import 'package:ayurveda/widgets/theme.dart';
import 'package:ayurveda/widgets/toast_msg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../providers/patient_provider.dart';
import '../services/pdf_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _addressController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _discountController = TextEditingController();
  final _advanceController = TextEditingController();
  final _balanceController = TextEditingController();
  final _treatmentDateController = TextEditingController();

  String? _selectedLocation;
  String? _selectedBranch;
  String? _selectedPaymentOption = 'Cash';
  String? _selectedTreatmentHour;
  String? _selectedTreatmentMinutes;
  final List<Map<String, dynamic>> _treatments = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PatientProvider>(context, listen: false);
      if (provider.treatmentState == TreatmentState.Initial) {
        provider.fetchTreatments();
      }
      if (provider.branchState == BranchState.Initial) {
        provider.fetchBranches();
      }
    });
  }

  void showAddTreatmentModal() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AddTreatmentModal(
          onTreatmentAdded: (treatmentData) {
            setState(() {
              _treatments.add(treatmentData);
            });
          },
        );
      },
    );
  }

  void _removeTreatment(int index) {
    setState(() {
      _treatments.removeAt(index);
    });
  }

  void _editTreatment(int index) {
    final treatment = _treatments[index];
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AddTreatmentModal(
          initialTreatment: treatment,
          onTreatmentAdded: (treatmentData) {
            setState(() {
              _treatments[index] = treatmentData;
            });
          },
        );
      },
    );
  }

  void _validateAndSubmit() async {
    final provider = Provider.of<PatientProvider>(context, listen: false);
    provider.clearAllFieldErrors();

    final name = _nameController.text.trim();
    final phone = _whatsappController.text.trim();
    final address = _addressController.text.trim();
    final totalAmount = _totalAmountController.text.trim();
    final discountAmount = _discountController.text.trim();
    final advanceAmount = _advanceController.text.trim();
    final balanceAmount = _balanceController.text.trim();
    final treatmentDate = _treatmentDateController.text.trim();

    bool hasError = false;

    if (name.isEmpty) {
      provider.setNameError('Name is required');
      hasError = true;
    }

    if (phone.isEmpty) {
      provider.setPhoneError('WhatsApp number is required');
      hasError = true;
    } else if (phone.length < 10) {
      provider.setPhoneError('Please enter a valid phone number');
      hasError = true;
    }

    if (address.isEmpty) {
      provider.setAddressError('Address is required');
      hasError = true;
    }

    if (_selectedLocation == null) {
      provider.setLocationError('Location is required');
      hasError = true;
    }

    if (_selectedBranch == null) {
      provider.setBranchError('Branch is required');
      hasError = true;
    }

    if (totalAmount.isEmpty) {
      provider.setTotalAmountError('Total amount is required');
      hasError = true;
    } else if (double.tryParse(totalAmount) == null) {
      provider.setTotalAmountError('Please enter a valid amount');
      hasError = true;
    }

    if (discountAmount.isNotEmpty && double.tryParse(discountAmount) == null) {
      provider.setDiscountError('Please enter a valid discount amount');
      hasError = true;
    }

    if (advanceAmount.isEmpty) {
      provider.setAdvanceError('Advance amount is required');
      hasError = true;
    } else if (double.tryParse(advanceAmount) == null) {
      provider.setAdvanceError('Please enter a valid advance amount');
      hasError = true;
    }

    if (balanceAmount.isEmpty) {
      provider.setBalanceError('Balance amount is required');
      hasError = true;
    } else if (double.tryParse(balanceAmount) == null) {
      provider.setBalanceError('Please enter a valid balance amount');
      hasError = true;
    }

    if (treatmentDate.isEmpty) {
      provider.setTreatmentDateError('Treatment date is required');
      hasError = true;
    }

    if (_selectedTreatmentHour == null || _selectedTreatmentMinutes == null) {
      provider.setTreatmentTimeError('Treatment time is required');
      hasError = true;
    }

    if (_treatments.isEmpty) {
      hasError = true;
    }

    if (hasError) return;

    _submitForm();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 10.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Icon(
                            Icons.arrow_back,
                            size: 25.sp,
                            color: MainTheme.commonBlack,
                          ),
                        ),
                        Image.asset(
                          "assets/icons/notification.webp",
                          width: 24.w,
                          height: 24.w,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w600,
                        color: MainTheme.commonBlack,
                        fontFamily: "poppinsMedium",
                      ),
                    ),
                  ),
                  Divider(height: 20.h),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 100.h),
                physics: BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 10.h),

                    _buildTextField(
                      label: 'Name',
                      controller: _nameController,
                      hintText: 'Enter your full name',
                      getError: (provider) => provider.nameError,
                      setError: (provider, error) =>
                          provider.setNameError(error),
                    ),
                    SizedBox(height: 20.h),

                    _buildTextField(
                      label: 'Whatsapp Number',
                      controller: _whatsappController,
                      hintText: 'Enter your Whatsapp number',
                      keyboardType: TextInputType.phone,
                      getError: (provider) => provider.phoneError,
                      setError: (provider, error) =>
                          provider.setPhoneError(error),
                    ),
                    SizedBox(height: 20.h),

                    _buildTextField(
                      label: 'Address',
                      controller: _addressController,
                      hintText: 'Enter your full address',
                      maxLines: 3,
                      getError: (provider) => provider.addressError,
                      setError: (provider, error) =>
                          provider.setAddressError(error),
                    ),
                    SizedBox(height: 20.h),

                    Consumer<PatientProvider>(
                      builder: (context, provider, child) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Location',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: MainTheme.textBlack,
                                  fontFamily: 'poppins',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Container(
                                height: 50.h,
                                width: 1.sw,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: provider.locationError != null
                                        ? Colors.red
                                        : MainTheme.commonBlack.withOpacity(
                                            0.1,
                                          ),
                                    width: provider.locationError != null
                                        ? 1.5
                                        : 1.0,
                                  ),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: _selectedLocation,
                                  hint: Text(
                                    'Choose your location',
                                    style: TextStyle(
                                      color: MainTheme.commonBlack.withOpacity(
                                        0.4,
                                      ),
                                      fontWeight: FontWeight.w300,
                                      fontSize: 13.sp,
                                      fontFamily: 'poppins',
                                    ),
                                  ),
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 15.w,
                                      vertical: 0,
                                    ),
                                    filled: true,
                                    fillColor: Color(0xffF1F1F1),
                                  ),
                                  items:
                                      [
                                        'Wayanad',
                                        'Calicut',
                                        'Malappuram',
                                        'Thrissur',
                                        'Ernankulam',
                                        'Kannur',
                                        'Trivandrum',
                                      ].map((String item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item),
                                        );
                                      }).toList(),
                                  onChanged: (value) {
                                    setState(() => _selectedLocation = value);
                                    if (provider.locationError != null &&
                                        value != null) {
                                      provider.setLocationError(null);
                                    }
                                  },
                                ),
                              ),
                              if (provider.locationError != null) ...[
                                SizedBox(height: 5.h),
                                Text(
                                  provider.locationError!,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "poppins",
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.h),

                    Consumer<PatientProvider>(
                      builder: (context, provider, child) {
                        switch (provider.branchState) {
                          case BranchState.Loading:
                            return _buildDropdownFieldWithError(
                              label: 'Loading...',
                              value: _selectedBranch,
                              hint: 'Select the branch',
                              items: [],
                              onChanged: (p0) {},
                              error: null,
                            );
                          case BranchState.Error:
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                                vertical: 10.h,
                              ),
                              child: Text(
                                provider.branchError!,
                                style: TextStyle(color: Colors.red),
                              ),
                            );
                          case BranchState.Loaded:
                            final branchNames = provider.branches
                                .map((branch) => branch.name)
                                .toList();
                            return _buildDropdownFieldWithError(
                              label: 'Branch',
                              value: _selectedBranch,
                              hint: 'Select the branch',
                              items: branchNames,
                              onChanged: (value) {
                                setState(() => _selectedBranch = value);
                                if (provider.branchError != null &&
                                    value != null) {
                                  provider.setBranchError(null);
                                }
                              },
                              error: provider.branchError,
                            );
                          default:
                            return _buildDropdownFieldWithError(
                              label: 'Branch',
                              value: null,
                              hint: 'Select the branch',
                              items: [],
                              onChanged: (_) {},
                              error: provider.branchError,
                            );
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Text(
                        'Treatments',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: MainTheme.textBlack,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    if (_treatments.isNotEmpty) ...[
                      ..._treatments.asMap().entries.map((entry) {
                        final index = entry.key;
                        final treatment = entry.value;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 5.h,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${index + 1}. ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        treatment['name'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _removeTreatment(index),
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  children: [
                                    Text(
                                      'Male',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp,
                                        color: MainTheme.primaryGreen,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Container(
                                      width: 50.w,
                                      height: 35.w,
                                      child: TextFormField(
                                        initialValue: treatment['male']
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 40),
                                    Text(
                                      'Female',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16.sp,
                                        color: MainTheme.primaryGreen,
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    Container(
                                      width: 50.w,
                                      height: 35.w,
                                      child: TextFormField(
                                        initialValue: treatment['female']
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        readOnly: true,
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 8,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () => _editTreatment(index),
                                      child: Icon(
                                        Icons.edit,
                                        color: MainTheme.primaryGreen,
                                        size: 20,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                      SizedBox(height: 10.h),
                    ],

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: SizedBox(
                        height: 50.h,
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF389A48).withOpacity(0.3),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          onPressed: showAddTreatmentModal,
                          child: Text(
                            '+ Add Treatment',
                            style: TextStyle(
                              color: MainTheme.commonWhite,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              fontFamily: "poppinsSemiBold",
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    _buildTextField(
                      label: 'Total Amount',
                      controller: _totalAmountController,
                      hintText: '',
                      keyboardType: TextInputType.number,
                      getError: (provider) => provider.totalAmountError,
                      setError: (provider, error) =>
                          provider.setTotalAmountError(error),
                    ),
                    SizedBox(height: 20.h),

                    _buildTextField(
                      label: 'Discount Amount',
                      controller: _discountController,
                      hintText: '',
                      keyboardType: TextInputType.number,
                      getError: (provider) => provider.discountError,
                      setError: (provider, error) =>
                          provider.setDiscountError(error),
                    ),
                    SizedBox(height: 20.h),

                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Text(
                        'Payment Option',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: MainTheme.textBlack,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        _buildPaymentOption('Cash'),
                        SizedBox(width: 20.w),
                        _buildPaymentOption('Card'),
                        SizedBox(width: 20.w),
                        _buildPaymentOption('UPI'),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    _buildTextField(
                      label: 'Advance Amount',
                      controller: _advanceController,
                      hintText: '',
                      keyboardType: TextInputType.number,
                      getError: (provider) => provider.advanceError,
                      setError: (provider, error) =>
                          provider.setAdvanceError(error),
                    ),
                    SizedBox(height: 20.h),

                    _buildTextField(
                      label: 'Balance Amount',
                      controller: _balanceController,
                      hintText: '',
                      keyboardType: TextInputType.number,
                      getError: (provider) => provider.balanceError,
                      setError: (provider, error) =>
                          provider.setBalanceError(error),
                    ),
                    SizedBox(height: 20.h),

                    _buildTextField(
                      label: 'Treatment Date',
                      controller: _treatmentDateController,
                      hintText: '',
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.grey,
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(),
                      getError: (provider) => provider.treatmentDateError,
                      setError: (provider, error) =>
                          provider.setTreatmentDateError(error),
                    ),
                    SizedBox(height: 20.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Consumer<PatientProvider>(
                        builder: (context, provider, _) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Treatment Time',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: MainTheme.textBlack,
                                fontFamily: 'poppins',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color:
                                            provider.treatmentTimeError != null
                                            ? Colors.red
                                            : MainTheme.commonBlack.withOpacity(
                                                0.1,
                                              ),
                                        width:
                                            provider.treatmentTimeError != null
                                            ? 1.5
                                            : 1.0,
                                      ),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedTreatmentHour,
                                      hint: Text(
                                        'Hour',
                                        style: TextStyle(
                                          color: MainTheme.commonBlack
                                              .withOpacity(0.4),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 13.sp,
                                          fontFamily: 'poppins',
                                        ),
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15.w,
                                          vertical: 0,
                                        ),
                                        filled: true,
                                        fillColor: Color(0xffF1F1F1),
                                      ),
                                      items: List.generate(24, (index) {
                                        String hour = index.toString().padLeft(
                                          2,
                                          '0',
                                        );
                                        return DropdownMenuItem<String>(
                                          value: hour,
                                          child: Text(hour),
                                        );
                                      }),
                                      onChanged: (value) {
                                        setState(
                                          () => _selectedTreatmentHour = value,
                                        );
                                        if (provider.treatmentTimeError !=
                                                null &&
                                            value != null &&
                                            _selectedTreatmentMinutes != null) {
                                          provider.setTreatmentTimeError(null);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15.w),

                                Expanded(
                                  child: Container(
                                    height: 50.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color:
                                            provider.treatmentTimeError != null
                                            ? Colors.red
                                            : MainTheme.commonBlack.withOpacity(
                                                0.1,
                                              ),
                                        width:
                                            provider.treatmentTimeError != null
                                            ? 1.5
                                            : 1.0,
                                      ),
                                    ),
                                    child: DropdownButtonFormField<String>(
                                      value: _selectedTreatmentMinutes,
                                      hint: Text(
                                        'Minutes',
                                        style: TextStyle(
                                          color: MainTheme.commonBlack
                                              .withOpacity(0.4),
                                          fontWeight: FontWeight.w300,
                                          fontSize: 13.sp,
                                          fontFamily: 'poppins',
                                        ),
                                      ),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 15.w,
                                          vertical: 0,
                                        ),
                                        filled: true,
                                        fillColor: Color(0xffF1F1F1),
                                      ),
                                      items: List.generate(60, (index) {
                                        String minute = index
                                            .toString()
                                            .padLeft(2, '0');
                                        return DropdownMenuItem<String>(
                                          value: minute,
                                          child: Text(minute),
                                        );
                                      }),
                                      onChanged: (value) {
                                        setState(
                                          () =>
                                              _selectedTreatmentMinutes = value,
                                        );
                                        if (provider.treatmentTimeError !=
                                                null &&
                                            value != null &&
                                            _selectedTreatmentHour != null) {
                                          provider.setTreatmentTimeError(null);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (provider.treatmentTimeError != null) ...[
                              SizedBox(height: 5.h),
                              Text(
                                provider.treatmentTimeError!,
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "poppins",
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 0.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 50.h,
            child: Consumer<PatientProvider>(
              builder: (context, provider, child) {
                return ElevatedButton(
                  onPressed: provider.registerState == RegisterState.Loading
                      ? null
                      : _validateAndSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    disabledBackgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: provider.registerState == RegisterState.Loading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Saving...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Save',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool readOnly = false,
    Widget? suffixIcon,
    VoidCallback? onTap,
    String? Function(PatientProvider)? getError,
    void Function(PatientProvider, String?)? setError,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Consumer<PatientProvider>(
        builder: (context, provider, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16.sp,
                color: MainTheme.textBlack,
                fontFamily: 'poppins',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              height: maxLines > 1 ? null : 50.h,
              width: 1.sw,
              decoration: BoxDecoration(
                color: Color(0xffF1F1F1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: getError != null && getError(provider) != null
                      ? Colors.red
                      : MainTheme.commonBlack.withOpacity(0.1),
                  width: getError != null && getError(provider) != null
                      ? 1.5
                      : 1.0,
                ),
              ),
              child: TextField(
                controller: controller,
                keyboardType: keyboardType,
                maxLines: maxLines,
                readOnly: readOnly,
                onTap: onTap,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: TextStyle(
                    color: MainTheme.commonBlack.withOpacity(0.4),
                    fontWeight: FontWeight.w300,
                    fontSize: 13.sp,
                    fontFamily: 'poppins',
                  ),
                  suffixIcon: suffixIcon,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: maxLines > 1 ? 16.h : 16.h,
                  ),
                ),
                onChanged: (value) {
                  if (getError != null && setError != null) {
                    if (getError(provider) != null && value.trim().isNotEmpty) {
                      setError(provider, null);
                    }
                  }
                },
              ),
            ),
            if (getError != null && getError(provider) != null) ...[
              SizedBox(height: 5.h),
              Text(
                getError(provider)!,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.w400,
                  fontFamily: "poppins",
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownFieldWithError({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
    required String? error,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16.sp,
              color: MainTheme.textBlack,
              fontFamily: 'poppins',
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            height: 50.h,
            width: 1.sw,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: error != null
                    ? Colors.red
                    : MainTheme.commonBlack.withOpacity(0.1),
                width: error != null ? 1.5 : 1.0,
              ),
            ),
            child: DropdownButtonFormField<String>(
              value: value,
              hint: Text(
                hint,
                style: TextStyle(
                  color: MainTheme.commonBlack.withOpacity(0.4),
                  fontWeight: FontWeight.w300,
                  fontSize: 13.sp,
                  fontFamily: 'poppins',
                ),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 15.w,
                  vertical: 0,
                ),
                filled: true,
                fillColor: Color(0xffF1F1F1),
              ),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
          if (error != null) ...[
            SizedBox(height: 5.h),
            Text(
              error,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.red,
                fontWeight: FontWeight.w400,
                fontFamily: "poppins",
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentOption(String option) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
      child: GestureDetector(
        onTap: () => setState(() => _selectedPaymentOption = option),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _selectedPaymentOption == option
                      ? Colors.green[700]!
                      : Colors.grey[400]!,
                  width: 2,
                ),
                color: Colors.transparent,
              ),
              child: _selectedPaymentOption == option
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.green[700],
                        ),
                      ),
                    )
                  : null,
            ),
            SizedBox(width: 8),
            Text(
              option,
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 16.sp,
                fontFamily: 'poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _treatmentDateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });

      final provider = Provider.of<PatientProvider>(context, listen: false);
      if (provider.treatmentDateError != null) {
        provider.setTreatmentDateError(null);
      }
    }
  }

  void _submitForm() async {
    try {
      final provider = Provider.of<PatientProvider>(context, listen: false);

      final dateTime =
          "${_treatmentDateController.text}-$_selectedTreatmentHour:$_selectedTreatmentMinutes";

      List<String> maleList = [];
      List<String> femaleList = [];
      List<String> treatmentNames = [];

      for (var treatment in _treatments) {
        treatmentNames.add(treatment['name']);
        if (treatment['male'] > 0) {
          maleList.add(treatment['male'].toString());
        }
        if (treatment['female'] > 0) {
          femaleList.add(treatment['female'].toString());
        }
      }

      final selectedBranchModel = provider.branches.firstWhere(
        (branch) => branch.name == _selectedBranch,
        orElse: () => throw Exception('Branch not found'),
      );

      final totalAmount = double.tryParse(_totalAmountController.text) ?? 0.0;
      final discountAmount = double.tryParse(_discountController.text) ?? 0.0;
      final advanceAmount = double.tryParse(_advanceController.text) ?? 0.0;
      final balanceAmount = double.tryParse(_balanceController.text) ?? 0.0;

      final success = await provider.registerPatient(
        name: _nameController.text.trim(),
        executive: "Default Executive",
        payment: _selectedPaymentOption ?? 'Cash',
        phone: _whatsappController.text.trim(),
        address: _addressController.text.trim(),
        totalAmount: totalAmount,
        discountAmount: discountAmount,
        advanceAmount: advanceAmount,
        balanceAmount: balanceAmount,
        dateTime: dateTime,
        male: maleList,
        female: femaleList,
        branch: selectedBranchModel.id.toString(),
        treatments: treatmentNames,
      );

      if (success) {
        showSnackBar(
          context,
          'Patient registered successfully!',
          bgColor: MainTheme.primaryGreen,
        );

        // Generate PDF after successful registration
        await _generateAndOpenPDF();

        Navigator.pop(context);
      } else {
        showSnackBar(
          context,
          'Registration failed: ${provider.registerError}',
          bgColor: Colors.red,
        );
      }
    } catch (e) {
      showSnackBar(context, 'Error: $e', bgColor: Colors.red);
    }
  }

  Future<void> _generateAndOpenPDF() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: MainTheme.primaryGreen),
                SizedBox(height: 16),
                Text(
                  'Generating PDF...',
                  style: TextStyle(fontSize: 16, fontFamily: 'poppins'),
                ),
              ],
            ),
          ),
        ),
      );

      // Generate PDF
      final filePath = await PDFService.generatePatientRegistrationPDF(
        patientName: _nameController.text.trim(),
        phoneNumber: _whatsappController.text.trim(),
        address: _addressController.text.trim(),
        location: _selectedLocation ?? 'Not selected',
        branch: _selectedBranch ?? 'Not selected',
        treatments: _treatments,
        totalAmount: _totalAmountController.text.trim(),
        discountAmount: _discountController.text.trim(),
        advanceAmount: _advanceController.text.trim(),
        balanceAmount: _balanceController.text.trim(),
        paymentOption: _selectedPaymentOption ?? 'Cash',
        treatmentDate: _treatmentDateController.text.trim(),
        treatmentTime:
            '${_selectedTreatmentHour ?? '00'}:${_selectedTreatmentMinutes ?? '00'}',
      );

      // Close loading dialog
      Navigator.of(context).pop();

      // Show success dialog with options
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'PDF Generated Successfully!',
            style: TextStyle(fontFamily: 'poppinsMedium', fontSize: 18),
          ),
          content: Text(
            'Patient registration details have been saved as PDF.',
            style: TextStyle(fontFamily: 'poppins', fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Close',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontFamily: 'poppins',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                try {
                  await PDFService.openPDF(filePath);
                } catch (e) {
                  showSnackBar(
                    context,
                    'Failed to open PDF: $e',
                    bgColor: Colors.red,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MainTheme.primaryGreen,
              ),
              child: Text(
                'Open PDF',
                style: TextStyle(color: Colors.white, fontFamily: 'poppins'),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }

      showSnackBar(context, 'Failed to generate PDF: $e', bgColor: Colors.red);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _whatsappController.dispose();
    _addressController.dispose();
    _totalAmountController.dispose();
    _discountController.dispose();
    _advanceController.dispose();
    _balanceController.dispose();
    _treatmentDateController.dispose();
    super.dispose();
  }
}

class AddTreatmentModal extends StatefulWidget {
  final Function(Map<String, dynamic>) onTreatmentAdded;
  final Map<String, dynamic>? initialTreatment;

  const AddTreatmentModal({
    Key? key,
    required this.onTreatmentAdded,
    this.initialTreatment,
  }) : super(key: key);

  @override
  State<AddTreatmentModal> createState() => _AddTreatmentModalState();
}

class _AddTreatmentModalState extends State<AddTreatmentModal> {
  String? _selectedTreatment;
  String? _selectedTreatmentName;
  int _maleCount = 0;
  int _femaleCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialTreatment != null) {
      _selectedTreatment = widget.initialTreatment!['id'];
      _selectedTreatmentName = widget.initialTreatment!['name'];
      _maleCount = widget.initialTreatment!['male'] ?? 0;
      _femaleCount = widget.initialTreatment!['female'] ?? 0;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PatientProvider>(context, listen: false);
      if (provider.treatmentState == TreatmentState.Initial) {
        provider.fetchTreatments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose Treatment',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                fontFamily: 'poppinsMedium',
              ),
            ),
            SizedBox(height: 20.h),
            Consumer<PatientProvider>(
              builder: (context, patientProvider, child) {
                return Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Color(0xffF1F1F1),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.grey.withOpacity(0.3)),
                  ),
                  child: _buildTreatmentDropdown(patientProvider),
                );
              },
            ),
            SizedBox(height: 25.h),
            Text(
              'Add Patients',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontFamily: 'poppins',
              ),
            ),
            SizedBox(height: 15.h),
            _buildPatientCounter('Male', _maleCount, (value) {
              setState(() {
                _maleCount = value;
              });
            }),
            SizedBox(height: 15.h),
            _buildPatientCounter('Female', _femaleCount, (value) {
              setState(() {
                _femaleCount = value;
              });
            }),
            SizedBox(height: 30.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed:
                    _selectedTreatment != null &&
                        (_maleCount > 0 || _femaleCount > 0)
                    ? () {
                        final treatmentData = {
                          'id': _selectedTreatment!,
                          'name': _selectedTreatmentName!,
                          'male': _maleCount,
                          'female': _femaleCount,
                        };
                        widget.onTreatmentAdded(treatmentData);
                        Navigator.of(context).pop();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  disabledBackgroundColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontFamily: 'poppinsSemiBold',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTreatmentDropdown(PatientProvider patientProvider) {
    switch (patientProvider.treatmentState) {
      case TreatmentState.Loading:
        return Center(
          child: SizedBox(
            width: 20.w,
            height: 20.h,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green[700]!),
            ),
          ),
        );

      case TreatmentState.Error:
        return Center(
          child: Text(
            'Failed to load treatments',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14.sp,
              fontFamily: 'poppins',
            ),
          ),
        );

      case TreatmentState.Loaded:
        // Use the treatment ID instead of name to ensure uniqueness
        final treatmentOptions = patientProvider.treatments;

        if (treatmentOptions.isEmpty) {
          return Center(
            child: Text(
              'No treatments available',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
                fontFamily: 'poppins',
              ),
            ),
          );
        }

        return DropdownButtonFormField<String>(
          value: _selectedTreatment,
          hint: Text(
            'Choose preferred treatment',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14.sp,
              fontFamily: 'poppins',
            ),
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 15.w,
              vertical: 10.h,
            ),
            border: InputBorder.none,
          ),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.green[700],
            size: 24.sp,
          ),
          isExpanded: true,
          items: treatmentOptions.map((treatment) {
            return DropdownMenuItem<String>(
              value: treatment.id.toString(), // Use ID instead of name
              child: Text(
                treatment.name,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'poppins',
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedTreatment = newValue;
              // Store both ID and name for later use
              _selectedTreatmentName = treatmentOptions
                  .firstWhere((t) => t.id.toString() == newValue)
                  .name;
            });
          },
        );

      default:
        return Center(
          child: Text(
            'Choose preferred treatment',
            style: TextStyle(
              color: MainTheme.commonBlack.withOpacity(0.4),
              fontSize: 14.sp,
              fontFamily: 'poppins',
            ),
          ),
        );
    }
  }

  Widget _buildPatientCounter(
    String label,
    int count,
    Function(int) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 120.w,
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          decoration: BoxDecoration(
            color: Color(0xffF1F1F1),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
              fontFamily: 'poppins',
            ),
          ),
        ),
        SizedBox(width: 15.w),
        GestureDetector(
          onTap: count > 0 ? () => onChanged(count - 1) : null,
          child: Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              color: count > 0 ? Colors.green[700] : Colors.grey[400],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.remove, color: Colors.white, size: 18.sp),
          ),
        ),
        SizedBox(width: 15.w),
        Container(
          width: 50.w,
          height: 35.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              count.toString(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
                fontFamily: 'poppins',
              ),
            ),
          ),
        ),
        SizedBox(width: 15.w),
        GestureDetector(
          onTap: () => onChanged(count + 1),
          child: Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              color: Colors.green[700],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add, color: Colors.white, size: 18.sp),
          ),
        ),
      ],
    );
  }
}
