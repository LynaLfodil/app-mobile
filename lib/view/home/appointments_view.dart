import 'package:flutter/material.dart';
import 'package:carecaps2/common/color_extention.dart';// Import the ApplicationState class
 // Import the generated firebase_options.dart file

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({super.key});

  @override
  State<AppointmentsView> createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView> {
  bool remindersEnabled = true;
  bool showUpcoming = true;

  List<Map<String, dynamic>> upcomingAppointments = [
    {
      "doctor": "Dr. Elfodil Mouhamed",
      "specialty": "Internist",
      "date": "Apr 23, 2025",
      "time": "10.00AM",
      "location": "City health clinic",
    },
    {
      "doctor": "Dr. Elfodil Mouhamed",
      "specialty": "Internist",
      "date": "Apr 23, 2025",
      "time": "10.00AM",
      "location": "City health clinic",
    },
  ];

  List<Map<String, dynamic>> pastAppointments = [
    {
      "doctor": "Dr. Sarah Idris",
      "specialty": "Cardiologist",
      "date": "Mar 10, 2025",
      "time": "2.00PM",
      "location": "Downtown Medical Center",
    },
    {
      "doctor": "Dr. Amir Hassen",
      "specialty": "Neurologist",
      "date": "Feb 14, 2025",
      "time": "9.30AM",
      "location": "West Side Clinic",
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
                "Appointments",
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF23414E),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Poppins",
                ),
              ),
              const SizedBox(height: 20),

              // Toggle Tabs
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
                          setState(() => showUpcoming = true);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                showUpcoming
                                    ? Tcolor.primary2
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Upcoming",
                            style: TextStyle(
                              color:
                                  showUpcoming
                                      ? Colors.white
                                      : const Color.fromARGB(221, 15, 55, 70),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() => showUpcoming = false);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                !showUpcoming
                                    ? Tcolor.primary2
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "Past",
                            style: TextStyle(
                              color:
                                  !showUpcoming
                                      ? Colors.white
                                      : const Color.fromARGB(221, 16, 55, 71),
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Poppins',
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

              // Appointment List
              Expanded(
                child: ListView.builder(
                  itemCount:
                      showUpcoming
                          ? upcomingAppointments.length
                          : pastAppointments.length,
                  itemBuilder: (context, index) {
                    final appt =
                        showUpcoming
                            ? upcomingAppointments[index]
                            : pastAppointments[index];
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Icon in rounded box
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Tcolor.primary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 8),

                              // Name + Specialty
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    appt["doctor"],
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF23414E),
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    appt["specialty"],
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 122, 122, 122),
                                      fontSize: 13,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Details
                          Padding(
                            padding: const EdgeInsets.only(left: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_month_outlined,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      appt["date"],
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      appt["time"],
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                         fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      appt["location"],
                                      style: const TextStyle(
                                        fontFamily: 'Poppins',
                                         fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Reminders Toggle
              const Divider(),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 12,
                ),
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color:
                      remindersEnabled ? Tcolor.secondary6 : Tcolor.secondary3,
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
                        color:
                            remindersEnabled
                                ? Tcolor.secondary5
                                : Tcolor.secondary4,
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
                      activeTrackColor: const Color.fromARGB(
                        255,
                        223,
                        245,
                        224,
                      ),
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
