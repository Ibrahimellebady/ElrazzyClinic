import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/cubit/auth_cubit/user_cubit.dart';
import '../../../../core/theme/colors.dart';

class HomeTopBarWidget extends StatelessWidget {
  const HomeTopBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final userCubit = BlocProvider.of<UserCubit>(context)..getUsersData();
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final user = userCubit.userModel;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Scaffold.of(context).openDrawer(); // Open drawer on tap
                },
                child: Icon(
                  Icons.menu_sharp,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, ${user?.firstName} ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Are you ready to learn?",
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                          color: ColorManager.LighterWhite,
                        ),
                      ),
                    ],
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
