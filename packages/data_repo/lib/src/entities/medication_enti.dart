

class MedicationEntity {
  String mId;
  String name;
  bool taken;
  String time;
  String from;
  String to;

  MedicationEntity({
    required this.mId,
    required this.name,
    required this.taken,
    required this.time,
    required this.from,
    required this.to,
  });

  Map<String, Object?> toDocument() {
    return {
      'mId': mId,
      'name': name,
      'taken': taken,
      'time': time,
      'from': from,
      'to': to,
    };
  }

  static MedicationEntity fromDocument(Map<String, dynamic> doc) {
    return MedicationEntity(
      mId: doc['mId'],
      name: doc['name'],
      taken: doc['taken'],
      time: doc['time'],
      from: doc['from'],
      to: doc['to'],
    );
  }
}