// lib/models/medication.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Medication {
  final String mid;
  final String name;
  final bool taken;
  final String time;
  final DateTime from;
  final DateTime to;

  Medication({
    required this.mid,
    required this.name,
    required this.taken,
    required this.time,
    required this.from,
    required this.to,
  });

  /// Construct from a Firestore document
  factory Medication.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Medication(
      mid:   doc.id,
      name:  data['name']  as String,
      taken: data['taken'] as bool,
      time:  data['time']  as String,
      from:  (data['from'] as Timestamp).toDate(),
      to:    (data['to']   as Timestamp).toDate(),
    );
  }

  /// Convert to a map for writing back to Firestore
  Map<String, dynamic> toMap() => {
        'name':  name,
        'taken': taken,
        'time':  time,
        'from':  Timestamp.fromDate(from),
        'to':    Timestamp.fromDate(to),
      };

  static Stream<List<Medication>> empty() {
    return Stream.value([]);
  }
}
