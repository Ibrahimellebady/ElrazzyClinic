import 'package:elrazy_clinics/controller/cubit/appontments_cubit/appointment_cubit.dart';
import 'package:elrazy_clinics/view/main/home/appointment_screen.dart';
import 'package:elrazy_clinics/view/main/home/home_widgets/next_appointment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      drawer: const HomeDrawerWidget(),
      body: SafeArea(
        child: Container(
          color: ColorManager.mainColor,
          child: Column(
            children: [
              HomeTopBarWidget(),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AppointmentScreen(),
                    ),
                  );
                },
                child: Text("navigate"),
              ),
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
                      children: [SizedBox(height: 16), NextAppointmentWidget()],
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
