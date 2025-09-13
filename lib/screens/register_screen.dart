import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../providers/patient_provider.dart';
import '../widgets/theme.dart';

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
  String? _selectedTreatmentTime;

  List<Map<String, dynamic>> _treatments = [];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: SafeArea(
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
                SizedBox(height: 10.h),
                _buildTextField(
                  label: 'Name',
                  controller: _nameController,
                  hintText: 'Enter your full name',
                ),
                SizedBox(height: 20.h),
                _buildTextField(
                  label: 'Whatsapp Number',
                  controller: _whatsappController,
                  hintText: 'Enter your Whatsapp number',
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20.h),
                _buildTextField(
                  label: 'Address',
                  controller: _addressController,
                  hintText: 'Enter your full address',
                  maxLines: 3,
                ),
                SizedBox(height: 20.h),
                _buildDropdownField(
                  label: 'Location',
                  value: _selectedLocation,
                  hint: 'Choose your location',
                  items: ['Location 1', 'Location 2', 'Location 3'],
                  onChanged: (value) =>
                      setState(() => _selectedLocation = value),
                ),
                SizedBox(height: 20),

                Consumer<PatientProvider>(
                  builder: (context, provider, child) {
                    switch (provider.branchState) {
                      case BranchState.Loading:
                        return _buildDropdownField(
                          label: 'Loading...',
                          value: _selectedBranch,
                          hint: 'Select the branch',
                          items: [],
                          onChanged: (p0) {},
                        );
                      case BranchState.Error:
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 10.h,
                          ),
                          child: Text(
                            provider.branchError,
                            style: TextStyle(color: Colors.red),
                          ),
                        );

                      case BranchState.Loaded:
                        final branchNames = provider.branches
                            .map((branch) => branch.name)
                            .toList();

                        return _buildDropdownField(
                          label: 'Branch',
                          value: _selectedBranch,
                          hint: 'Select the branch',
                          items: branchNames,
                          onChanged: (value) =>
                              setState(() => _selectedBranch = value),
                        );

                      default:
                        return _buildDropdownField(
                          label: 'Branch',
                          value: null,
                          hint: 'Select the branch',
                          items: [],
                          onChanged: (_) {},
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
                                    initialValue: treatment['male'].toString(),
                                    textAlign: TextAlign.center,
                                    readOnly: true,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
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
                                        borderRadius: BorderRadius.circular(4),
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

                SizedBox(height: 20),
                _buildTextField(
                  label: 'Total Amount',
                  controller: _totalAmountController,
                  hintText: '',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: 'Discount Amount',
                  controller: _discountController,
                  hintText: '',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 10),
                Row(
                  children: [
                    _buildPaymentOption('Cash'),
                    SizedBox(width: 20),
                    _buildPaymentOption('Card'),
                    SizedBox(width: 20),
                    _buildPaymentOption('UPI'),
                  ],
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: 'Advance Amount',
                  controller: _advanceController,
                  hintText: '',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: 'Balance Amount',
                  controller: _balanceController,
                  hintText: '',
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  label: 'Treatment Date',
                  controller: _treatmentDateController,
                  hintText: '',
                  suffixIcon: Icon(Icons.calendar_today, color: Colors.grey),

                  onTap: () => _selectDate(),
                ),
                SizedBox(height: 20),
                _buildDropdownField(
                  label: 'Treatment Time',
                  value: _selectedTreatmentTime,
                  hint: 'Minutes',
                  items: ['30 Minutes', '60 Minutes', '90 Minutes'],
                  onChanged: (value) =>
                      setState(() => _selectedTreatmentTime = value),
                ),
                SizedBox(height: 30),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _submitForm();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Save',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
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
          SizedBox(height: 8),
          Container(
            height: 50.h,
            width: 1.sw,
            child: TextFormField(
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: MainTheme.commonBlack.withOpacity(0.1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: MainTheme.commonBlack.withOpacity(0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: MainTheme.primaryGreen),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 16,
                ),
                filled: true,
                fillColor: Color(0xffF1F1F1),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'This field is required';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String? value,
    required String hint,
    required List<String> items,
    required Function(String?) onChanged,
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
          SizedBox(height: 8),
          Container(
            height: 50.h,
            width: 1.sw,
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
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: MainTheme.commonBlack.withOpacity(0.1),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: MainTheme.commonBlack.withOpacity(0.1),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: MainTheme.primaryGreen),
                ),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select an option';
                }
                return null;
              },
            ),
          ),
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
    }
  }

  void _submitForm() {
    print('Form submitted!');
    print('Treatments: $_treatments');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Registration saved successfully!')));
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
  int _maleCount = 0;
  int _femaleCount = 0;

  @override
  void initState() {
    super.initState();
    if (widget.initialTreatment != null) {
      _selectedTreatment = widget.initialTreatment!['name'];
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
                          'name': _selectedTreatment!,
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
        final treatmentOptions = patientProvider.treatments
            .map((treatment) => treatment.name)
            .toList();

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
          isExpanded:
              true, // This is the key fix - ensures dropdown takes full width
          items: treatmentOptions.map((String treatment) {
            return DropdownMenuItem<String>(
              value: treatment,
              child: Text(
                treatment,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontFamily: 'poppins',
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis, // Handle long treatment names
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedTreatment = newValue;
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
