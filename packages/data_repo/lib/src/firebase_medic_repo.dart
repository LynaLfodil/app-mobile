import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
// Update the import path below to the correct relative location if the file exists, for example:
import '../medication_repo.dart';
// Or, if the file does not exist, create medication_repo.dart in the appropriate directory.

// Ensure MedicationRepo is defined as an abstract class or mixin in medication_repo.dart
// Example:
// abstract class MedicationRepo {
//   Future<List<Medication>> getPizzas();
// }

class FirebaseMedicationRepo implements MedicationRepo {
  final medicationCollection = FirebaseFirestore.instance.collection('users');

  @override
  Future<List<Medication>> getusers() async {
    try {
      return await medicationCollection
        .get()
        .then((value) => value.docs.map((e) => 
          Medication.fromEntity(MedicationEntity.fromDocument(e.data()))
        ).toList());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
  
 
}