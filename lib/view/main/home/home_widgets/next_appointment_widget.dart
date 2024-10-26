import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../controller/cubit/appontments_cubit/appointment_cubit.dart';

class NextAppointmentWidget extends StatelessWidget {
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
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Appointment',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(height: 8),
                      Text('ID: ${nextAppointment.appointmentID}'),
                      Text('Time: ${nextAppointment.appointmentTime}'),
                      Text(
                          'Booked by: ${nextAppointment.clientIDs?.join(', ')}'),
                      Text('Total Booked: ${nextAppointment.booked}'),
                    ],
                  ),
                ),
              ),
            );
          } else if (state is NoNextAppointmentFoundState) {
            return Center(child: Text("No upcoming appointments found."));
          } else {
            return Center(child: Text("Error occurred."));
          }
        },
      ),
    );
  }
}

// BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                         color: ColorManager.secondaryColor.withOpacity(0.1),
//                         spreadRadius: 2,
//                         blurRadius: 3,
//                         offset: Offset(0, 3), // changes position of shadow
//                       ),
//                     ],
//                     gradient: LinearGradient(
//                       colors: [
//                         ColorManager.mainColor,
//                         ColorManager.secondaryColor,
//                       ],
//                       begin: const FractionalOffset(0.8, 0.9),
//                       end: Alignment.bottomRight,
//                     ),
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(16),
//                     ),
//                   ),
