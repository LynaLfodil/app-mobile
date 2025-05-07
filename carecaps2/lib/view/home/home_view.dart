import 'package:carecaps2/view/login/login.dart';
import 'package:flutter/material.dart';
import '../../common/color_extention.dart';
import 'appointments_view.dart';
import 'medication_view.dart';
import 'messages_view.dart';
import 'mrecords_view.dart';
import 'settings_view.dart';
import 'blog_view.dart';
import 'qr_medical_record_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeContent(),
    MedicationView(),
    AppointmentsView(),
    RecordsView(),
    MessagesView(),
  ];

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
            borderRadius: BorderRadius.circular(30),
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
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFB9E7F0) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isSelected ? const Color.fromARGB(255, 22, 82, 102) : Colors.white54,
          size: 26,
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Hello , User',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                      color: Color(0xFF23414E),
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.menu, color: Color(0xFF23414E)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: const Color.fromARGB(255, 177, 199, 210),
                  elevation: 8,
                  onSelected: (value) {
                    switch (value) {
                      case 'Settings':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsView()));
                        break;
                      case 'Blog':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const BlogView()));
                        break;
                      case 'QR':
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const QRMedicalRecordView()));
                        break;
                      case 'Logout':
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginView()));
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    _buildMenuItem("Settings", Icons.settings),
                    _buildMenuItem("Blog", Icons.article),
                    _buildMenuItem("QR", Icons.qr_code),
                    _buildMenuItem("Logout", Icons.logout),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: const [
                  // Health Summary Card
                  _HealthSummaryCard(),
                  SizedBox(height: 30),
                  _AppointmentsSection(),
                  SizedBox(height: 30),
                  _MedicationsSection(),
                ],
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
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF23414E), size: 20),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
              fontFamily: "Poppins",
              fontSize: 14,
              color: Color(0xFF23414E),
            ),
          ),
        ],
      ),
    );
  }
}



class _HealthSummaryCard extends StatelessWidget {
  const _HealthSummaryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF5F99A2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.monitor_heart, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "Health summary",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _HealthMetric(label: "Blood type", value: "O+"),
              _HealthMetric(label: "BMI", value: "22.5"),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _HealthMetric(label: "cro desease", value: "diabetes"),
              _HealthMetric(label: "emrg number", value: "0559584613"),
            ],
          ),
        ],
      ),
    );
  }
}

class _AppointmentsSection extends StatelessWidget {
  const _AppointmentsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Upcoming appointments",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: const Color(0xFF23414E),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Tcolor.primary2.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.calendar_month, size: 30, color: Color(0xFF23414E)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Dr Sara L",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          fontFamily: "Poppins",
                          color: Color(0xFF23414E),
                        ),
                      ),
                      Text(
                        "Cardiologist",
                        style: TextStyle(fontSize: 10, color: Colors.grey, fontFamily: "Poppins"),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 15),
                          SizedBox(width: 6),
                          Text(
                            "Wednesday , 10.00 AM",
                            style: TextStyle(fontSize: 10, color: Colors.grey, fontFamily: "Poppins"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF23414E),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
                  child: const Text("Details", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MedicationsSection extends StatelessWidget {
  const _MedicationsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "Today’s medication",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
            color: Color(0xFF23414E),
          ),
        ),
        SizedBox(height: 10),
        _MedicationItem(name: "Paracetamol 500mg", time: "8AM, 2PM, 8PM"),
        _MedicationItem(name: "Amoxicillin 250mg", time: "7AM, 7PM"),
        _MedicationItem(name: "Vitamin D 1000 IU", time: "10AM"),
        _MedicationItem(name: "Metformin 500mg", time: "9AM"),
      ],
    );
  }
}

class _HealthMetric extends StatelessWidget {
  final String label;
  final String value;
  const _HealthMetric({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
        Text(
          value,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
        ),
      ],
    );
  }
}

class _MedicationItem extends StatelessWidget {
  final String name;
  final String time;
  const _MedicationItem({required this.name, required this.time});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Tcolor.primary.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(fontSize: 14, fontFamily: "Poppins", color: Tcolor.primary),
            ),
          ),
          Icon(Icons.access_time, size: 18, color: Tcolor.primary),
          const SizedBox(width: 6),
          Text(time, style: TextStyle(fontSize: 13, color: Tcolor.primary)),
        ],
      ),
    );
  }
}
