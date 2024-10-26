import 'package:elrazy_clinics/core/theme/style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../controller/cubit/appontments_cubit/appointment_cubit.dart';
import '../../../../core/theme/colors.dart';
import '../appointment_screen.dart';
import 'countdown_widget.dart';

class NextAppointmentWidget extends StatefulWidget {
  @override
  State<NextAppointmentWidget> createState() => _NextAppointmentWidgetState();
}

class _NextAppointmentWidgetState extends State<NextAppointmentWidget> {
  @override
  void initState() {
    super.initState();

    context.read<AppointmentCubit>().startAutoRefresh();
    context.read<AppointmentCubit>().getNextAppointmentForUser();
  }

  // @override
  // void dispose() {
  //   // Stop the auto-refresh when the widget is disposed
  //   context.read<AppointmentCubit>().stopAutoRefresh();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppointmentCubit()..getNextAppointmentForUser(),
      child: BlocConsumer<AppointmentCubit, AppointmentState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is AppointmentInitial) {
            return Center(child: CircularProgressIndicator());
          } else if (state is SuccessGetNextAppointmentState) {
            final nextAppointment = state.nextAppointment;

            // Parse the appointment time
            DateTime appointmentTime =
                DateTime.parse(nextAppointment.appointmentTime.toString());

            // Get the current time
            DateTime now = DateTime.now();

            // Calculate the difference between now and the appointment time
            Duration timeUntilAppointment = appointmentTime.difference(now);

            // Calculate progress based on time left
            double progress = 0.0;

            if (timeUntilAppointment.isNegative) {
              // If the appointment time is already past, we can set the progress to 1 (100%)
              progress = 1.0;
            } else {
              // For long durations (over 7 days)
              if (timeUntilAppointment.inDays > 7) {
                progress = 0.0; // 0% progress if it's more than 7 days away
              }
              // For mid durations (between 1 and 7 days)
              else if (timeUntilAppointment.inDays > 0) {
                // Calculate progress as a ratio of days left to 7
                progress = 1 - (timeUntilAppointment.inDays / 7);
              }
              // For short durations (less than 1 day)
              else {
                // Use hours and minutes to make progress more dynamic
                int totalMinutes = timeUntilAppointment.inMinutes;
                int totalSeconds = timeUntilAppointment.inSeconds;

                // If less than a day, scale progress dynamically (near 1 for near appointment)
                progress = 0.8 + (totalMinutes / 60) * 0.2;

                // If less than 1 minute, make progress even more dynamic (approaching 1)
                if (totalMinutes <= 0) {
                  progress = 0.9 + (totalSeconds / 60) * 0.1;
                }
              }
            }

            return InkWell(
              onTap: () {
                // DateTime appointmentTime =
                //     DateTime.parse(nextAppointment.appointmentTime as String);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppointmentScreen(
                      initialFocusedDay: appointmentTime,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 4, // Adjust elevation here
                  borderRadius: BorderRadius.circular(12),
                  color: ColorManager.mainColor, // Background color
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorManager.mainColor,
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.mainColor.withOpacity(0.15),
                          spreadRadius: 4,
                          blurRadius: 6,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width - 170,
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Next Appointment',
                                style: AppTextStyle.whiteSemiBoldTextStyle18,
                                maxLines: 1,
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 220,
                                    child: RichText(
                                      text: TextSpan(
                                        style: AppTextStyle
                                            .whiteTextStyle, // Default text style for the whole string
                                        children: [
                                          TextSpan(
                                            text:
                                                'Your upcoming session is scheduled for ',
                                          ),
                                          TextSpan(
                                            text:
                                                '${DateFormat('d MMM').format(appointmentTime)}',
                                            style: AppTextStyle
                                                .whiteBoldTextStyle16,
                                          ),
                                          TextSpan(
                                            text: ' at ',
                                          ),
                                          TextSpan(
                                            text:
                                                '${DateFormat('h a').format(appointmentTime)}',
                                            style: AppTextStyle
                                                .whiteBoldTextStyle16, // Apply a different style to the time
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CountdownWidget(
                                    appointmentTime:
                                        '${nextAppointment.appointmentTime}',
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 3.0),
                                    child: Icon(
                                      Icons.hourglass_bottom_rounded,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              ),
                              // Linear Progress Indicator showing the progress
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(width: 1, color: Colors.white),
                                ),
                                child: LinearProgressIndicator(
                                  minHeight: 15,
                                  borderRadius: BorderRadius.circular(8),
                                  value:
                                      progress, // Set the calculated progress
                                  color: ColorManager.mainColor,
                                  backgroundColor: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 150,
                          child: Image.asset(
                            'assets/images/dr elrazzy.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else if (state is NoNextAppointmentFoundState) {
            return NoNextAppointmentWidget();
          } else {
            return Center(child: Text("Error occurred."));
          }
        },
      ),
    );
  }
}

class NoNextAppointmentWidget extends StatelessWidget {
  const NoNextAppointmentWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 4, // Adjust elevation here
        borderRadius: BorderRadius.circular(12),
        color: ColorManager.mainColor, // Background color
        child: Container(
          decoration: BoxDecoration(
            color: ColorManager.mainColor,
            boxShadow: [
              BoxShadow(
                color: ColorManager.mainColor.withOpacity(0.15),
                spreadRadius: 4,
                blurRadius: 6,
                offset: Offset(0, 4), // changes position of shadow
              ),
            ],
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width - 170,
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Appointment',
                      style: AppTextStyle.whiteSemiBoldTextStyle18,
                      maxLines: 1,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Currently, there are no upcoming appointments in your schedule..",
                      style: AppTextStyle.whiteTextStyle,
                    ),
                    SizedBox(height: 12),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentScreen(),
                          ),
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Book Now!',
                          style: AppTextStyle.mainColorGaretTextStyle18,
                        ),
                      ),
                    )
                    // Linear Progress Indicator showing the progress
                  ],
                ),
              ),
              Container(
                width: 120,
                height: 150,
                child: Image.asset(
                  'assets/images/dr elrazzy.png',
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
