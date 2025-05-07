import 'package:carecaps2/common/color_extention.dart';
import 'package:flutter/material.dart';

class MedicationView extends StatefulWidget {
  const MedicationView({super.key});

  @override
  State<MedicationView> createState() => _MedicationViewState();
}

class _MedicationViewState extends State<MedicationView> {
  bool remindersEnabled = true;
  bool showCurrent = true;

  List<Map<String, dynamic>> currentMedications = [
    {
      "name": "Paracetamol 500mg",
      "from": "Mar 23, 2025",
      "to": "Apr 23, 2025",
      "time": "After breakfast",
      "taken": true,
    },
    {
      "name": "Vitamin C 1000mg",
      "from": "Apr 01, 2025",
      "to": "Apr 30, 2025",
      "time": "Before bed",
      "taken": false,
    },
  ];

  List<Map<String, dynamic>> pastMedications = [
    {
      "name": "Amoxicillin 250mg",
      "from": "Feb 01, 2025",
      "to": "Feb 10, 2025",
      "time": "Before lunch",
      "taken": true,
    },
    {
      "name": "Ibuprofen 200mg",
      "from": "Jan 10, 2025",
      "to": "Jan 17, 2025",
      "time": "After dinner",
      "taken": false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Medication",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF23414E),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 20),

              // Toggle Buttons
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(35, 88, 154, 178),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showCurrent = true;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: showCurrent ? Tcolor.primary2 : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Current",
                            style: TextStyle(
                              color: showCurrent ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            showCurrent = false;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: !showCurrent ? Tcolor.primary2 : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Past",
                            style: TextStyle(
                              color: !showCurrent ? Colors.white : const Color.fromARGB(221, 8, 58, 60),
                              fontWeight: FontWeight.w600,
                              fontFamily: "Poppins",
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Medication List
              Expanded(
                child: ListView.builder(
                  itemCount: showCurrent ? currentMedications.length : pastMedications.length,
                  itemBuilder: (context, index) {
                    var med = showCurrent ? currentMedications[index] : pastMedications[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Tcolor.primary2.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            med['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: "Poppins",
                              color: Color(0xFF23414E),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Text("From: ", style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
                              Text(med['from'], style: const TextStyle(color: Color(0xFF23414E), fontFamily: 'Poppins')),
                              const SizedBox(width: 20),
                              const Text("To: ", style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
                              Text(med['to'], style: const TextStyle(color: Color(0xFF23414E), fontFamily: 'Poppins')),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Tcolor.secondary6,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  med['time'],
                                  style: TextStyle(
                                    color: Tcolor.secondary5,
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Poppins",
                                  ),
                                ),
                              ),
                              Row(
                                children: [
                                  const Text("Status: ", style: TextStyle(color: Colors.grey, fontFamily: 'Poppins')),
                                  const SizedBox(width: 4),
                                  GestureDetector(
                                    onTap: showCurrent
                                        ? () {
                                            setState(() {
                                              currentMedications[index]['taken'] = !med['taken'];
                                            });
                                          }
                                        : null, // Disable in past view
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: med['taken'] ? Tcolor.secondary6 : Tcolor.secondary3,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        med['taken'] ? "taken" : "missed",
                                        style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: med['taken']
                                              ? Tcolor.secondary5
                                              : const Color.fromARGB(255, 113, 66, 63),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Reminders
              const Divider(),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: remindersEnabled ? Tcolor.secondary6 : Tcolor.secondary3,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Reminders",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: remindersEnabled ? Tcolor.secondary5 : Tcolor.secondary4,
                      ),
                    ),
                    Switch(
                      value: remindersEnabled,
                      onChanged: (value) {
                        setState(() {
                          remindersEnabled = value;
                        });
                      },
                      activeColor: const Color.fromARGB(255, 106, 139, 108),
                      activeTrackColor: const Color.fromARGB(255, 223, 245, 224),
                      inactiveThumbColor: Colors.grey,
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
