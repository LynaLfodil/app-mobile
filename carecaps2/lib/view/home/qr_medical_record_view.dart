import 'package:flutter/material.dart';

class QRMedicalRecordView extends StatelessWidget {
  const QRMedicalRecordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('qr medirecord'),
      ),
      body: const Center(
        child: Text('qr Page'),
      ),
    );
  }
}