import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../controller/cubit/auth_cubit/user_cubit.dart';
import '../../../core/components/main_button_widget.dart';
import '../../../core/components/text_formfield.dart';
import '../../../core/theme/colors.dart';
import '../../../routes.dart';
import '../../main/home/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserCubit, UserState>(
        listener: (context, state) {
          if (state is LoadingState) {
            setState(() {
              isLoading = true;
            });
          } else {
            setState(() {
              isLoading = false;
            });
          }
          if (state is FailedToCreateUserState) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   // SnackBar(
            //   //   backgroundColor: Colors.red,
            //   //   content: Text('state.message'),
            //   // ),
            // );
          }
          if (state is UserCreatedSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
            );
          }
        },
        builder: (context, state) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                Form(
                  key: formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 20),
                      const Text("SignUp",
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                      Container(height: 20),
                      BlocProvider.of<UserCubit>(context).userImgFile != null
                          ? Center(
                              child: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<UserCubit>(context)
                                      .getImage();
                                },
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(
                                          BlocProvider.of<UserCubit>(context)
                                              .userImgFile!),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: GestureDetector(
                                onTap: () {
                                  BlocProvider.of<UserCubit>(context)
                                      .getImage();
                                },
                                child: Container(
                                  width: 75,
                                  height: 75,
                                  child: Icon(
                                    CupertinoIcons.person,
                                    size: 50,
                                  ),
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.black,
                                    ),
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                ),
                              ),
                            ),
                      const Text(
                        "Username",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextForm(
                            hinttext: "First name",
                            mycontroller: firstName,
                            validator: (val) {
                              if (val == "") {
                                return "Can't To be Empty";
                              }
                              return null;
                            },
                            width: MediaQuery.of(context).size.width / 2 - 28,
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          CustomTextForm(
                            width: MediaQuery.of(context).size.width / 2 - 28,
                            hinttext: "Last name",
                            mycontroller: lastName,
                            validator: (val) {
                              if (val == "") {
                                return "Can't To be Empty";
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      Text(
                        "Phone Number",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      CustomPhoneTextForm(
                        mycontroller: phoneNumber,
                      ),
                      const Text(
                        "Email",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      CustomTextForm(
                          width: MediaQuery.of(context).size.width,
                          hinttext: "Enter your email",
                          mycontroller: email,
                          validator: (val) {
                            if (val == "") {
                              return "Email can't To be Empty";
                            }
                            return null;
                          }),
                      const Text(
                        "Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      CustomTextForm(
                        width: MediaQuery.of(context).size.width,
                        hinttext: "Enter your password",
                        mycontroller: password,
                        validator: (val) {
                          if (val == "") {
                            return "Password can't To be Empty";
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                MainButtonWidget(
                  buttonText: "Sign Up",
                  buttonFunction: () async {
                    if (formState.currentState!.validate()) {
                      try {
                        BlocProvider.of<UserCubit>(context).register(
                          firstName: firstName.text,
                          lastName: lastName.text,
                          phoneNumber: phoneNumber.text,
                          email: email.text,
                          password: password.text,
                        );

                        print('==========register is okay');

                        // AwesomeDialog(
                        //   context: context,
                        //   dialogType: DialogType.warning,
                        //   animType: AnimType.rightSlide,
                        //   title: 'Verification',
                        //   desc:
                        //       'Check your email and click on the link to verify your email',
                        // ).show();
                      } catch (e) {
                        print(e);
                      }
                    } else {}
                  },
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoute.login);
                  },
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "Have an account?  ",
                        ),
                        TextSpan(
                          text: "Login",
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
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class CustomPhoneTextForm extends StatelessWidget {
  final TextEditingController mycontroller;

  const CustomPhoneTextForm({
    super.key,
    required this.mycontroller,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: phoneValidator,
      controller: mycontroller,
      keyboardType: TextInputType.phone,
      // Set keyboard type to phone
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly, // Only allow digits
      ],
      decoration: InputDecoration(
        hintText: "Enter your phone number",
        hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
        contentPadding: const EdgeInsets.symmetric(vertical: 2, horizontal: 20),
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide:
              const BorderSide(color: Color.fromARGB(255, 184, 184, 184)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: const BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  String? phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number for easy contact';
    } else if (value.length < 10 || value.length > 15) {
      return 'Please enter valid phone number';
    }
    return null;
  }
}
