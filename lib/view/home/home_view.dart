// lib/view/home/home_view.dart

import 'package:flutter/material.dart';
import 'package:carecaps2/common/color_extention.dart';
import 'package:carecaps2/services/firestore_service.dart';   
import 'package:carecaps2/view/lib/models/medication.dart';    // <-- FirestoreService + its Appointment
import 'package:carecaps2/view/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'appointments_view.dart';
import 'medication_view.dart';
import 'messages_view.dart';
import 'mrecords_view.dart';
import 'settings_view.dart';
import 'blog_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeContent(onGoToAppointments: () => setState(() => _currentIndex = 2)),
      const MedicationView(),
      const AppointmentsView(),
      const RecordsView(),
      MessagesView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF23414E),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navIcon(Icons.home, 0),
              _navIcon(Icons.medication, 1),
              _navIcon(Icons.calendar_month, 2),
              _navIcon(Icons.folder, 3),
              _navIcon(Icons.message, 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon, int index) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB9E7F0) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 26,
          color: isSelected ? const Color(0xFF103947) : const Color(0xFFB9E7F0),
        ),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  final VoidCallback onGoToAppointments;
  const HomeContent({super.key, required this.onGoToAppointments});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String _userName = 'User';
  String _bloodType = '';
  String _disease = '';
  String _phone = '';
  double _bmi = 0.0;
  final _dateFmt = DateFormat('MMM d, yyyy – hh:mm a');

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    final dn = user?.displayName;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = (dn != null && dn.isNotEmpty)
          ? dn
          : user?.email?.split('@').first ?? 'User';
      _bloodType = prefs.getString('bloodType') ?? '';
      _disease = prefs.getString('disease') ?? '';
      _phone = prefs.getString('phone') ?? '';
      _bmi = prefs.getDouble('bmi') ?? 0.0;
    });
  }

  void _showQRPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Container(
              width: 280,
              height: 400,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
              ),
              child: Column(
                children: [
                  Image.asset(
                    'lib/assets/img/qr-code.png',
                    width: 220,
                    height: 220,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Health summary',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Poppins",
                        color: Color(0xFF23414E)),
                  ),
                  const SizedBox(height: 8),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Scan to view health summary and share it with your doctor.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: "Poppins",
                          color: Color(0xFF23414E)),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: -15,
              right: -15,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF5F99A2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PopupMenuItem<String> _buildMenuItem(String text, IconData icon) {
    return PopupMenuItem<String>(
      value: text,
      child: Row(children: [
        Icon(icon, color: const Color(0xFF23414E), size: 20),
        const SizedBox(width: 10),
        Text(text,
            style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 14,
                color: Color(0xFF23414E))),
      ]),
    );
  }

  /// Whenever the user long‐presses (≈3 seconds) **anywhere** on this page,
  /// this function will be called, popping up the “Emergency” dialog.
  void _onLongPressAnywhere(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color.fromARGB(208, 213, 155, 145),
        title: const Text("Emergency"),
        content: const Text("Call emergency number 16?"),
        contentTextStyle: const TextStyle(
            fontSize: 16,
            fontFamily: "Poppins",
            color: Color.fromARGB(255, 86, 38, 38)),
        titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: "Poppins",
            color: const Color.fromARGB(255, 104, 20, 20)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // just close dialog
            child: const Text(
              "Cancel",
              style: TextStyle(color: Colors.white , fontFamily: "Poppins"),
            ),
          ),
        
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop(); // close the dialog first
              final uri = Uri(scheme: 'tel', path: '16');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              } else {
                // Could not launch phone dialer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Could not launch phone dialer.", style: TextStyle(color: Colors.white , fontFamily: "Poppins"),)),
                );
              }
            },
            child: const Text("Call 16" , style: TextStyle(color: Colors.white , fontFamily: "Poppins"),),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Wrap the entire contents in a GestureDetector that listens for a long press.
    return GestureDetector(
      onLongPress: () => _onLongPressAnywhere(context),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(children: [
            // Greeting + menu
            Row(children: [
              Expanded(
                child: Text('Hello, $_userName',
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                        color: Color(0xFF23414E))),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.menu, color: Color(0xFF23414E)),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                color: const Color.fromARGB(255, 177, 199, 210),
                elevation: 8,
                onSelected: (v) async {
                  switch (v) {
                    case 'Settings':
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingsView()));
                      break;
                    case 'Blog':
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => const BlogView()));
                      break;
                    case 'QR':
                      _showQRPopup(context);
                      break;
                    case 'Logout':
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginView()));
                      break;
                  }
                },
                itemBuilder: (_) => [
                  _buildMenuItem("Settings", Icons.settings),
                  _buildMenuItem("Blog", Icons.article),
                  _buildMenuItem("QR", Icons.qr_code),
                  _buildMenuItem("Logout", Icons.logout),
                ],
              ),
            ]),
            const SizedBox(height: 20),

            // Main content
            Expanded(
              child: ListView(children: [
                // Health summary
                _HealthSummaryCard(
                    bloodType: _bloodType,
                    bmi: _bmi,
                    disease: _disease,
                    phone: _phone),
                const SizedBox(height: 30),

                // ——— DYNAMIC Upcoming appointments ———
                _DynamicAppointmentsSection(
                  onGoToAppointments: widget.onGoToAppointments,
                  dateFormatter: _dateFmt,
                ),
                const SizedBox(height: 30),

                // ——— DYNAMIC Today’s medication ———
                const _DynamicMedicationsSection(),
              ]),
            ),
          ]),
        ),
      ),
    );
  }
}

/// Health Summary Card (unchanged)
class _HealthSummaryCard extends StatelessWidget {
  final String bloodType, disease, phone;
  final double bmi;
  const _HealthSummaryCard({
    required this.bloodType,
    required this.bmi,
    required this.disease,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5F99A2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.monitor_heart, color: Colors.white),
          SizedBox(width: 10),
          Text("Health summary",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _HealthMetric(label: "Blood type", value: bloodType),
          _HealthMetric(label: "BMI", value: bmi.toStringAsFixed(1)),
        ]),
        const SizedBox(height: 8),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _HealthMetric(label: "Disease", value: disease),
          _HealthMetric(label: "Emergency #", value: phone),
        ]),
      ]),
    );
  }
}

class _HealthMetric extends StatelessWidget {
  final String label;
  final String value;
  const _HealthMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label,
          style: const TextStyle(
              color: Colors.white70, fontSize: 13, fontFamily: "Poppins")),
      Text(value,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
              fontFamily: "Poppins")),
    ]);
  }
}

/// ——— DYNAMIC Upcoming Appointments Section ———
class _DynamicAppointmentsSection extends StatelessWidget {
  final VoidCallback onGoToAppointments;
  final DateFormat dateFormatter;

  const _DynamicAppointmentsSection({
    required this.onGoToAppointments,
    required this.dateFormatter,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upcoming appointments",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF23414E),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Tcolor.primary2.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: StreamBuilder<List<Appointment>>(
            // Now uses FirestoreService’s Appointment type directly:
            stream: FirestoreService().streamAppointments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 80,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return SizedBox(
                  height: 80,
                  child: Center(
                    child: Text("Error: ${snapshot.error}"),
                  ),
                );
              }

              final allApps = snapshot.data ?? [];
              final now = DateTime.now();

              // Filter only appointments after “now”
              final upcoming = allApps.where((a) => a.date.isAfter(now)).toList();

              if (upcoming.isEmpty) {
                return SizedBox(
                  height: 80,
                  child: Center(
                    child: Text(
                      "No upcoming appointments.",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                );
              }

              // Sort by earliest date
              upcoming.sort((a, b) => a.date.compareTo(b.date));
              final nextApp = upcoming.first;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: const [
                        Icon(Icons.calendar_month,
                            size: 30, color: Color(0xFF23414E)),
                        SizedBox(height: 34),
                        Icon(Icons.access_time,
                            size: 24, color: Color(0xFF23414E)),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nextApp.doctor ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              fontFamily: "Poppins",
                              color: Color(0xFF23414E),
                            ),
                          ),
                          Text(
                            nextApp.specialty ?? "",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: "Poppins",
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            dateFormatter.format(nextApp.date),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: onGoToAppointments,
                      child: const Icon(Icons.error_outline,
                          size: 30, color: Color(0xFF0F3C42)),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// ——— DYNAMIC Today’s Medications Section ———
class _DynamicMedicationsSection extends StatelessWidget {
  const _DynamicMedicationsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today’s medication",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF23414E),
          ),
        ),
        const SizedBox(height: 10),
        StreamBuilder<List<Medication>>(
          stream: FirestoreService().streamMedications(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 80,
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return SizedBox(
                height: 80,
                child: Center(child: Text("Error: ${snapshot.error}")),
              );
            }

            final allMeds = snapshot.data ?? [];
            final now = DateTime.now();

            // Include any medication where 'from' <= today <= 'to'
            final todayMeds = allMeds.where((m) {
              final fromDate = DateTime(m.from.year, m.from.month, m.from.day);
              final toDate = DateTime(m.to.year, m.to.month, m.to.day);
              final todayDate = DateTime(now.year, now.month, now.day);
              return !(todayDate.isBefore(fromDate) || todayDate.isAfter(toDate));
            }).toList();

            if (todayMeds.isEmpty) {
              return SizedBox(
                height: 80,
                child: Center(
                  child: Text(
                    "No medications for today.",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              );
            }

            return Column(
              children: todayMeds.map((med) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(13),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(210, 255, 255, 255),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          med.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Poppins",
                            color: Tcolor.primary.withOpacity(0.8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Icon(Icons.access_time,
                          size: 18, color: Tcolor.primary.withOpacity(0.8)),
                      const SizedBox(width: 6),
                      Text(
                        med.time,
                        style: TextStyle(
                          fontSize: 10,
                          fontFamily: "Poppins",
                          color: Tcolor.primary.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}
