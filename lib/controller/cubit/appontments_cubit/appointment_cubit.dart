import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elrazy_clinics/core/models/appointment_model.dart';
import 'package:meta/meta.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit() : super(AppointmentInitial());

  Future<void> sendAppointmentToFireStore({
    required String appointmentID,
    required DateTime appointmentTime,
    required String clientID, // Pass the current user's ID
  }) async {
    try {
      DocumentReference appointmentDoc = FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentID);

      // Get the document snapshot with casting
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await appointmentDoc.get() as DocumentSnapshot<Map<String, dynamic>>;

      if (docSnapshot.exists) {
        // Update existing appointment
        final existingData = docSnapshot.data();
        if (existingData != null) {
          int booked = existingData['booked'] ?? 0;
          List<String> clientIDs =
              List<String>.from(existingData['clientIDs'] ?? []);

          // Increment booked count and add new clientID
          booked += 1;
          if (!clientIDs.contains(clientID)) {
            clientIDs.add(clientID);
          }

          // Update the appointment in Firestore
          await appointmentDoc.update({
            'booked': booked,
            'clientIDs': clientIDs,
          });

          print("Appointment updated successfully.");
          emit(SaveAppointmentDataOnFirestoreSuccessState());
        }
      } else {
        // Create new appointment
        AppointmentModel appointmentModel = AppointmentModel(
          appointmentID: appointmentID,
          appointmentTime: appointmentTime,
          booked: 1, // Set booked to 1 since this is the first booking
          clientIDs: [clientID], // Start with the current user's ID
        );

        await appointmentDoc.set(appointmentModel.toJson());
        print("New appointment created successfully.");
        emit(SaveAppointmentDataOnFirestoreSuccessState());
      }
    } on FirebaseException catch (e) {
      print("Failed to save appointment data to Firestore: $e");
      emit(FailedToSaveAppointmentDataOnFirestoreState());
    }
  }

  AppointmentModel? appointmentModel;
  void getAppointmentData(String appointmentID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection('appointments')
              .doc(appointmentID)
              .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        print("Data fetched: $data"); // Debug print

        if (data != null) {
          appointmentModel = AppointmentModel.fromJson(data);
          print(
              "Appointment Model: ${appointmentModel?.toJson()}"); // Debug print
          emit(SuccessGetAppointmentDataState(appointmentModel));
        } else {
          print("No data found for appointment ID: $appointmentID");
          emit(FailedToGetAppointmentDataState());
        }
      } else {
        print("Appointment document does not exist for ID: $appointmentID");
        emit(FailedToGetAppointmentDataState());
      }
    } on FirebaseException catch (e) {
      print("Error fetching appointment data from Firestore: $e");
    }
  }
}
