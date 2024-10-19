import 'package:flutter/material.dart';

import '../colors.dart';

class AppDecoration {
  static BoxDecoration welcomeImageDecoration = BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Colors.white,
        Colors.white.withOpacity(0.0),
      ],
      begin: Alignment.bottomCenter,
      end: Alignment.topCenter,
      stops: const [0.14, 0.4],
    ),
  );

  static ButtonStyle mainButtonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(
      ColorManager.mainColor,
    ),
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    minimumSize: MaterialStateProperty.all(
      const Size(double.infinity, 32),
    ),
    shape: MaterialStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
}
