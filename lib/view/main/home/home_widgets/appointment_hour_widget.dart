import 'package:elrazy_clinics/view/main/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/cubit/appontments_cubit/appointment_cubit.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/constants/variables.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style/text_styles.dart';

class AppointmentHourWidget extends StatelessWidget {
  const AppointmentHourWidget({
    super.key,
    required this.appointmentTime,
    required this.selectedDay,
  });

  final DateTime appointmentTime;
  final DateTime selectedDay;

  @override
  Widget build(BuildContext context) {
    final appointmentCubit = BlocProvider.of<AppointmentCubit>(context);
    // Start listening for changes for this specific appointment time
    appointmentCubit.getAppointmentData(appointmentTime.toIso8601String());

    return BlocConsumer<AppointmentCubit, AppointmentState>(
      listener: (context, state) {},
      builder: (context, state) {
        //
        final bookedCount =
            appointmentCubit.getBookedCountForTime(appointmentTime);
        bool availability =
            bookedCount == null || bookedCount < Variables.clinicPlinths;
        //
        final bookedClients =
            appointmentCubit.getBookedClientsForTime(appointmentTime);
        bool clientBooked = bookedClients?.contains(Constants.userID) ?? false;
        //
        String hour = (appointmentTime.hour % 12).toString();
        String dayTime = appointmentTime.hour >= 12 ? 'PM' : 'AM';

        return Column(
          children: [
            clientBooked
                ? Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '$hour ',
                              style: AppTextStyle.mainColorBoldTextStyle20,
                            ),
                            Text(
                              dayTime,
                              style: AppTextStyle.mainColorBoldTextStyle16,
                            ),
                            // Text('${bookedCount ?? "0"}')
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Text(
                            'Your appointment',
                            style: AppTextStyle.mainColorGaretTextStyle18,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                      "Are you sure you want to Delete this appointment?",
                                      style:
                                          AppTextStyle.mainColorBoldTextStyle16,
                                    ),
                                  ),
                                  actions: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            if (bookedCount == 1) {
                                              appointmentCubit
                                                  .deleteAppointmentFromFireStore(
                                                      appointmentTime
                                                          .toIso8601String());
                                            } else {
                                              appointmentCubit
                                                  .updateAppointmentFromFireStore(
                                                      appointmentTime
                                                          .toIso8601String(),
                                                      {
                                                    "booked": bookedCount! - 1,
                                                    "clientIDs": bookedClients
                                                        ?.where((id) =>
                                                            id !=
                                                            Constants.userID)
                                                        .toList()
                                                  });
                                            }

                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen(),
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(16),
                                              ),
                                            ),
                                            child: Text(
                                              'Delete It',
                                              style: AppTextStyle
                                                  .whiteBoldTextStyle18,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: ColorManager.mainColor,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(16),
                                              ),
                                            ),
                                            child: Text(
                                              'Go Back',
                                              style: AppTextStyle
                                                  .whiteBoldTextStyle18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Icon(
                            Icons.delete,
                            size: 25,
                            color: Colors.red.withOpacity(0.8),
                          ),
                        )
                      ],
                    ),
                  )
                : Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '$hour ',
                              style: AppTextStyle.headingBlackBoldTextStyle18,
                            ),
                            Text(
                              dayTime,
                              style: AppTextStyle.infoBlackTextStyle16,
                            ),
                            // Text('${bookedCount ?? "0"}')
                          ],
                        ),
                        availability
                            ? InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Center(
                                          child: Text(
                                            "Are you sure you want to Book this appointment?",
                                            style: AppTextStyle
                                                .mainColorBoldTextStyle16,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  appointmentCubit
                                                      .sendAppointmentToFireStore(
                                                    appointmentID:
                                                        appointmentTime
                                                            .toIso8601String(),
                                                    appointmentTime:
                                                        appointmentTime,
                                                    clientID:
                                                        '${Constants.userID}',
                                                  );
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeScreen(),
                                                    ),
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        ColorManager.mainColor,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(16),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Book Now!',
                                                    style: AppTextStyle
                                                        .whiteBoldTextStyle18,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 16,
                                                      vertical: 4),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: ColorManager
                                                            .mainColor,
                                                        width: 1),
                                                    color: ColorManager
                                                        .LighterGray,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(16),
                                                    ),
                                                  ),
                                                  child: Text(
                                                    'Go Back',
                                                    style: AppTextStyle
                                                        .mainColorGaretTextStyle18,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Book Now ',
                                      style: AppTextStyle
                                          .thirdColorBoldTextStyle16,
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 20,
                                      color: ColorManager.thirdColor,
                                    ),
                                  ],
                                ),
                              )
                            : Text(
                                'Not Available ',
                                style: AppTextStyle.redColorBoldTextStyle16,
                              ),
                      ],
                    ),
                  ),
            const Divider(color: ColorManager.secondaryColor),
          ],
        );
      },
    );
  }
}
