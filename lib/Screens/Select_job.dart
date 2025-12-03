import 'package:flutter/material.dart';
import 'package:thenaukrimitra/Screens/CreateProfile.dart';
import 'package:thenaukrimitra/Screens/Login.dart';

class SelectJob extends StatefulWidget {
  final String phone;
  const SelectJob({super.key,required this.phone});
  @override
  State<SelectJob> createState() => _SelectJobState();
}
class _SelectJobState extends State<SelectJob> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromRGBO(236, 236, 245, 1)
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors: [
          //     Color.fromRGBO(236, 236, 245, 1)
          //     // Color.fromRGBO(237, 237, 237, 100), // White
          //     // Color.fromRGBO(255, 255, 255, 100),
          //     // Colors.white,
          //     // Color(0xFF7C82FF),
          //   ],
          // ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Container(

              child: Center(
                child: Column(
                  children: [
                    const SizedBox(height: 120),
                    // Logo
                    Image.asset(
                      'images/spl1.png',
                    ),
                    const SizedBox(height: 8),
                    const Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Rozgar ka ',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'Digital Saathi',
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 100),
                    // Button: I want to Job
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, MaterialPageRoute(
                            builder: (context)=>Login(phone: widget.phone,)));
                      },
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: const Icon(Icons.work, color: Colors.white,size: 30,),
                      ),
                       label: const Text(
                        'I want to Job',
                        style: TextStyle(fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Button: I want to Hire
                    ElevatedButton.icon(
                      onPressed: () {
                        // Action for "I want to Hire"
                      },
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: const Icon(Icons.person, color: Colors.white,size: 30,),
                      ),
                      label: const Text(
                        'I want to Hire',
                        style: TextStyle(fontSize: 18,
                            color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}



// redirect the CreateProfile
// import 'package:flutter/material.dart';
// import 'package:thenaukrimitra/Screens/CreateProfile.dart';
// import 'package:thenaukrimitra/Screens/Login.dart';
//
// class SelectJob extends StatefulWidget {
//   const SelectJob({super.key});
//   @override
//   State<SelectJob> createState() => _SelectJobState();
// }
// class _SelectJobState extends State<SelectJob> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(
//             color: Color.fromRGBO(236, 236, 245, 1)
//           // gradient: LinearGradient(
//           //   begin: Alignment.topCenter,
//           //   end: Alignment.bottomCenter,
//           //   colors: [
//           //     Color.fromRGBO(236, 236, 245, 1)
//           //     // Color.fromRGBO(237, 237, 237, 100), // White
//           //     // Color.fromRGBO(255, 255, 255, 100),
//           //     // Colors.white,
//           //     // Color(0xFF7C82FF),
//           //   ],
//           // ),
//         ),
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 25.0),
//             child: Container(
//
//               child: Center(
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 120),
//                     // Logo
//                     Image.asset(
//                       'images/spl1.png',
//
//
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.only(left: 25.0),
//                       child: const Text.rich(
//                         TextSpan(
//                           children: [
//                             TextSpan(
//                               text: 'Rozgar ka ',
//                               style: TextStyle(
//                                 color: Colors.blue,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//
//                             TextSpan(
//                               text: 'Digital Saathi',
//                               style: TextStyle(
//                                 color: Colors.orange,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ],
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//
//                     const SizedBox(height: 100),
//                     // Button: I want to Job
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                             context, MaterialPageRoute(
//                             builder: (context)=>CreateProfile(phone: '',)));
//                       },
//                       icon: Padding(
//                         padding: const EdgeInsets.only(right: 10.0),
//                         child: const Icon(Icons.work, color: Colors.white,size: 30,),
//                       ),
//                       label: const Text(
//                         'I want to Job',
//                         style: TextStyle(fontSize: 18,
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orangeAccent,
//                         minimumSize: const Size(double.infinity, 48),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//
//                     // Button: I want to Hire
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         // Action for "I want to Hire"
//                       },
//                       icon: Padding(
//                         padding: const EdgeInsets.only(right: 10.0),
//                         child: const Icon(Icons.person, color: Colors.white,size: 30,),
//                       ),
//                       label: const Text(
//                         'I want to Hire',
//                         style: TextStyle(fontSize: 18,
//                             color: Colors.white,fontWeight: FontWeight.bold),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.orangeAccent,
//                         minimumSize: const Size(double.infinity, 48),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(6),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
