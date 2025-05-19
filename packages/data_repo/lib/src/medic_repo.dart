import 'models/models.dart';

abstract class MedicationRepo {
    Future<List<Medication>> getusers();

}