import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../routes.dart';
import '../core/shared_preference.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () async {
      final loggedIn = await getLoginStatus();
      if (!mounted) return;
      Modular.to.navigate(loggedIn ? Routes.homeScreen : Routes.loginScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Image.asset('assets/images/logo_bg.webp', fit: BoxFit.cover),
          ),
          Center(
            child: Image.asset(
              'assets/images/logo.webp',
              width: 160.w,
              height: 160.w,
            ),
          ),
        ],
      ),
    );
  }
}


