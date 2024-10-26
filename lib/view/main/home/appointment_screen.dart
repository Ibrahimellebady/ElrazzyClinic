import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../controller/cubit/appontments_cubit/appointment_cubit.dart';
import '../../../core/constants/variables.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/style/text_styles.dart';
import 'home_widgets/appointment_hour_widget.dart';

class AppointmentScreen extends StatefulWidget {
  final DateTime? initialFocusedDay;

  // Constructor that accepts initial focused day
  AppointmentScreen({this.initialFocusedDay});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay =
        widget.initialFocusedDay ?? DateTime.now(); // Default to current day
    _fetchAppointmentData(_focusedDay);
  }

  void _fetchAppointmentData(DateTime day) {
    final appointmentCubit = BlocProvider.of<AppointmentCubit>(context);
    appointmentCubit.getAppointmentData(day.toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: ColorManager.mainColor,
          child: Column(
            children: [
              Expanded(
                child: Container(
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
                        ClipPath(
                          clipper: CustomClipPath(),
                          child: Container(
                            height: 300,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: ColorManager.mainColor,
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  right: 0,
                                  bottom: 50,
                                  child: Container(
                                    width: 180,
                                    height: 230,
                                    child: Image.asset(
                                      'assets/images/dr elrazzy.png',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 120,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Next Appointment',
                                        style: AppTextStyle
                                            .whiteSemiBoldTextStyle18,
                                        maxLines: 1,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Easily schedule your appointment and experience exceptional care throughout your rehabilitation journey..",
                                        style: AppTextStyle.whiteTextStyle,
                                      ),
                                      SizedBox(height: 24),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 24, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(16),
                                            ),
                                          ),
                                          child: Text(
                                            'View your schedule',
                                            style: AppTextStyle
                                                .mainColorBoldTextStyle16,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 50),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TableCalendar(
                            firstDay: DateTime.now(),
                            lastDay: DateTime.now()
                                .add(Duration(days: Variables.allowedDays)),
                            focusedDay: _focusedDay,
                            selectedDayPredicate: (day) => _selectedDay == day,
                            onDaySelected: (selectedDay, focusedDay) {
                              if (selectedDay.weekday == DateTime.friday) {
                                return; // Do not proceed if it's Friday
                              }
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay; // Update focusedDay
                              });
                              _fetchAppointmentData(
                                  selectedDay); // Fetch new data
                            },
                            calendarStyle: CalendarStyle(
                              todayDecoration: BoxDecoration(
                                color: ColorManager.secondaryColor
                                    .withOpacity(0.6),
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              selectedDecoration: BoxDecoration(
                                color: ColorManager.mainColor,
                                shape: BoxShape.rectangle,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                            ),
                            weekendDays: [DateTime.friday],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children:
                                List.generate(Variables.workingHours, (index) {
                              DateTime appointmentTime = DateTime(
                                _focusedDay.year,
                                _focusedDay.month,
                                _focusedDay.day,
                                Variables.startingHour +
                                    index, // Start from 11 AM
                              );
                              return AppointmentHourWidget(
                                appointmentTime: appointmentTime,
                                selectedDay: _focusedDay,
                              );
                            }),
                          ),
                        ),
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

class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0, size.height);
    path.quadraticBezierTo(0, size.height - 50, 50, size.height - 50);
    path.lineTo(size.width - 50, size.height - 50);
    path.quadraticBezierTo(
        size.width, size.height - 50, size.width, size.height - 100);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
