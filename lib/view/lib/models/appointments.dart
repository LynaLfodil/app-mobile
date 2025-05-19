// lib/models/medication.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String appid;
  final String timeString;
  final DateTime date;
  final String location;
  final String doctor;
  final String specialty;


  Appointment({
    required this.appid,
    required this.timeString,
    required this.date,
    required this.location,
    required this.doctor,
    required this.specialty,
  });

  /// Construct from a Firestore document
  factory Appointment.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment(
      appid:     doc.id,
      timeString: data['timeString'] as String? ?? '',
      date:      (data['date'] as Timestamp).toDate(),
      location:  data['location'] as String,
      doctor:    data['doctor'] as String,
      specialty: data['specialty'] as String,
    );
  }

  /// Convert to a map for writing back to Firestore
  Map<String, dynamic> toMap() => {
       'appid': appid,
        'timeString':   timeString,
        'date':   Timestamp.fromDate(date),
        'location': location,
        'doctor': doctor,
        'specialty': specialty,
      };

  static Stream<List<Appointment>> empty() {
    return Stream.value([]);
  }
}
