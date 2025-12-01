import 'dart:async';
import 'package:flutter/material.dart';
import 'package:thenaukrimitra/main_Screen/main_screen.dart';

import '../Screens/Select_language.dart';

import '../SessionManager/SessionManager.dart'; // ✅ apna home screen import karein

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 3));
    bool loggedIn = await SessionManager.isLoggedIn();

    if (!mounted) return;

    if (loggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen(
            title: "title", image: "image",
            fullName: "fullName", gender: "gender",
            education: "education", workExperience: "workExperience",
            salary: "salary", imageFile: null, skills: [""])),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SelectLanguage()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromRGBO(236, 236, 245, 1),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('images/spl1.png'),
                const Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Rozgar ka ',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'Digital Saathi',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}




// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../Screens/Select_language.dart';
//
// class Splash extends StatefulWidget {
//   const Splash({super.key});
//
//   @override
//   State<Splash> createState() => _SplashState();
// }
//
// class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     );
//     _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
//     _controller.forward();
//     Timer(const Duration(seconds: 3), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => const SelectLanguage()),
//       );
//     });
//   }
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//            color:  Color.fromRGBO(236, 236, 245, 1)
//
//         ),
//         child: Center(
//           child: FadeTransition(
//             opacity: _animation,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Image.asset(
//                   'images/spl1.png',
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(left: 20.0),
//                   child: const Text.rich(
//                     TextSpan(
//                       children: [
//                         TextSpan(
//                           text: 'Rozgar ka ',
//                           style: TextStyle(
//                             color: Colors.blue,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//
//                         TextSpan(
//                           text: 'Digital Saathi',
//                           style: TextStyle(
//                             color: Colors.orange,
//                             fontSize: 20,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }













// import 'package:flutter/material.dart';
//
// class Splash extends StatefulWidget {
//   const Splash({super.key});
//
//   @override
//   State<Splash> createState() => _SplashState();
// }
//
// class _SplashState extends State<Splash> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: [
//               Color(0xFF7C82FF),
//               Colors.white,
//             ],
//           ),
//         ),
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 'images/location.png',
//                 height: 100,
//               ),
//               const SizedBox(height: 20),
//               const Text.rich(
//                 TextSpan(
//                   children: [
//                     TextSpan(
//                       text: 'The ',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Naukri',
//                       style: TextStyle(
//                         color: Colors.blue,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     TextSpan(
//                       text: 'Mitra',
//                       style: TextStyle(
//                         color: Colors.orange,
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               const Text(
//                 'Rozgar Ka Digital Saathi',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.orange,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
