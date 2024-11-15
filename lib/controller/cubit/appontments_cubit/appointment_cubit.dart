import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elrazy_clinics/core/constants/constants.dart';
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

  Future<void> updateAppointmentFromFireStore(
      String appointmentID, Map<String, dynamic> updates) async {
    try {
      DocumentReference appointmentDoc = FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentID);
      await appointmentDoc.update(updates);
      print('Document updated successfully');
      emit(FailedToGetAppointmentDataState());
    } on FirebaseException catch (e) {
      print("Failed to update appointment data in Firestore: $e");
      emit(FailedToGetAppointmentDataState());
    }
  }

  Future<void> deleteAppointmentFromFireStore(String appointmentID) async {
    try {
      DocumentReference appointmentDoc = FirebaseFirestore.instance
          .collection('appointments')
          .doc(appointmentID);
      await appointmentDoc.delete();
      print('Document deleted successfully');
      emit(SuccessDeleteAppointmentState());
    } on FirebaseException catch (e) {
      print("Failed to delete appointment data in Firestore: $e");
      emit(FailedToDeleteAppointmentState());
    }
  }

  AppointmentModel? appointmentModel;

  final Map<String, AppointmentModel> _appointmentModels = {};

  void getAppointmentData(String appointmentID) {
    FirebaseFirestore.instance
        .collection('appointments')
        .doc(appointmentID)
        .snapshots()
        .listen((docSnapshot) {
      if (docSnapshot.exists) {
        final data = docSnapshot.data();
        print("Data fetched: $data"); // Debug print

        if (data != null) {
          appointmentModel = AppointmentModel.fromJson(data);
          // Store the appointment model in the map
          _appointmentModels[appointmentID] = appointmentModel!;
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
    });
  }

  int? getBookedCountForTime(DateTime appointmentTime) {
    // Create a string representation of the appointment time
    String appointmentID = appointmentTime.toIso8601String();

    // Check if we have the appointment model for that ID
    AppointmentModel? model = _appointmentModels[appointmentID];

    // Return the booked count if the model exists
    return model?.booked;
  }

  List<String>? getBookedClientsForTime(DateTime appointmentTime) {
    String appointmentID = appointmentTime.toIso8601String();
    AppointmentModel? model = _appointmentModels[appointmentID];
    return model?.clientIDs;
  }

  Future<void> getNextAppointmentForUser() async {
    try {
      // Get the current date and time
      DateTime now = DateTime.now();

      // Query the Firestore for appointments scheduled in the future (no client filter yet)
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance
              .collection('appointments')
              .where('appointmentTime',
                  isGreaterThanOrEqualTo:
                      now.toString()) // Only filter by appointment time
              .orderBy('appointmentTime')
              .get();

      // Filter the result by clientID locally
      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> docSnapshot =
            querySnapshot.docs.first;
        Map<String, dynamic> appointmentData = docSnapshot.data()!;

        // Check if the clientID is part of this appointment's clientIDs array
        if ((appointmentData['clientIDs'] as List).contains(Constants.userID)) {
          AppointmentModel nextAppointment =
              AppointmentModel.fromJson(appointmentData);
          print(
              "Next appointment retrieved successfully: ${nextAppointment.toJson()}");
          emit(SuccessGetNextAppointmentState(nextAppointment));
        } else {
          print(
              "No upcoming appointments found for=========== user: ${Constants.userID}");
          emit(NoNextAppointmentFoundState());
        }
      } else {
        print("No upcoming appointments found for user: ${Constants.userID}");
        emit(NoNextAppointmentFoundState());
      }
    } on FirebaseException catch (e) {
      print("Failed to retrieve next appointment: $e");
      emit(FailedToGetNextAppointmentState());
    } catch (e) {
      print("Unexpected error: $e");
      emit(FailedToGetNextAppointmentState());
    }
  }

  Timer? _timer;

  void startAutoRefresh() {
    // Refresh the appointment every 1 seconds (for example)
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      getNextAppointmentForUser();
    });
  }

  void stopAutoRefresh() {
    _timer?.cancel();
  }

  @override
  Future<void> close() {
    stopAutoRefresh();
    return super.close();
  }
}
