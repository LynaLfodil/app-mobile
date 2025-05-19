// lib/services/firestore_service.dart
import 'package:carecaps2/view/lib/models/medication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// Helper to convert stored icon-name strings back into IconData.


/// --- Appointment Model ---
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

  factory Appointment.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Appointment(
      appid:     doc.id,
      timeString:      data['timeString'] as String ,
      date:      (data['date'] as Timestamp).toDate(),
      location:  data['location'] as String,
      doctor:    data['doctor'] as String,
      specialty: data['specialty'] as String,
    );
  }


  Map<String, dynamic> toMap() => {
        'appid': appid,
        'timeString':   timeString,
        'date':   Timestamp.fromDate(date),
        'location': location,
        'doctor': doctor,
        'specialty': specialty,
      };
}

/// --- Medical Record Model ---
class MedicalRecord {
  final String mrid;
  final String title;
  final String category;
  final IconData icon;
  final DateTime date;
  final String location;
  final String fileUrl;

  MedicalRecord({
    required this.mrid,
    required this.title,
    required this.category,
    required this.icon,
    required this.date,
    required this.location,
    required this.fileUrl,
  });

factory MedicalRecord.fromDoc(DocumentSnapshot doc) {
  // 1) Grab the raw data and log it
  final raw = doc.data();
  debugPrint('🔍 [MedicalRecord] doc ${doc.id} raw data: $raw');

  // 2) Ensure we have a Map<String, dynamic>
  final data = raw as Map<String, dynamic>? ?? {};

  // 3) Log any missing/null fields
  for (final key in ['title', 'category', 'icon', 'date', 'location', 'fileUrl']) {
    if (!data.containsKey(key) || data[key] == null) {
      debugPrint('⚠️ [MedicalRecord] doc ${doc.id} missing or null "$key"');
    }
  }

  // 4) Safely pull each field (with a fallback)
  final title    = data['title']   ?.toString() ?? 'Untitled';
  final category = data['category']?.toString() ?? 'Unknown';
  final iconName = data['icon']    ?.toString() ?? 'insert_drive_file';

  final timestamp = data['date'];
  final date      = (timestamp is Timestamp)
      ? timestamp.toDate()
      : DateTime.now();

  final location  = data['location']?.toString() ?? 'Unknown';
  final fileUrl   = data['fileUrl'] ?.toString() ?? '';

  // 5) Build and return the model
  return MedicalRecord(
    mrid:     doc.id,
    title:    title,
    category: category,
    icon:     _iconFromString(iconName),
    date:     date,
    location: location,
    fileUrl:  fileUrl,
  );
}

  Map<String, dynamic> toMap() => {
        'title':    title,
        'category': category,
        'icon':     icon,
        'date':     Timestamp.fromDate(date),
        'location': location,
        'fileUrl':  fileUrl,
      };
}
/// Helper to convert stored icon-name strings back into IconData.
IconData _iconFromString(String name) {
  switch (name) {
    case 'monitor_heart':    return Icons.monitor_heart;
    case 'description':      return Icons.description;
    case 'medical_services': return Icons.medical_services;
    default:                 return Icons.help_outline;
  }
}

/// Helper to convert IconData back into a string for storage.
 String stringFromIcon(IconData icon) {
  if (icon == Icons.monitor_heart)    return 'monitor_heart';
  if (icon == Icons.description)      return 'description';
  if (icon == Icons.medical_services) return 'medical_services';
  return 'help_outline';
}

/// --- Firestore Service ---
class FirestoreService {
  final _db = FirebaseFirestore.instance;
  String get _uid => FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Appointment>> streamAppointments() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('appointments')
        .orderBy('date')
        .snapshots()
        .map((snap) => snap.docs.map(Appointment.fromDoc).toList());
  }

  /// ✅ Fixed Medication Streaming
  Stream<List<Medication>> streamMedications() {
    // Debug print here

    return _db
        .collection('users')
        .doc(_uid)
        .collection('medications')
        .orderBy('from')
        .snapshots()
        .map((snap) => snap.docs.map(Medication.fromDoc).toList());
  }

  Stream<List<MedicalRecord>> streamRecords() {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('records')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(MedicalRecord.fromDoc).toList());
  }

  Future<void> addAppointment(Appointment a) {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('appointments')
        .add(a.toMap());
  }

  Future<void> addMedication(Medication m) {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('medications')
        .add(m.toMap());
  }

  Future<void> updateMedicationTaken(String mId, bool taken) {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('medications')
        .doc(mId)
        .update({'taken': taken});
  }

  Future<void> addRecord(MedicalRecord r) {
    return _db
        .collection('users')
        .doc(_uid)
        .collection('records')
        .add(r.toMap());
  }
  // In your FirestoreService class:
Future<List<Medication>> getCurrentMedications() async {
  final now = DateTime.now();
  final snapshot = await FirebaseFirestore.instance
    .collection('medications')
    .where('to', isGreaterThan: now) // filter current meds only
    .get();

  return snapshot.docs.map((doc) => Medication.fromDoc(doc)).toList();
}
Future<List<Appointment>> getAllAppointments() async {
    final snapshot = await FirebaseFirestore.instance.collection('appointments').get();
    return snapshot.docs
        .map((doc) => Appointment.fromDoc(doc))
        .toList();
  }

}
