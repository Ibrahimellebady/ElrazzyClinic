import 'package:elrazy_clinics/controller/cubit/appontments_cubit/appointment_cubit.dart';
import 'package:elrazy_clinics/core/constants/constants.dart';
import 'package:elrazy_clinics/core/theme/style/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/colors.dart';
import '../../../core/components/home_drawer_widget.dart';
import 'home_widgets/home_top_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const HomeDrawerWidget(),
      body: SafeArea(
        child: Container(
          color: ColorManager.mainColor,
          child: Column(
            children: [
              HomeTopBarWidget(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TableCalendar(
                          firstDay: DateTime.now(),
                          lastDay: DateTime.now().add(
                            Duration(days: 30),
                          ),
                          focusedDay: _focusedDay,
                          selectedDayPredicate: (day) => _selectedDay == day,
                          onDaySelected: (selectedDay, focusedDay) {
                            if (selectedDay.weekday == DateTime.friday) {
                              // Optionally show a message to the user or handle it as needed
                              return; // Do not proceed if it's Friday
                            }
                            setState(() {
                              _selectedDay = selectedDay;
                              _focusedDay =
                                  focusedDay; // Update focusedDay to the selected day
                            });
                          },
                          calendarStyle: CalendarStyle(
                            todayDecoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.2),
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            selectedDecoration: BoxDecoration(
                                color: ColorManager.mainColor,
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                )),
                          ),
                          weekendDays: [DateTime.friday],
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Container(
                          child: Column(
                            children: [
                              AppointmentHourWidget(
                                appointmentTime: DateTime(
                                    _focusedDay.year,
                                    _focusedDay.month,
                                    _focusedDay.day,
                                    15), // Example time at 12 PM

                                selectedDay: _focusedDay,
                              ),
                              AppointmentHourWidget(
                                appointmentTime: DateTime(
                                    _focusedDay.year,
                                    _focusedDay.month,
                                    _focusedDay.day,
                                    11), // Example time at 12 PM

                                selectedDay: _focusedDay,
                              ),
                              AppointmentHourWidget(
                                appointmentTime: DateTime(
                                    _focusedDay.year,
                                    _focusedDay.month,
                                    _focusedDay.day,
                                    14), // Example time at 12 PM

                                selectedDay: _focusedDay,
                              ),
                            ],
                          ),
                        ),
                        // NextAppointmentWidget(),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AppointmentHourWidget extends StatelessWidget {
  AppointmentHourWidget({
    super.key,
    required this.appointmentTime,
    required this.selectedDay,
  });

  final DateTime appointmentTime;

  final DateTime selectedDay;

  @override
  Widget build(BuildContext context) {
    // Format the hour and determine AM/PM
    String hour = appointmentTime.hour > 12
        ? (appointmentTime.hour - 12).toString()
        : appointmentTime.hour.toString();
    String dayTime = appointmentTime.hour >= 12 ? 'PM' : 'AM';

    //

    return BlocConsumer<AppointmentCubit, AppointmentState>(
      listener: (context, state) {},
      builder: (context, state) {
        bool availability = false;

        return Container(
          child: Column(
            children: [
              Row(
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
                    ],
                  ),
                  availability
                      ? InkWell(
                          onTap: () {
                            BlocProvider.of<AppointmentCubit>(context)
                              ..sendAppointmentToFireStore(
                                  appointmentID:
                                      appointmentTime.toIso8601String(),
                                  appointmentTime: appointmentTime,
                                  clientID: '${Constants.userID}');
                          },
                          child: Row(
                            children: [
                              Text(
                                'Book Now ',
                                style: AppTextStyle.mainColorBoldTextStyle16,
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 20,
                                color: ColorManager.mainColor,
                              )
                            ],
                          ),
                        )
                      : Text(
                          'Not Available ',
                          style: AppTextStyle.redColorBoldTextStyle16,
                        ),
                ],
              ),
              Divider(
                color: ColorManager.secondaryColor,
              ),
            ],
          ),
        );
      },
    );
  }
}
