import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:carecaps2/view/home/home_view.dart';
import 'package:flutter_svg/svg.dart';
import '../../common/color_extention.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final txtWeight = TextEditingController();
  final txtHeight = TextEditingController();
  final txtPhone  = TextEditingController();
  final txtDisease= TextEditingController();
  String? selectedBloodType;

  @override
  void dispose() {
    txtWeight.dispose();
    txtHeight.dispose();
    txtPhone.dispose();
    txtDisease.dispose();
    super.dispose();
  }

  Future<void> _onFinish() async {
    final prefs = await SharedPreferences.getInstance();

    // parse numbers
    final weight = double.tryParse(txtWeight.text) ?? 0.0;
    final heightCm= double.tryParse(txtHeight.text) ?? 0.0;
    final heightM = heightCm / 100;
    final bmi     = (heightM > 0) ? (weight / (heightM * heightM)) : 0.0;

    // save everything
    await prefs.setString('bloodType', selectedBloodType ?? '');
    await prefs.setDouble('weight', weight);
    await prefs.setDouble('height', heightCm);
    await prefs.setDouble('bmi', bmi);
    await prefs.setString('phone', txtPhone.text.trim());
    await prefs.setString('disease', txtDisease.text.trim());
    await prefs.setBool('profileComplete', true);

    // go to home
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "lib/assets/img/undraw_profile_d7qw.svg",
                  width: media.width * 0.7,
                ),
                const SizedBox(height: 16),
                Text(
                  "Complete your medical profile",
                  style: TextStyle(color: Tcolor.primary, fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  "These informations can help during emergencies",
                  style: TextStyle(color: Tcolor.primary2, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Blood Type dropdown
                Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(color: Tcolor.lightGrey, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: [
                      Image.asset("lib/assets/img/icons8-blood-30.png", width: 20, height: 20, color: Tcolor.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedBloodType,
                            isExpanded: true,
                            hint: Text("Select Blood Type", style: TextStyle(color: Tcolor.grey, fontSize: 14)),
                            items: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
                                .map((t) => DropdownMenuItem(value: t, child: Text(t, style: TextStyle(color: Tcolor.grey, fontSize: 14))))
                                .toList(),
                            onChanged: (v) => setState(() => selectedBloodType = v),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Weight & Height
                Row(
                  children: [
                    Expanded(child: _smallField(txtWeight, "Weight (kg)", "lib/assets/img/icons8-bmi-30.png", TextInputType.number)),
                    const SizedBox(width: 12),
                    Expanded(child: _smallField(txtHeight,"Height (cm)", "lib/assets/img/icons8-meter-30.png", TextInputType.number)),
                  ],
                ),
                const SizedBox(height: 16),

                // Phone & Disease
                _smallField(txtPhone,  "Emergency Phone Number","lib/assets/img/icons8-phone-48.png", TextInputType.phone),
                const SizedBox(height: 16),
                _smallField(txtDisease,"Chronic Disease (if any)","lib/assets/img/icons8-medication-50.png", TextInputType.text),
                const SizedBox(height: 24),

                GestureDetector(
                  onTap: _onFinish,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(color: Tcolor.primary2, borderRadius: BorderRadius.circular(15)),
                    alignment: Alignment.center,
                    child: const Text("Finish", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _smallField(TextEditingController c, String hint, String icon, TextInputType kt) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: Tcolor.lightGrey, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          Image.asset(icon, width: 20, height: 20, color: Tcolor.grey),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: c,
              keyboardType: kt,
              style: TextStyle(fontSize: 14, color: Tcolor.grey),
              decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: Tcolor.grey), border: InputBorder.none, isCollapsed: true),
            ),
          ),
        ],
      ),
    );
  }
}
