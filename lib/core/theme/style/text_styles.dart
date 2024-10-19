import 'package:flutter/material.dart';

import '../colors.dart';

class AppTextStyle {
// white color
  static TextStyle whiteSemiBoldTextStyle24 = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    fontFamily: "poppins",
  );
  static TextStyle cardName = const TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  // main color
  static TextStyle mainColorBoldTextStyle24 = TextStyle(
      color: ColorManager.mainColor, fontSize: 24, fontWeight: FontWeight.w800);

  static TextStyle mainColorBoldTextStyle32 = TextStyle(
      color: ColorManager.mainColor, fontSize: 32, fontWeight: FontWeight.w800);

  static TextStyle mainColorBoldTextStyle20 = TextStyle(
      color: ColorManager.mainColor, fontSize: 20, fontWeight: FontWeight.w800);
  static TextStyle mainColorBoldTextStyle16 = TextStyle(
      color: ColorManager.mainColor,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      fontFamily: 'garet');

  static TextStyle underlineClickTextStyle = TextStyle(
      decoration: TextDecoration.underline,
      decorationColor: ColorManager.secondaryColor,
      color: ColorManager.secondaryColor,
      fontWeight: FontWeight.w900,
      fontSize: 16);

// black color

  static TextStyle blackBoldTextStyle24 = TextStyle(
      color: Colors.black.withOpacity(0.8),
      fontSize: 24,
      fontWeight: FontWeight.w800);

  static TextStyle blackBoldTextStyle22 = TextStyle(
      color: Colors.black.withOpacity(0.8),
      fontSize: 22,
      fontWeight: FontWeight.w800);

  static TextStyle blackBoldTextStyle20 = TextStyle(
      color: Colors.black.withOpacity(0.7),
      fontSize: 20,
      fontWeight: FontWeight.w800);

  static TextStyle infoBlackTextStyle16 = TextStyle(
    fontWeight: FontWeight.w400,
    fontFamily: 'garet',
    fontSize: 16,
  );
  static TextStyle headingBlackBoldTextStyle18 = TextStyle(
    fontWeight: FontWeight.bold,
    fontFamily: 'garet',
    fontSize: 18,
    color: Colors.black.withOpacity(0.8),
  );

  //
  static TextStyle redColorBoldTextStyle16 = TextStyle(
      color: Colors.red,
      fontSize: 16,
      fontWeight: FontWeight.w800,
      fontFamily: 'garet');
}