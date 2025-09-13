import 'package:flutter/material.dart';
import 'theme.dart';

showSnackBar(BuildContext context, content, {Color? bgColor}) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        content,
        style: TextStyle(fontSize: 16, color: MainTheme.commonWhite),
      ),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 3),
      backgroundColor: bgColor ?? Color(0xff1345aa),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      animation: CurvedAnimation(
        parent: AnimationController(
          vsync: ScaffoldMessenger.of(context),
          duration: const Duration(milliseconds: 300),
        )..forward(),
        curve: Curves.bounceIn,
      ),
    ),
  );
}
