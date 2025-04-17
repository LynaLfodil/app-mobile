import 'package:carecaps2/common/color_extention.dart';
import 'package:carecaps2/view/on_boarding/on_boarding_view.dart';
import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CareCaps',
      theme: ThemeData(
        primaryColor  :Tcolor.primary,
      ),
      
      home: const OnBoardingView(),
      routes: {
        '/home': (context) => const HomeView(),
      },
    );
  }
  
}



class HomeView  extends StatelessWidget {
  const HomeView({super.key});
  
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
  
}
