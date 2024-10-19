import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/theme/colors.dart';
import '../../../../../routes.dart';
import '../../controller/cubit/auth_cubit/user_cubit.dart';
import 'drawer_card_widget.dart';

class HomeDrawerWidget extends StatelessWidget {
  const HomeDrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final userCubit = BlocProvider.of<UserCubit>(context)..getUsersData();
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final user = userCubit.userModel;
        return Drawer(
          // Define your drawer content
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: ColorManager.mainColor,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: ColorManager.moreLighterGray,
                        backgroundImage:
                            user?.image == null || user?.image == ""
                                ? NetworkImage(
                                    "https://firebasestorage.googleapis.com/v0/b/pediatric-pt.appspot.com/o/person.png?alt=media&token=233652f5-d506-44b2-a9b3-c36f1a5f407a",
                                  )
                                : NetworkImage(user!.image!),
                        child:
                            Container(), // You can add a child widget inside the CircleAvatar if needed
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      '${user?.firstName ?? ""} ${user?.lastName ?? ""}',
                      maxLines: 1,
                      style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 18,
                          color: ColorManager.LightWhite,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      '${user?.email ?? ""}',
                      maxLines: 1,
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16,
                        color: ColorManager.LightestWhite,
                        fontStyle: FontStyle.italic,
                      ),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      // DrawerCardWidget(
                      //   mainText: 'Account',
                      //   cardFunction: () {
                      //     Navigator.pushNamed(context, AppRoute.accountScreen);
                      //   },
                      //   cardIcon: CupertinoIcons.person,
                      // ),
                      // DrawerCardWidget(
                      //   mainText: 'About',
                      //   cardFunction: () {
                      //     Navigator.pushNamed(context, AppRoute.aboutScreen);
                      //   },
                      //   cardIcon: Icons.info_outline,
                      // ),
                      // DrawerCardWidget(
                      //   mainText: 'Help',
                      //   cardFunction: () {
                      //     Navigator.pushNamed(context, AppRoute.helpScreen);
                      //   },
                      //   cardIcon: Icons.question_mark_sharp,
                      // ),
                      // DrawerCardWidget(
                      //   mainText: 'Contacts',
                      //   cardFunction: () {
                      //     Navigator.pushNamed(context, AppRoute.contactsScreen);
                      //   },
                      //   cardIcon: Icons.phone,
                      // ),
                      DrawerCardWidget(
                        mainText: 'Discussion',
                        cardFunction: () async {
                          String url = 'https://wa.me/+201067065006';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        cardIcon: Icons.telegram,
                      ),
                      // DrawerCardWidget(
                      //   mainText: 'Questions',
                      //   cardFunction: () {
                      //     Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) =>
                      //                 UserMessagesListScreen()));
                      //   },
                      //   cardIcon: Icons.question_answer,
                      // ),
                      // DrawerCardWidget(
                      //   mainText: 'Ask Athar chat-bot',
                      //   cardFunction: () {
                      //     Navigator.pushNamed(context, AppRoute.accountScreen);
                      //   },
                      //   cardIcon: FontAwesomeIcons.robot,
                      // ),

                      DrawerCardWidget(
                        mainText: 'Technical support',
                        cardFunction: () async {
                          String url = 'https://wa.me/+201067065006';
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        cardIcon: Icons.contact_support_outlined,
                      ),
                    ],
                  ),
                  DrawerCardWidget(
                    mainText: 'Sign out',
                    cardFunction: () async {
                      GoogleSignIn googleSignIn = GoogleSignIn();
                      googleSignIn.disconnect();
                      await FirebaseAuth.instance.signOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          AppRoute.signUp, (route) => false);
                    },
                    cardIcon: Icons.logout,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
