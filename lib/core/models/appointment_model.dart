class AppointmentModel {
  String? appointmentID;
  DateTime? appointmentTime; // Make sure this is DateTime
  int? booked;
  List<String>? clientIDs;

  AppointmentModel({
    this.appointmentID,
    this.appointmentTime,
    this.booked,
    this.clientIDs,
  });

  // From JSON
  factory AppointmentModel.fromJson(Map<String, dynamic> data) {
    return AppointmentModel(
      appointmentID: data['appointmentID'],
      appointmentTime: data['appointmentTime'] != null
          ? DateTime.parse(data['appointmentTime'])
          : null,
      booked: data['booked'] ?? 0, // Default to 0 if null
      clientIDs: List<String>.from(data['clientIDs'] ?? []),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'appointmentID': appointmentID,
      'appointmentTime':
          appointmentTime?.toIso8601String(), // Serialize DateTime
      'booked': booked ?? 0,
      'clientIDs': clientIDs ?? [],
    };
  }
}
