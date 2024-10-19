import 'package:flutter/material.dart';

import '../theme/colors.dart';

class CustomButtonAuth extends StatelessWidget {
  final void Function()? onPressed;
  final String title;

  const CustomButtonAuth({super.key, this.onPressed, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsetsDirectional.symmetric(horizontal: 20, vertical: 16),
      child: MaterialButton(
        height: 40,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        color: ColorManager.mainColor,
        textColor: Colors.white,
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
