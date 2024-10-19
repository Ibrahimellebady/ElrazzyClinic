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
