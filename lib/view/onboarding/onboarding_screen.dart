import 'package:elrazy_clinics/view/auth/sign_up/signup.dart';
import 'package:flutter/material.dart';

import '../../core/components/main_button_widget.dart';
import '../../core/theme/style/box_decorations.dart';
import '../../core/theme/style/text_styles.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                Stack(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.width * 1.1,
                      foregroundDecoration:
                          AppDecoration.welcomeImageDecoration,
                      child: Image.asset('images/logo.png'),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Text(
                        'El Razzy Clinics',
                        style: AppTextStyle.mainColorBoldTextStyle24,
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: [
                      SizedBox(height: 32),
                      Text(
                        'Easily evaluate your patients condition with our algorithm for better assessment ',
                        style: AppTextStyle.infoBlackTextStyle16,
                      ),
                      const SizedBox(height: 30),
                      MainButtonWidget(
                        buttonFunction: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignUp(),
                            ),
                          );
                          print('is pressed');
                        },
                        buttonText: 'Get Started',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
