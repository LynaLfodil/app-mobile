import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/color_extention.dart';
import '../../common_widget/round_textfield.dart';
import '../home/home_view.dart';
import '../login/complete_profile_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _loginUser() async {
    setState(() { _isLoading = true; _errorMessage = ''; });

    try {
      final email = _emailController.text.trim();
      final pass  = _passwordController.text.trim();
      if (email.isEmpty || pass.isEmpty) throw FirebaseAuthException(code:'empty-fields',message:'Please fill in all fields');

      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);

      // check if profile complete
      final prefs = await SharedPreferences.getInstance();
      final done  = prefs.getBool('profileComplete') ?? false;

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => done 
              ? const HomeView() 
              : const CompleteProfileView()),
        );
      }
    } on FirebaseAuthException catch (e) {
      String msg;
      switch (e.code) {
        case 'user-not-found': msg='No user found with this email'; break;
        case 'wrong-password': msg='Incorrect password'; break;
        case 'invalid-email': msg='Invalid email format'; break;
        case 'user-disabled': msg='This account has been disabled'; break;
        case 'empty-fields': msg=e.message!; break;
        default: msg='Email or password incorrect. Please try again';
      }
      setState(() => _errorMessage = msg);
    } catch (_) {
      setState(() => _errorMessage = 'An unexpected error occurred');
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
                Text("Welcome Back", style: TextStyle(color: Tcolor.primary2, fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 30),
                RoundTextField(controller: _emailController, hitText: "Email", icon: "lib/assets/img/icons8-email-24.png", keyboardType: TextInputType.emailAddress, hintText: 'Example@mail.com', rigtIcon: TextButton(onPressed: () {}, child: const Text(''))),
                const SizedBox(height: 0),
                RoundTextField(controller: _passwordController, hitText: "Password", icon: "lib/assets/img/icons8-lock-24.png", obscureText: true, rigtIcon: TextButton(onPressed: () {}, child: Container(width:20,height:20,child: Image.asset("lib/assets/img/icons8-eye-48.png", color: Tcolor.primary2.withOpacity(0.4),))), hintText: 'password',), 
                const SizedBox(height: 10),
                if (_errorMessage.isNotEmpty) Padding(padding: const EdgeInsets.only(bottom:10), child: Text(_errorMessage, style: const TextStyle(color: Colors.red, fontSize:12))),
                Text("Forgot your password?", style: TextStyle(color: Tcolor.primary, fontSize:10, decoration: TextDecoration.underline)),
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: _isLoading ? null : _loginUser,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical:14),
                    decoration: BoxDecoration(color: _isLoading ? Tcolor.primary2.withOpacity(0.5) : Tcolor.primary2, borderRadius: BorderRadius.circular(15)),
                    alignment: Alignment.center,
                    child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Login", style: TextStyle(color: Colors.white, fontSize:16, fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(height: 20),
                Row(children:[
                  Expanded(child: Container(height:1, color: Tcolor.primary2.withOpacity(0.5))),
                  const Text("  Or  ", style: TextStyle(color:Color(0xFF23414E), fontSize:12)),
                  Expanded(child: Container(height:1, color: Tcolor.primary2.withOpacity(0.5))),
                ]),
                const SizedBox(height: 20),
                Text("Don't have an account?\nAsk your clinic to create one for you.", style: TextStyle(color: Tcolor.primary, fontSize:15), textAlign: TextAlign.center),
                const SizedBox(height:30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
