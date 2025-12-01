import 'package:flutter/material.dart';
import 'package:thenaukrimitra/Screens/Select_job.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({super.key});

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  final List<String> languages = [
    'हिंदी',
    'English',
    'ਪੰਜਾਬੀ',
    'ગુજરાતી',
    'मराठी',
  ];
  String selectedLanguage = '';
  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width * 0.85;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
            color: Color.fromRGBO(236, 236, 245, 1)
          // gradient: LinearGradient(
          //   begin: Alignment.topCenter,
          //   end: Alignment.bottomCenter,
          //   colors:  [
          //
          //     // Color.fromRGBO(237, 237, 237, 100), // White
          //     // Color.fromRGBO(255, 255, 255, 100), // #7C82FF
          //      // White
          //   ],
          // ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'images/spl1.png',
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: const Text.rich(
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
              const SizedBox(height: 40),

              // Show selected language in TextField
              if (selectedLanguage.isNotEmpty)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: TextField(
                    enabled: false,
                    controller: TextEditingController(text: selectedLanguage),
                    decoration: const InputDecoration(
                      hintText: 'Selected Language',
                      border: InputBorder.none,
                      icon: Icon(Icons.language),
                    ),
                  ),
                ),

              // Language buttons
              ...languages.map((lang) {
                bool isSelected = selectedLanguage == lang;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  child: SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        isSelected ? Colors.orange : Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedLanguage = lang;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            lang,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
              const SizedBox(height: 30),

              // Confirm Button
              if (selectedLanguage.isNotEmpty)
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SelectJob(phone: '',),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    // padding:
                    // const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'SELECT ${selectedLanguage.toUpperCase()}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:thenaukrimitra/Screens/Select_job.dart';
//
// class SelectLanguage extends StatefulWidget {
//   const SelectLanguage({super.key});
//
//   @override
//   State<SelectLanguage> createState() => _SelectLanguageState();
// }
//
// class _SelectLanguageState extends State<SelectLanguage> {
//   final List<String> languages = [
//     'हिंदी',
//     'English',
//     'ਪੰਜਾਬੀ',
//     'ગુજરાતી',
//     'मराठी',
//   ];
//   String selectedLanguage = '';
//    @override
//   Widget build(BuildContext context) {
//     double buttonWidth = MediaQuery.of(context).size.width * 0.85;
//
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         height: double.infinity,
//         decoration: const BoxDecoration(
//           color: Color.fromRGBO(236, 236, 245, 1)
//           // gradient: LinearGradient(
//           //   begin: Alignment.topCenter,
//           //   end: Alignment.bottomCenter,
//           //   colors:  [
//           //
//           //     // Color.fromRGBO(237, 237, 237, 100), // White
//           //     // Color.fromRGBO(255, 255, 255, 100), // #7C82FF
//           //      // White
//           //   ],
//           // ),
//         ),
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 150),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Logo
//               Image.asset(
//                 'images/spl1.png',
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 25.0),
//                 child: const Text.rich(
//                   TextSpan(
//                     children: [
//                       TextSpan(
//                         text: 'Rozgar ka ',
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       TextSpan(
//                         text: 'Digital Saathi',
//                         style: TextStyle(
//                           color: Colors.orange,
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               const SizedBox(height: 40),
//
//               // Show selected language in TextField
//               if (selectedLanguage.isNotEmpty)
//                 Container(
//                   margin: const EdgeInsets.only(bottom: 20),
//                   padding: const EdgeInsets.symmetric(horizontal: 12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(6),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 4,
//                       )
//                     ],
//                   ),
//                   child: TextField(
//                     enabled: false,
//                     controller: TextEditingController(text: selectedLanguage),
//                     decoration: const InputDecoration(
//                       hintText: 'Selected Language',
//                       border: InputBorder.none,
//                       icon: Icon(Icons.language),
//                     ),
//                   ),
//                 ),
//
//               // Language buttons
//               ...languages.map((lang) {
//                 bool isSelected = selectedLanguage == lang;
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 6.0),
//                   child: SizedBox(
//                     width: buttonWidth,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                         isSelected ? Colors.orange : Colors.blue,
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           selectedLanguage = lang;
//                         });
//                       },
//                       child: Padding(
//                         padding: const EdgeInsets.only(left: 12.0),
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             lang,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//               const SizedBox(height: 30),
//
//               // Confirm Button
//               if (selectedLanguage.isNotEmpty)
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => const SelectJob(phone: '',),
//                       ),
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.blue,
//                     // padding:
//                     // const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                   ),
//                   child: Text(
//                     'SELECT ${selectedLanguage.toUpperCase()}',
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
