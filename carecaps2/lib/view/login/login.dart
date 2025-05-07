import '../../common/color_extention.dart';
import '../../common_widget/round_button.dart';
import '../../common_widget/round_textfield.dart';
import '../login/complete_profile_view.dart';
import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 27),
                Text(
                  "Welcome Back",
                  style: TextStyle(
                    color: Tcolor.primary2,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 30),

                // Phone field
                const RoundTextField(
                  hitText: "Phone number",
                  icon: "lib/assets/img/icons8-phone-48.png",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 20),

                // Password field
                RoundTextField(
                  hitText: "Password",
                  icon: "lib/assets/img/icons8-lock-24.png",
                  obscureText: true,
                  rigtIcon: TextButton(
                    onPressed: () {},
                    child: Container(
                      alignment: Alignment.center,
                      width: 20,
                      height: 20,
                      child: Image.asset(
                        "lib/assets/img/icons8-eye-48.png",
                        width: 20,
                        height: 20,
                        fit: BoxFit.contain,
                        color: Tcolor.primary2.withOpacity(0.4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                Text(
                  "Forgot your password?",
                  style: TextStyle(
                    color: Tcolor.primary,
                    fontSize: 10,
                    fontFamily: 'Poppins',
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 40),

                // Login button
                RoundButton(
                  title: "Login",
                  type: RoundButtonType.solid,
                  backgroundColor: Tcolor.primary2,
                  textColor: Tcolor.white,
                  fontWeight: FontWeight.normal,
                  textFontFamily: 'Poppins',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CompleteProfileView(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // ✅ Divider with "or"
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Tcolor.primary2.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      "  Or  ",
                      style: TextStyle(
                        color: Tcolor.primary,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Tcolor.primary2.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // ✅ Replaced Google login with clinic instruction
                Text(
                  "Don’t have an account?\nAsk your clinic to create one for you.",
                  style: TextStyle(
                    color: Tcolor.primary,
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
