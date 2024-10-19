import 'package:flutter/material.dart';

import '../../../../../core/theme/colors.dart';

class DrawerCardWidget extends StatelessWidget {
  final String mainText;
  final VoidCallback cardFunction;
  final IconData cardIcon;

  const DrawerCardWidget(
      {super.key,
      required this.mainText,
      required this.cardFunction,
      required this.cardIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: cardFunction,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  mainText,
                  style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 18,
                      color: ColorManager.mainColor,
                      fontWeight: FontWeight.w500),
                ),
                Icon(
                  cardIcon,
                  size: 24,
                  color: ColorManager.mainColor,
                ),
              ],
            ),
          ),
        ),
        Divider()
      ],
    );
  }
}
