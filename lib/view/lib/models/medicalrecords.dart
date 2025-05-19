import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


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
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      debugPrint("⚠️ Null data in document ${doc.id}");
      return MedicalRecord(
        mrid: doc.id,
        title: 'Untitled',
        category: 'Unknown',
        icon: Icons.insert_drive_file,
        date: DateTime.now(),
        location: 'Unknown',
        fileUrl: '',
      );
    }

    final title = data['title']?.toString() ?? 'Untitled';
    final category = data['category']?.toString() ?? 'Unknown';
    final iconName = data['icon']?.toString() ?? 'insert_drive_file';
    final timestamp = data['date'];
    final date = timestamp is Timestamp ? timestamp.toDate() : DateTime.now();
    final location = data['location']?.toString() ?? 'Unknown';
    final fileUrl = data['fileUrl']?.toString() ?? '';

    return MedicalRecord(
      mrid: doc.id,
      title: title,
      category: category,
      icon: _iconFromString(iconName),
      date: date,
      location: location,
      fileUrl: fileUrl,
    );
  }

  Map<String, dynamic> toMap() => {
        'title': title,
        'category': category,
        'icon': iconNameFromIcon(icon),
        'date': Timestamp.fromDate(date),
        'location': location,
        'fileUrl': fileUrl,
      };

  static IconData _iconFromString(String name) {
    switch (name) {
      case 'monitor_heart':
        return Icons.monitor_heart;
      case 'description':
        return Icons.description;
      case 'medical_services':
        return Icons.medical_services;
      default:
        return Icons.insert_drive_file;
    }
  }

  static String iconNameFromIcon(IconData icon) {
    if (icon == Icons.monitor_heart) return 'monitor_heart';
    if (icon == Icons.description) return 'description';
    if (icon == Icons.medical_services) return 'medical_services';
    return 'insert_drive_file';
  }
}
