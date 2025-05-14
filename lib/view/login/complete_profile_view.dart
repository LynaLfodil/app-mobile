import 'package:flutter_svg/svg.dart';
import '../../common/color_extention.dart';
import 'package:flutter/material.dart';
import '../home/home_view.dart';

class CompleteProfileView extends StatefulWidget {
  const CompleteProfileView({super.key});

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  TextEditingController txtDate = TextEditingController();
  TextEditingController txtWeight = TextEditingController();
  TextEditingController txtHeight = TextEditingController();
  TextEditingController txtPhone = TextEditingController();
  TextEditingController txtDisease = TextEditingController();

  String? selectedBloodType;

  // @override
  // void initState() {
  //   super.initState();
  //   txtWeight.addListener(_calculateBMI);
  //   txtHeight.addListener(_calculateBMI);
  // }

  // void _calculateBMI() {
  //   final weight = double.tryParse(txtWeight.text);
  //   final heightCm = double.tryParse(txtHeight.text);

  //   if (weight != null && heightCm != null && heightCm > 0) {
  //     final heightM = heightCm / 100;
  //     final bmi = weight / (heightM * heightM);
  //     txtBMI.text = bmi.toStringAsFixed(1);
  //   } else {
  //     txtBMI.text = '';
  //   }
  // }

  @override
  void dispose() {
    // txtWeight.removeListener(_calculateBMI);
    // txtHeight.removeListener(_calculateBMI);
    txtDate.dispose();
    txtWeight.dispose();
    txtHeight.dispose();
    txtPhone.dispose();
    txtDisease.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    "lib/assets/img/undraw_profile_d7qw.svg",
                    width: media.width * 0.7,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Complete your medical profile",
                    style: TextStyle(
                      color: Tcolor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "These informations can help during emergencies",
                    style: TextStyle(color: Tcolor.primary2, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  /// Blood Type
                  Container(
                    height: 48,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Tcolor.lightGrey,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          "lib/assets/img/icons8-blood-30.png",
                          width: 20,
                          height: 20,
                          color: Tcolor.grey,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedBloodType,
                              isExpanded: true,
                              onChanged: (value) {
                                setState(() {
                                  selectedBloodType = value;
                                });
                              },
                              hint: Text(
                                "Select Blood Type",
                                style: TextStyle(color: Tcolor.grey, fontSize: 14),
                              ),
                              items: ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
                                  .map((type) => DropdownMenuItem(
                                        value: type,
                                        child: Text(
                                          type,
                                          style: TextStyle(color: Tcolor.grey, fontSize: 14),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Weight and Height
                  Row(
                    children: [
                      Expanded(
                        child: customSmallTextField(
                          controller: txtWeight,
                          hint: "Weight (kg)",
                          iconPath: "lib/assets/img/icons8-bmi-30.png",
                          inputType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: customSmallTextField(
                          controller: txtHeight,
                          hint: "Height (cm)",
                          iconPath: "lib/assets/img/icons8-meter-30.png",
                          inputType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // /// BMI result
                  // customSmallTextField(
                  //   controller: txtBMI,
                  //   hint: "Your BMI (auto-calculated)",
                  //   iconPath: "lib/assets/img/icons8-bmi-30.png",
                  //   inputType: TextInputType.number,
                  //   readOnly: true,
                  // ),
                  // const SizedBox(height: 16),

                  /// Emergency Phone
                  customSmallTextField(
                    controller: txtPhone,
                    hint: "Emergency Phone Number",
                    iconPath: "lib/assets/img/icons8-phone-48.png",
                    inputType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),

                  /// Chronic Disease
                  customSmallTextField(
                    controller: txtDisease,
                    hint: "Chronic Disease (if any)",
                    iconPath: "lib/assets/img/icons8-medication-50.png",
                  ),
                  const SizedBox(height: 24),

                  /// Finish Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeView()),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: Tcolor.primary2,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "Finish",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Small Custom TextField (matches dropdown height)
  Widget customSmallTextField({
    required TextEditingController controller,
    required String hint,
    required String iconPath,
    TextInputType inputType = TextInputType.text,
    bool readOnly = false,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Tcolor.lightGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Image.asset(
            iconPath,
            width: 20,
            height: 20,
            color: Tcolor.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: inputType,
              readOnly: readOnly,
              style: TextStyle(fontSize: 14, color: Tcolor.grey),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(color: Tcolor.grey),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
