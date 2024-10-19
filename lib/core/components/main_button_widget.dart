import 'package:flutter/material.dart';

import '../theme/style/box_decorations.dart';
import '../theme/style/text_styles.dart';

class MainButtonWidget extends StatelessWidget {
  final VoidCallback buttonFunction;
  final String buttonText;

  const MainButtonWidget(
      {super.key, required this.buttonFunction, required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: TextButton(
        onPressed: () {
          buttonFunction();
        },
        style: AppDecoration.mainButtonStyle,
        child: Text(
          buttonText,
          style: AppTextStyle.whiteSemiBoldTextStyle24,
        ),
      ),
    );
  }
}
