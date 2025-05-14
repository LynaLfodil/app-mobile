import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../common/color_extention.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  bool isDarkMode = SchedulerBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;

  void toggleThemeMode() {
    setState(() {
      isDarkMode = !isDarkMode;
    });

    // You can use a provider or settings service for actual theme change across the app
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Switched to ${isDarkMode ? 'Dark' : 'Light'} Mode")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF23414E),
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),

          // Change Password
          ListTile(
            leading: const Icon(Icons.lock, color: Color(0xFF23414E)),
            title: const Text('Change Password', style: TextStyle(fontFamily: 'Poppins', fontSize: 16)),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Change Password tapped")));
            },
          ),
          const Divider(),

          // Language selection
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFF23414E)),
            title: const Text('Language', style: TextStyle(fontFamily: 'Poppins', fontSize: 16)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Select Language'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('English'),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Language set to English")),
                          );
                        },
                      ),
                      ListTile(
                        title: const Text('Arabic'),
                        onTap: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Language set to Arabic")),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const Divider(),
          // Log out
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFF23414E)),
            title: const Text('Log Out', style: TextStyle(fontFamily: 'Poppins', fontSize: 16)),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Confirm Logout"),
                  content: const Text("Are you sure you want to log out?"),
                  actions: [
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text("Log Out"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        // Add your logout logic
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
