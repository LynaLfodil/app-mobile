
import '../entities/entities.dart';
import '../entities/medication_enti.dart';

class Medication {
  String mid;
  String name;
  bool taken;
  String time;
  String from;
  String to;


  Medication({
    required this.mid,
    required this.name,
    required this.taken,
    required this.time,
    required this.from,
    required this.to,
  });

  MedicationEntity toEntity() {
    return MedicationEntity(
      mId: mid,
      name: name,
      taken: taken,
      time: time,
      from: from,
      to: to,
    );
  }

  static Medication fromEntity(MedicationEntity entity) {
    return Medication(
      mid: entity.mId,
      name: entity.name,
      taken: entity.taken,
      time: entity.time,
      from: entity.from,
      to: entity.to,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'mid': mid,
      'name': name,
      'taken': taken,
      'time': time,
      'from': from,
      'to': to,
    };
  }
}