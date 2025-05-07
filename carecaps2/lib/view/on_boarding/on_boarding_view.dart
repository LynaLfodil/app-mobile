import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../common/color_extention.dart';
import '../login/login.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  final PageController controller = PageController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      setState(() {
        selectPage = controller.page?.round() ?? 0;
      });
    });
  }

  final List<Map<String, dynamic>> pages = [
    {
      "intro": "Welcome to",
      "image": "lib/assets/img/Asset3.png",
      "title": "CareCaps",
      "description":
          "Your all-in-one health app to manage appointments, communicate with your doctor, and track your health",
    },
    {
      "image": "lib/assets/img/undraw_doctor_aum1.svg",
      "title": "Manage Appointments & Talk to Your Doctor",
      "description":
          "Upcoming Appointments: View and manage your visits.\nChat with Your Doctor: Securely message your doctor for advice.",
    },
    {
      "image": "lib/assets/img/undraw_my-app_15n4.svg",
      "title": "Health Records & Emergency Help",
      "description":
          "View past visits and treatments.\nUpload and store test results.\nKeep track of your medications.\nInstant help with one tap.",
    },
    {
      "title": "Who are you?",
      "description": "Please select your user type to continue.",
      "isSelection": true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: controller,
                itemCount: pages.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) => _buildPageContent(pages[index]),
              ),
            ),

            // Buttons Section
            if (selectPage < pages.length - 1) ...[
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selectPage > 0)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Tcolor.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                      ),
                      onPressed: () {
                        controller.previousPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                      },
                      child: const Text(
                        "Prev",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'poppins'),
                      ),
                    ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Tcolor.primary2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 12),
                    ),
                    onPressed: () {
                      controller.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      );
                    },
                    child: Text(
                      selectPage == pages.length - 2 ? "Get Started" : "Next",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'poppins'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectPage == index
                          ? Tcolor.secondary
                          : Tcolor.secondary.withOpacity(0.3),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(Map pObj) {
    if (pObj["isSelection"] == true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Text(
            pObj["title"],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Tcolor.primary,
              fontFamily: 'poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            pObj["description"],
            style: TextStyle(
              fontSize: 15,
              color: Tcolor.primary2,
              fontFamily: 'poppins',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          Column(
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Tcolor.secondary.withOpacity(0.5),
                    border: Border.all(color: Tcolor.secondary.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("lib/assets/img/Asset 5.png", width: 40, height: 40),
                      const SizedBox(width: 15),
                      const Text("Doctor",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'poppins',
                              color: Color.fromARGB(255, 83, 20, 20))),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginView()));
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Tcolor.primary2.withOpacity(0.5),
                    border: Border.all(color: Tcolor.primary2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("lib/assets/img/Asset 2.png", width: 40, height: 40),
                      const SizedBox(width: 10),
                      const Text("Patient",
                          style: TextStyle(
                              fontSize: 15,
                              fontFamily: 'poppins',
                              color: Color.fromARGB(255, 15, 47, 61))),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const Spacer(),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        if (pObj["intro"] != null)
          Text(
            pObj["intro"],
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Tcolor.primary,
              fontFamily: 'poppins',
            ),
          ),
        const SizedBox(height: 16),
        if (pObj["image"] != null && pObj["image"].toString().endsWith('.svg'))
          SvgPicture.asset(
            pObj["image"],
            width: 150,
            height: 150,
            fit: BoxFit.contain,
            placeholderBuilder: (_) => const CircularProgressIndicator(),
          )
        else if (pObj["image"] != null)
          Image.asset(
            pObj["image"],
            width: 150,
            height: 150,
            fit: BoxFit.contain,
          ),
        const SizedBox(height: 20),
        Text(
          pObj["title"] ?? '',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Tcolor.primary,
            fontFamily: 'poppins',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Text(
            pObj["description"] ?? '',
            style: TextStyle(
              fontSize: 15,
              fontFamily: 'poppins',
              color: Tcolor.primary2,
            ),
            textAlign: TextAlign.start,
          ),
        ),
        const SizedBox(height: 40),
        if (selectPage < 3)
          ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginView()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:  Color.fromARGB(255, 237, 235, 235),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding:  EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.2,
                vertical: 12,
              ),
            ),
            child: const Text(
              "Skip",
              style: TextStyle(
                color: Color.fromARGB(255, 90, 90, 90),
                fontSize: 14,
                fontFamily: 'poppins',
              ),
            ),
          ),
        const Spacer(),
      ],
    );
  }
}
