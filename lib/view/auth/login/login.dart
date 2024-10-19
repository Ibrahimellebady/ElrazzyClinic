import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:elrazy_clinics/core/components/main_button_widget.dart';
import 'package:elrazy_clinics/view/main/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/components/text_formfield.dart';
import '../../../core/constants/constants.dart';
import '../../../core/theme/colors.dart';
import '../../../routes.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Form(
                    key: formState,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(height: 20),
                        const Text("Login",
                            style: TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        Container(height: 10),
                        const Text("Login To Continue Using The App",
                            style: TextStyle(color: Colors.grey)),
                        Container(height: 20),
                        const Text(
                          "Email",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        CustomTextForm(
                          hinttext: "ُEnter Your Email",
                          mycontroller: email,
                          validator: (val) {
                            if (val == "") {
                              return "Can't To be Empty";
                            }
                            return null;
                          },
                          width: MediaQuery.of(context).size.width,
                        ),
                        const Text(
                          "Password",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        CustomTextForm(
                          width: MediaQuery.of(context).size.width,
                          hinttext: "ُEnter Your Password",
                          mycontroller: password,
                          validator: (val) {
                            if (val == "") {
                              return "Can't To be Empty";
                            }
                          },
                        ),
                        InkWell(
                          onTap: () async {
                            if (email.text == "") {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    "الرجاء كتابة البريد الالكتروني ثم قم بالضغط على Forget Password",
                              ).show();
                              return;
                            }

                            try {
                              await FirebaseAuth.instance
                                  .sendPasswordResetEmail(email: email.text);
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    'لقد تم ارسال لينك لاعادة تعيين كلمة المرور الى برديك الالكتروني الرجاء الذهب الى البريد والضغط على اللينك',
                              ).show();
                            } catch (e) {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'Error',
                                      desc:
                                          "الرجاء التاكد من ان البريد الالكتروني الذي ادخلته صحيح ثم قم باعادة المحاولة")
                                  .show();
                            }
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            alignment: Alignment.topRight,
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  MainButtonWidget(
                      buttonFunction: () async {
                        if (formState.currentState!.validate()) {
                          try {
                            setState(
                              () {},
                            );
                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email.text, password: password.text);
                            isLoading = false;
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => HomeScreen()));
                            final sharedPref =
                                await SharedPreferences.getInstance();
                            await sharedPref.setString(
                                'userID', credential.user!.uid);
                            Constants.userID = sharedPref.getString('userID');

                            //
                            await sharedPref.setString(
                                'userEmail', credential.user!.email!);
                            Constants.userEmail =
                                sharedPref.getString('userEmail');
                            print(
                                "======================= ${Constants.userEmail}");
                            setState(
                              () {},
                            );
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('No user found for that email.');
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'No user found for that email.',
                              ).show();
                            } else if (e.code == 'wrong-password') {
                              print('Wrong password provided for that user.');
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc:
                                    'Wrong password, check it again or click on "Forget password?" to reset it',
                              ).show();
                            }
                          }
                        } else {
                          print("Not Valid");
                        }
                      },
                      buttonText: "Login"),
                  // CustomButtonAuth(
                  //     title: "login",
                  //     onPressed: () async {
                  //       if (formState.currentState!.validate()) {
                  //         try {
                  //           setState(() {});
                  //           final credential = await FirebaseAuth.instance
                  //               .signInWithEmailAndPassword(
                  //               email: email.text, password: password.text);
                  //           isLoading = false;
                  //           setState(() {});
                  //           if (credential.user!.emailVerified) {
                  //             isLoading = true;
                  //             Navigator.of(context)
                  //                 .pushReplacementNamed("homepage");
                  //             final sharedPref =
                  //             await SharedPreferences.getInstance();
                  //             await sharedPref.setString(
                  //                 'userID', credential.user!.uid);
                  //             Constants.userID = sharedPref.getString('userID');
                  //
                  //             //
                  //             await sharedPref.setString(
                  //                 'userEmail', credential.user!.email!);
                  //             Constants.userEmail =
                  //                 sharedPref.getString('userEmail');
                  //             print(
                  //                 "======================= ${Constants.userEmail}");
                  //           } else {
                  //             FirebaseAuth.instance.currentUser!
                  //                 .sendEmailVerification();
                  //             isLoading = false;
                  //             AwesomeDialog(
                  //               context: context,
                  //               dialogType: DialogType.error,
                  //               animType: AnimType.rightSlide,
                  //               title: 'Error',
                  //               desc:
                  //               'الرجاء التوجه على بريدك الالكتروني والضفط على لينك التحقق من البريد حتى يتم تفعيل حسابك',
                  //             ).show();
                  //           }
                  //         } on FirebaseAuthException catch (e) {
                  //           if (e.code == 'user-not-found') {
                  //             print('No user found for that email.');
                  //             AwesomeDialog(
                  //               context: context,
                  //               dialogType: DialogType.error,
                  //               animType: AnimType.rightSlide,
                  //               title: 'Error',
                  //               desc: 'No user found for that email.',
                  //             ).show();
                  //           } else if (e.code == 'wrong-password') {
                  //             print('Wrong password provided for that user.');
                  //             AwesomeDialog(
                  //               context: context,
                  //               dialogType: DialogType.error,
                  //               animType: AnimType.rightSlide,
                  //               title: 'Error',
                  //               desc:
                  //               'Wrong password, check it again or click on "Forget password?" to reset it',
                  //             ).show();
                  //           }
                  //         }
                  //       } else {
                  //         print("Not Valid");
                  //       }
                  //     },
                  // ),

                  // Text("Don't Have An Account ? Resister" , textAlign: TextAlign.center,)
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushReplacementNamed(AppRoute.signUp);
                    },
                    child: Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Don't Have An Account ? ",
                          ),
                          TextSpan(
                            text: "Register",
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor: ColorManager.mainColor,
                                color: ColorManager.mainColor,
                                fontWeight: FontWeight.w900,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
