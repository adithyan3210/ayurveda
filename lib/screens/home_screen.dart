import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/patient_provider.dart';
import '../routes.dart';
import '../widgets/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedSort = 'Date';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PatientProvider>(context, listen: false).fetchPatients();
    });

    // Add listener to search controller for real-time search
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    Provider.of<PatientProvider>(
      context,
      listen: false,
    ).searchPatients(_searchController.text);
  }

  void _performSearch() {
    Provider.of<PatientProvider>(
      context,
      listen: false,
    ).searchPatients(_searchController.text);
  }

  void _clearSearch() {
    _searchController.clear();
    Provider.of<PatientProvider>(context, listen: false).clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
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
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46.h,
                          decoration: BoxDecoration(
                            color: MainTheme.commonWhite,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: MainTheme.commonBlack.withOpacity(0.2),
                            ),
                          ),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search for patients',
                              hintStyle: TextStyle(
                                fontSize: 14.sp,
                                color: MainTheme.commonBlack.withOpacity(0.2),
                                fontFamily: "poppins",
                              ),
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.fromLTRB(
                                10.w,
                                10.h,
                                50.w,
                                0,
                              ),
                              prefix: Padding(
                                padding: EdgeInsets.only(right: 5.w),
                                child: Image.asset(
                                  "assets/icons/search.webp",
                                  width: 18.w,
                                  height: 18.w,
                                ),
                              ),
                              suffixIcon: Consumer<PatientProvider>(
                                builder: (context, provider, child) {
                                  return provider.search.isNotEmpty
                                      ? IconButton(
                                          onPressed: _clearSearch,
                                          icon: Icon(
                                            Icons.clear,
                                            size: 18.sp,
                                            color: MainTheme.commonBlack
                                                .withOpacity(0.5),
                                          ),
                                        )
                                      : SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      GestureDetector(
                        onTap: _performSearch,
                        child: Container(
                          height: 40.h,
                          width: 80.w,
                          decoration: BoxDecoration(
                            color: MainTheme.primaryGreen,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Center(
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: MainTheme.commonWhite,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: "poppins",
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Row(
                    children: [
                      Text(
                        'Sort by :',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: MainTheme.commonBlack,
                          fontFamily: "poppins",
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 40.h,
                        width: 160.w,
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          color: MainTheme.commonWhite,
                          borderRadius: BorderRadius.circular(20.r),
                          border: Border.all(
                            color: MainTheme.commonBlack.withOpacity(0.2),
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                selectedSort,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: MainTheme.commonBlack,
                                  fontFamily: "poppins",
                                ),
                              ),
                              Spacer(),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 16.sp,
                                color: MainTheme.commonBlack.withOpacity(0.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Search results indicator
                  Consumer<PatientProvider>(
                    builder: (context, provider, child) {
                      if (provider.search.isNotEmpty) {
                        return Padding(
                          padding: EdgeInsets.only(top: 10.h),
                          child: Row(
                            children: [
                              Text(
                                'Search results for "${provider.search}" (${provider.patients.length} found)',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: MainTheme.commonBlack.withOpacity(0.5),
                                  fontFamily: "poppins",
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                  Divider(height: 40.h),
                ],
              ),
            ),
            Expanded(
              child: Consumer<PatientProvider>(
                builder: (context, patientProvider, child) {
                  switch (patientProvider.patientState) {
                    case PatientState.Loading:
                      return Center(
                        child: CupertinoActivityIndicator(
                          color: MainTheme.primaryGreen,
                        ),
                      );
                    case PatientState.Error:
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 48.sp,
                              color: Colors.red,
                            ),
                            SizedBox(height: 16.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
                              child: Text(
                                patientProvider.errorMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.red,
                                  fontFamily: "poppins",
                                ),
                              ),
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () => patientProvider.fetchPatients(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: MainTheme.primaryGreen,
                              ),
                              child: Text(
                                'Retry',
                                style: TextStyle(
                                  color: MainTheme.commonWhite,
                                  fontFamily: "poppins",
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    case PatientState.Loaded:
                      if (patientProvider.patients.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                patientProvider.search.isEmpty
                                    ? Icons.people_outline
                                    : Icons.search_off,
                                size: 48.sp,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16.h),
                              Text(
                                patientProvider.search.isEmpty
                                    ? 'No patients found'
                                    : 'No patients match your search',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: MainTheme.commonBlack.withOpacity(0.5),
                                  fontFamily: "poppins",
                                ),
                              ),
                              if (patientProvider.search.isNotEmpty) ...[
                                SizedBox(height: 8.h),
                                TextButton(
                                  onPressed: _clearSearch,
                                  child: Text(
                                    'Clear search',
                                    style: TextStyle(
                                      color: MainTheme.primaryGreen,
                                      fontFamily: "poppins",
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        );
                      }
                      return ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: patientProvider.patients.length,
                        itemBuilder: (context, index) {
                          final patient = patientProvider.patients[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 16.h),
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Color(0xffF1F1F1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${index + 1}.',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: MainTheme.commonBlack,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(width: 5.w),
                                    Expanded(
                                      child: Text(
                                        patient.name,
                                        style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.w500,
                                          color: MainTheme.commonBlack,
                                          fontFamily: "poppinsMedium",
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 20.w),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        patient.patientdetailsSet
                                            .map((detail) {
                                              final name =
                                                  detail.treatmentName
                                                      ?.trim() ??
                                                  '';
                                              return name.isEmpty
                                                  ? 'Treatment not specified'
                                                  : name;
                                            })
                                            .join(', '),
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: MainTheme.primaryGreen,
                                          fontFamily: "poppins",
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Row(
                                        children: [
                                          Image.asset(
                                            "assets/icons/calender.webp",
                                            width: 16.w,
                                            height: 16.w,
                                            color: Color(0xffF24E1E),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            patient.dateNdTime != null
                                                ? DateFormat(
                                                    'dd/MM/yyyy',
                                                  ).format(patient.dateNdTime!)
                                                : 'No date available',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: MainTheme.commonBlack
                                                  .withOpacity(0.5),
                                              fontFamily: "poppins",
                                            ),
                                          ),
                                          SizedBox(width: 15.w),
                                          Image.asset(
                                            "assets/icons/person.webp",
                                            width: 16.w,
                                            height: 16.w,
                                            color: Color(0xffF24E1E),
                                          ),
                                          SizedBox(width: 8.w),
                                          Text(
                                            patient.user,
                                            style: TextStyle(
                                              fontSize: 15.sp,
                                              color: MainTheme.commonBlack
                                                  .withOpacity(0.5),
                                              fontFamily: "poppins",
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(height: 20.h),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 20.w,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'View Booking details',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: MainTheme.commonBlack,
                                          fontFamily: "poppins",
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 16.sp,
                                        color: MainTheme.primaryGreen,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    default:
                      return Center(
                        child: Text(
                          'Welcome! Tap to load patients',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: MainTheme.commonBlack,
                            fontFamily: "poppins",
                          ),
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 10.h, left: 20.w, right: 20.w),
        child: SizedBox(
          height: 50.h,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: MainTheme.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onPressed: () {
              Modular.to.pushNamed(Routes.registerScreen);
            },
            child: Text(
              'Register Now',
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
    );
  }
}
