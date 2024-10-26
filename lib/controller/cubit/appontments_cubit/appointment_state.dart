part of 'appointment_cubit.dart';

@immutable
sealed class AppointmentState {}

final class AppointmentInitial extends AppointmentState {}

final class FailedToSaveAppointmentDataOnFirestoreState
    extends AppointmentState {}

final class SaveAppointmentDataOnFirestoreSuccessState
    extends AppointmentState {}

final class FailedToGetAppointmentDataState extends AppointmentState {}

final class SuccessGetAppointmentDataState extends AppointmentState {
  SuccessGetAppointmentDataState(AppointmentModel? appointmentModel);
}

class FailedToGetNextAppointmentState extends AppointmentState {}

class NoNextAppointmentFoundState extends AppointmentState {}

class SuccessGetNextAppointmentState extends AppointmentState {
  final AppointmentModel nextAppointment;

  SuccessGetNextAppointmentState(this.nextAppointment);
}

class SuccessGetUserAppointmentsState extends AppointmentState {
  final List<AppointmentModel> appointments;
  SuccessGetUserAppointmentsState(this.appointments);
}

class NoAppointmentsFoundForUserState extends AppointmentState {}

class FailedToGetUserAppointmentsState extends AppointmentState {}

class SuccessDeleteAppointmentState extends AppointmentState {}

class FailedToDeleteAppointmentState extends AppointmentState {}
