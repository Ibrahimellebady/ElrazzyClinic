import 'package:elrazy_clinics/controller/cubit/appontments_cubit/appointment_cubit.dart';
import 'package:elrazy_clinics/routes.dart';
import 'package:elrazy_clinics/view/main/home/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/cubit/auth_cubit/user_cubit.dart';
import 'core/constants/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final sharedPref = await SharedPreferences.getInstance();
  Constants.userID = sharedPref.getString('userID');
  Constants.userEmail = sharedPref.getString('userEmail');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print(
            '================================== User is currently signed out!');
      } else {
        print('================================== User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // BlocProvider(
        //   create: (context) => CourseCubit(),
        // ),
        BlocProvider(
          create: (context) => UserCubit(),
        ),
        BlocProvider(
          create: (context) => AppointmentCubit(),
        ),
      ],
      child: MaterialApp(
        // locale: Locale('en'),
        // localizationsDelegates: [
        //   S.delegate,
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        // supportedLocales: S.delegate.supportedLocales,
        debugShowCheckedModeBanner: false,
        home: (FirebaseAuth.instance.currentUser != null &&
                FirebaseAuth.instance.currentUser!.emailVerified == true)
            ? HomeScreen()
            : HomeScreen(),
        routes: routes,
      ),
    );
  }
}
