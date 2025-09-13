import 'package:ayurveda/widgets/theme.dart';
import 'package:ayurveda/widgets/toast_msg.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndLogin() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.clearFieldErrors();

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    bool hasError = false;

    if (email.isEmpty) {
      authProvider.setUsernameError('Username is required');
      hasError = true;
    }
    if (password.isEmpty) {
      authProvider.setPasswordError('Password is required');
      hasError = true;
    }
    if (hasError) return;

    final success = await authProvider.login(email, password);
    if (success) {
      final msg = 'Login successful';
      showSnackBar(context, msg, bgColor: MainTheme.primaryGreen);
      Modular.to.navigate(Routes.homeScreen);
    } else {
      final msg = authProvider.errorMessage ?? 'Login failed';
      showSnackBar(context, msg, bgColor: Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'assets/images/banner1.webp',
                        width: 1.sw,
                        fit: BoxFit.contain,
                      ),
                      Image.asset(
                        'assets/images/logo.webp',
                        width: 80.w,
                        height: 80.w,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          'Login Or Register To Book\nYour Appointments',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontSize: 25.sp,
                            color: MainTheme.textBlack,
                            fontWeight: FontWeight.w600,
                            fontFamily: "poppinsSemiBold",
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'User Name',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: MainTheme.textBlack,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "poppins",
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Container(
                                height: 46.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F1F1),
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(
                                    color: auth.usernameError != null
                                        ? Colors.red
                                        : const Color(0xFFE0E0E0),
                                    width: auth.usernameError != null
                                        ? 1.5
                                        : 1.0,
                                  ),
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                    hintText: 'Enter your user name',
                                    isDense: true,
                                    hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black.withOpacity(0.4),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "poppins",
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(
                                      12.w,
                                      8.h,
                                      0.w,
                                      0.h,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    if (auth.usernameError != null &&
                                        value.trim().isNotEmpty) {
                                      auth.setUsernameError(null);
                                    }
                                  },
                                ),
                              ),
                              if (auth.usernameError != null) ...[
                                SizedBox(height: 5.h),
                                Text(
                                  auth.usernameError!,
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
                        SizedBox(height: 20.h),
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: MainTheme.textBlack,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "poppins",
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Container(
                                height: 46.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF1F1F1),
                                  borderRadius: BorderRadius.circular(6.r),
                                  border: Border.all(
                                    color: auth.passwordError != null
                                        ? Colors.red
                                        : const Color(0xFFE0E0E0),
                                    width: auth.passwordError != null
                                        ? 1.5
                                        : 1.0,
                                  ),
                                ),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    hintText: 'Enter password',
                                    isDense: true,
                                    hintStyle: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.black.withOpacity(0.4),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: "poppins",
                                    ),
                                    contentPadding: EdgeInsets.fromLTRB(
                                      12.w,
                                      8.h,
                                      0.w,
                                      0.h,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    if (auth.passwordError != null &&
                                        value.trim().isNotEmpty) {
                                      auth.setPasswordError(null);
                                    }
                                  },
                                ),
                              ),
                              if (auth.passwordError != null) ...[
                                SizedBox(height: 5.h),
                                Text(
                                  auth.passwordError!,
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return SizedBox(
                      width: 1.sw,
                      height: 50.h,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MainTheme.primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                        ),
                        onPressed: auth.isLoading ? null : _validateAndLogin,
                        child: auth.isLoading
                            ? const CupertinoActivityIndicator()
                            : Text(
                                'Login',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  color: MainTheme.commonWhite,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: "poppinsSemiBold",
                                ),
                              ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 10.h),
                Text.rich(
                  TextSpan(
                    text:
                        'By creating or logging into an account you are agreeing\n',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: MainTheme.commonBlack,
                      fontWeight: FontWeight.w300,
                      fontFamily: "poppins",
                    ),
                    children: [
                      TextSpan(
                        text: 'our Terms and Conditions',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w300,
                          fontFamily: "poppins",
                        ),
                      ),
                      TextSpan(
                        text: ' and ',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: MainTheme.commonBlack,
                          fontWeight: FontWeight.w300,
                          fontFamily: "poppins",
                        ),
                      ),
                      TextSpan(
                        text: 'Privacy Policy.',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w300,
                          fontFamily: "poppins",
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
