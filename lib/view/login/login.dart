import '../../common/color_extention.dart';
import '../../common_widget/round_textfield.dart';
import '../login/complete_profile_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _loginUser() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      if (email.isEmpty || password.isEmpty) {
        throw FirebaseAuthException(
          code: 'empty-fields',
          message: 'Please fill in all fields',
        );
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to CompleteProfileView on success
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const CompleteProfileView()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'invalid-email':
          errorMessage = 'Invalid email format';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled';
          break;
        case 'empty-fields':
          errorMessage = e.message ?? 'Please fill in all fields';
          break;
        default:
          errorMessage = 'Email or password incorrect. Please try again';
      }
      setState(() => _errorMessage = errorMessage);
    } catch (e) {
      setState(() => _errorMessage = 'An unexpected error occurred');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

                // Email field
                RoundTextField(
                  controller: _emailController,
                  hitText: "Email",
                  icon: "lib/assets/img/icons8-email-24.png",
                  keyboardType: TextInputType.emailAddress, hintText: 'Enter your Email', rigtIcon: TextButton(onPressed: () {}, child: const Text('')),
                ),
                const SizedBox(height: 20),

                // Password field
                RoundTextField(
                  controller: _passwordController,
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
                  ), hintText: 'Enter your password',
                ),
                const SizedBox(height: 10),

                // Error message
                if (_errorMessage.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _errorMessage,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),

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
                GestureDetector(
                  onTap: _isLoading ? null : _loginUser,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: _isLoading 
                          ? Tcolor.primary2.withOpacity(0.5)
                          : Tcolor.primary2,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    alignment: Alignment.center,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "Login",
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

                // Divider with "or"
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

                Text(
                  "Don't have an account?\nAsk your clinic to create one for you.",
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