import 'package:flutter/material.dart';

import '../../common/color_extention.dart';
import '../../common_widget/on_boarding_page.dart';
import '../login/login.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  PageController controller = PageController();
  @override
  initState() {
    super.initState();
    controller.addListener(() {
      selectPage = controller.page?.round() ?? 0;
      setState(() {});
    });
  }

  List pages = [
    {
      "intro": "Welcome to",
      "image": "lib/assets/img/Asset3.png",
      "title": "CareCaps",
      "description": [
        "Your all-in-one health app to manage appointments, communicate with your doctor, and track your health",
      ].join('\n'),
    },
    {
      "image": "lib/assets/img/undraw_doctor_aum1.svg",
      "title": "Manage Appointments & Talk to Your Doctor",
      "description": [
        "Upcoming Appointments: View and manage your visits.",
        "Chat with Your Doctor: Securely message your doctor for advice.",
      ].join('\n'),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: controller,
            itemCount: pages.length,
            itemBuilder: (context, index) {
              var pObj = pages[index] as Map? ?? {};
              return OnBoardingPage(pObj: pObj);
            },
          ),

          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    color: Tcolor.primary,
                    value: (selectPage + 1) / 3,
                    strokeWidth: 3,
                  ),
                ),

                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 30,
                  ),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Tcolor.primary,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: IconButton(
                    icon: Icon(Icons.navigate_next, color: Tcolor.white),
                    onPressed: () {
                      if (selectPage < 3) {
                        selectPage = selectPage + 1;

                        controller.animateToPage(
                          selectPage,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.bounceInOut,
                        );

                        // controller.jumpToPage(selectPage);
                        column(
                          children: [
                            Image.asset(
                              'lib/assets/img/Asset3.png',
                              width: 100, // make smaller here
                              height: 150,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "CareCaps",
                              style: TextStyle(
                                color: Tcolor.primary,
                                fontSize: 60,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        );
                        setState(() {});
                      } else {
                        // Open Welcome Screen
                        // ignore: avoid_print
                        print("Open Welcome Screen");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginView(),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void column({required List<Widget> children}) {
} 