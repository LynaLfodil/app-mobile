
import 'package:flutter/material.dart';
import 'package:carecaps2/common/color_extention.dart';
import 'package:carecaps2/view/on_boarding/on_boarding_view.dart';
import 'package:firebase_core/firebase_core.dart';
// Import all view pages here
import 'package:carecaps2/view/home/home_view.dart';
import 'package:carecaps2/view/home/appointments_view.dart';
import 'package:carecaps2/view/home/medication_view.dart';
import 'package:carecaps2/view/home/messages_view.dart';
import 'package:carecaps2/view/home/mrecords_view.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareCaps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Tcolor.primary,
        scaffoldBackgroundColor: const Color(0xFFE4F0F0),
        useMaterial3: true,
      ),
      home: const OnBoardingView(),
      routes: {
        '/home': (context) => const MainNavigation(),
      },
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentPage = 0;

  final List<Widget> pages = [
    const HomeView(),
    const MedicationView(),
    MessagesView(),
    const RecordsView(),
    const AppointmentsView(),
    
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentPage],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF23414E),
        type: BottomNavigationBarType.fixed,
        currentIndex: currentPage,
        onTap: (index) => setState(() => currentPage = index),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: [
          _buildItem(icon: Icons.home, index: 0),
          _buildItem(icon: Icons.medication_outlined, index: 1),
          _buildItem(icon: Icons.chat_bubble_outline, index: 2),
          _buildItem(icon: Icons.folder_open, index: 3),
          _buildItem(icon: Icons.calendar_today, index: 4),
        ],
      ),
    );
  }

  BottomNavigationBarItem _buildItem({required IconData icon, required int index}) {
    bool isSelected = currentPage == index;
    return BottomNavigationBarItem(
      label: '',
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFAAD8DB) : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 24),
      ),
    );
  }
}
