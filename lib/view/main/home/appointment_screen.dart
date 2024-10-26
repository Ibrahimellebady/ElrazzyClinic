import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../controller/cubit/appontments_cubit/appointment_cubit.dart';
import '../../../core/constants/variables.dart';
import '../../../core/theme/colors.dart';
import 'home_widgets/appointment_hour_widget.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    // Initial fetch of appointment data
    _fetchAppointmentData(_focusedDay);
  }

  void _fetchAppointmentData(DateTime day) {
    final appointmentCubit = BlocProvider.of<AppointmentCubit>(context);
    appointmentCubit.getAppointmentData(day.toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: ColorManager.mainColor,
          child: Column(
            children: [
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
                              color: Colors.black.withOpacity(0.2),
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
                        SizedBox(height: 16),
                        Container(
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
