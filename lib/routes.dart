import 'package:elrazy_clinics/view/auth/sign_up/signup.dart';
import 'package:elrazy_clinics/view/main/home/home.dart';
import 'package:flutter/cupertino.dart';

import 'view/auth/login/login.dart';

Map<String, Widget Function(BuildContext)> routes = {
  AppRoute.login: (context) => const Login(),
  AppRoute.signUp: (context) => const SignUp(),
  AppRoute.homepage: (context) => const HomeScreen(),
  // AppRoute.Account: (context) => ProfileScreen(),
  // AppRoute.editAccount: (context) => const EditAccountScreen(),
  // AppRoute.Contacts: (context) => const ContactScreen(),
  // AppRoute.quizScreen: (context) => const QuizScreen(),
};

//
class AppRoute {
  static const String login = "/login";

  static const String signUp = "/signUp";

  static const String homepage = "homepage";

  static const String Account = "Account";
  static const String Contacts = "Contacts";
  static const String editAccount = "EditAccount";
  static const String quizScreen = "QuizScreen";
}
