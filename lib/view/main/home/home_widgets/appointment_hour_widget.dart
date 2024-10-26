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
                            appointmentCubit.updateAppointmentFromFireStore(
                                appointmentTime.toIso8601String(), {
                              "booked": bookedCount! - 1,
                              "clientIDs": bookedClients
                                  ?.where((id) => id != Constants.userID)
                                  .toList()
                            });
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
                                  appointmentCubit.sendAppointmentToFireStore(
                                    appointmentID:
                                        appointmentTime.toIso8601String(),
                                    appointmentTime: appointmentTime,
                                    clientID: '${Constants.userID}',
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
