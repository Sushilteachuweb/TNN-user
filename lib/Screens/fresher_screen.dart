// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:thenaukrimitra/Home_screens/home_screen.dart';
// import 'package:thenaukrimitra/main_Screen/main_screen.dart';
//
// class FresherScreen extends StatefulWidget {
//   final String title;
//   final String image;
//   final String fullName;
//   final String gender;
//   final String education;
//   final String workExperience;
//   final String salary;
//   final File imageFile;
//
//   const FresherScreen({
//     super.key,
//     required this.title,
//     required this.image,
//     required this.fullName,
//     required this.gender,
//     required this.education,
//     required this.workExperience,
//     required this.salary,
//     required this.imageFile,
//   });
//
//   @override
//   State<FresherScreen> createState() => _FresherScreenState();
// }
//
// class _FresherScreenState extends State<FresherScreen> {
//   final TextEditingController _skillController = TextEditingController();
//
//   final List<String> _availableSkills = [
//     'AutoCad',
//     'Photoshop',
//     'Corel Draw',
//     'Animation',
//     'Video Editing',
//     'UI_UX'
//   ];
//
//   final List<String> _selectedSkills = [];
//
//   void _addSkill(String skill) {
//     if (skill.isNotEmpty && !_selectedSkills.contains(skill)) {
//       setState(() {
//         _selectedSkills.add(skill);
//       });
//     }
//     _skillController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEFEFF6),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Back Button
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.blue),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//
//                 // Profile Card
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.asset(
//                           widget.image,
//                           width: 60,
//                           height: 60,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           widget.title,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // Skill Input
//                 const Text("Skills",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _skillController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           hintText: 'Add Your Skills',
//                           hintStyle: const TextStyle(color: Colors.grey),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 12),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     // ElevatedButton(
//                     //   onPressed: () => _addSkill(_skillController.text),
//                     //   style: ElevatedButton.styleFrom(
//                     //     backgroundColor: Colors.blue,
//                     //     shape: const CircleBorder(),
//                     //     padding: const EdgeInsets.all(14),
//                     //   ),
//                     //   // child: const Icon(Icons.add, color: Colors.white),
//                     // )
//                   ],
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 const Text("Select your skills",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//
//                 // Skills Chips
//                 Center(
//                   child: Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: _availableSkills.map((skill) {
//                       return GestureDetector(
//                         onTap: () => _addSkill(skill),
//                         child: Chip(
//                           backgroundColor: Colors.orange.shade300,
//                           label: Text(skill,
//                               style: const TextStyle(color: Colors.white)),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 if (_selectedSkills.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Your Selected Skills:",
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: _selectedSkills.map((skill) {
//                           return Chip(
//                             backgroundColor: Colors.blue.shade200,
//                             label: Text(skill),
//                             onDeleted: () {
//                               setState(() {
//                                 _selectedSkills.remove(skill);
//                               });
//                             },
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//
//                 const SizedBox(height: 100),
//
//                 // Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 30, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text(
//                         "Back",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16),
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 30, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                       ),
//                       onPressed: () {
//                         if (_selectedSkills.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text("Please add at least one skill")),
//                           );
//                           return;
//                         }
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             // MainScreen karna hai
//                             builder: (context) => HomeScreen(
//                               title: widget.title,
//                               image: widget.image,
//                               fullName: widget.fullName,
//                               gender: widget.gender,
//                               education: widget.education,
//                               workExperience: widget.workExperience,
//                               salary: widget.salary,
//                               imageFile: widget.imageFile,
//                               // skills: _selectedSkills, // 👈 yeh bhej raha hoon
//                             ),
//                           ),
//                         );
//
//                         print("Selected Skills: $_selectedSkills");
//                       },
//                       child: const Text(
//                         "Next",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }








// main Screen add
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thenaukrimitra/main_Screen/main_screen.dart';
class FresherScreen extends StatefulWidget {

  final String title;
  final String image;
  final String fullName;
  final String gender;
  final String education;
  final String workExperience;
  final String salary;
  final File imageFile;
  const FresherScreen({
    super.key,
    required this.title,
    required this.image,
    required this.fullName,
    required this.gender,
    required this.education,
    required this.workExperience,
    required this.salary,
    required this.imageFile,
  });

  @override
  State<FresherScreen> createState() => _FresherScreenState();
}

class _FresherScreenState extends State<FresherScreen> {
  final TextEditingController _skillController = TextEditingController();

  final List<String> _availableSkills = [
    'AutoCad',
    'Photoshop',
    'Corel Draw',
    'Animation',
    'Video Editing',
    'UI_UX'
  ];

  final List<String> _selectedSkills = [];

  void _addSkill(String skill) {
    if (skill.isNotEmpty && !_selectedSkills.contains(skill)) {
      setState(() {
        _selectedSkills.add(skill);
      });
    }
    _skillController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEFF6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.blue),
                  onPressed: () => Navigator.pop(context),
                ),

                // Profile Card
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          widget.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Skill Input
                const Text("Skills",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _skillController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Add Your Skills',
                          hintStyle: const TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // ElevatedButton(
                    //   onPressed: () => _addSkill(_skillController.text),
                    //   style: ElevatedButton.styleFrom(
                    //     backgroundColor: Colors.blue,
                    //     shape: const CircleBorder(),
                    //     padding: const EdgeInsets.all(14),
                    //   ),
                    //   // child: const Icon(Icons.add, color: Colors.white),
                    // )
                  ],
                ),

                const SizedBox(height: 20),

                const Text("Select your skills",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                // Skills Chips
                Center(
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _availableSkills.map((skill) {
                      return GestureDetector(
                        onTap: () => _addSkill(skill),
                        child: Chip(
                          backgroundColor: Colors.orange.shade300,
                          label: Text(skill,
                              style: const TextStyle(color: Colors.white)),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                if (_selectedSkills.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Your Selected Skills:",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _selectedSkills.map((skill) {
                          return Chip(
                            backgroundColor: Colors.blue.shade200,
                            label: Text(skill),
                            onDeleted: () {
                              setState(() {
                                _selectedSkills.remove(skill);
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                const SizedBox(height: 100),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "Back",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        if (_selectedSkills.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Please add at least one skill")),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            // MainScreen karna hai
                            builder: (context) => MainScreen(
                              title: widget.title,
                              image: widget.image,
                              fullName: widget.fullName,
                              gender: widget.gender,
                              education: widget.education,
                              workExperience: widget.workExperience,
                              salary: widget.salary,
                              imageFile: widget.imageFile, skills: [],

                            ),
                          ),
                        );

                        print("Selected Skills: $_selectedSkills");
                      },
                      child: const Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}






//without mainscreen add
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:thenaukrimitra/Home_screens/home_screen.dart';
//
// class FresherScreen extends StatefulWidget {
//   final String title;
//   final String image;
//   final String fullName;
//   final String gender;
//   final String education;
//   final String workExperience;
//   final String salary;
//   final File imageFile;
//
//   const FresherScreen({
//     super.key,
//     required this.title,
//     required this.image,
//     required this.fullName,
//     required this.gender,
//     required this.education,
//     required this.workExperience,
//     required this.salary,
//     required this.imageFile,
//   });
//
//   @override
//   State<FresherScreen> createState() => _FresherScreenState();
// }
//
// class _FresherScreenState extends State<FresherScreen> {
//   final TextEditingController _skillController = TextEditingController();
//
//   final List<String> _availableSkills = [
//     'AutoCad',
//     'Photoshop',
//     'Corel Draw',
//     'Animation',
//     'Video Editing',
//     'UI_UX'
//   ];
//
//   final List<String> _selectedSkills = [];
//
//   void _addSkill(String skill) {
//     if (skill.isNotEmpty && !_selectedSkills.contains(skill)) {
//       setState(() {
//         _selectedSkills.add(skill);
//       });
//     }
//     _skillController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEFEFF6),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Back Button
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.blue),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//
//                 // Profile Card
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.asset(
//                           widget.image,
//                           width: 60,
//                           height: 60,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           widget.title,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // Skill Input
//                 const Text("Skills",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 6),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: _skillController,
//                         decoration: InputDecoration(
//                           filled: true,
//                           fillColor: Colors.white,
//                           hintText: 'Add Your Skills',
//                           hintStyle: const TextStyle(color: Colors.grey),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(30),
//                           ),
//                           contentPadding: const EdgeInsets.symmetric(
//                               horizontal: 20, vertical: 12),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     ElevatedButton(
//                       onPressed: () => _addSkill(_skillController.text),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         shape: const CircleBorder(),
//                         padding: const EdgeInsets.all(14),
//                       ),
//                       child: const Icon(Icons.add, color: Colors.white),
//                     )
//                   ],
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 const Text("Select your skills",
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//
//                 // Skills Chips
//                 Center(
//                   child: Wrap(
//                     spacing: 10,
//                     runSpacing: 10,
//                     children: _availableSkills.map((skill) {
//                       return GestureDetector(
//                         onTap: () => _addSkill(skill),
//                         child: Chip(
//                           backgroundColor: Colors.orange.shade300,
//                           label: Text(skill,
//                               style: const TextStyle(color: Colors.white)),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 if (_selectedSkills.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Your Selected Skills:",
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: _selectedSkills.map((skill) {
//                           return Chip(
//                             backgroundColor: Colors.blue.shade200,
//                             label: Text(skill),
//                             onDeleted: () {
//                               setState(() {
//                                 _selectedSkills.remove(skill);
//                               });
//                             },
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//
//                 const SizedBox(height: 100),
//
//                 // Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 30, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text(
//                         "Back",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16),
//                       ),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 30, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8)),
//                       ),
//                       onPressed: () {
//                         if (_selectedSkills.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                                 content: Text("Please add at least one skill")),
//                           );
//                           return;
//                         }
//
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => HomeScreen(
//                               // yahan tumhare HomeScreen ko data mil jayega
//                               title: widget.title,
//                               image: widget.image,
//                               fullName: widget.fullName,
//                               gender: widget.gender,
//                               education: widget.education,
//                               workExperience: widget.workExperience,
//                               salary: widget.salary,
//                               imageFile: widget.imageFile,
//                               skills: _selectedSkills, // 👈 yeh bhej raha hoon
//                             ),
//                           ),
//                         );
//
//                         print("Selected Skills: $_selectedSkills");
//                       },
//                       child: const Text(
//                         "Next",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16),
//                       ),
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//





// received data previous page

// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:thenaukrimitra/Home_screens/home_screen.dart';
//
//
// class FresherScreen extends StatefulWidget {
//   final String title;
//   final String image;
//   final String fullName;
//   final String gender;
//   final String education;
//   final String workExperience;
//   final String salary;
//   final File imageFile;
//
//   const FresherScreen({super.key, required this.title, required this.image,
//     required this.fullName,
//     required this.gender,
//     required this.education,
//     required this.workExperience,
//     required this.salary,
//     required this.imageFile,
//
//   });
//
//   @override
//   State<FresherScreen> createState() => _FresherScreenState();
// }
//
// class _FresherScreenState extends State<FresherScreen> {
//   final TextEditingController _skillController = TextEditingController();
//   final List<String> _availableSkills = [
//     'AutoCad',
//     'Photoshop',
//     'Corel Draw',
//     'Animation',
//     'Video Editing',
//     'UI_UX'
//   ];
//   final List<String> _selectedSkills = [];
//
//   void _addSkill(String skill) {
//     if (!_selectedSkills.contains(skill)) {
//       setState(() {
//         _selectedSkills.add(skill);
//       });
//     }
//     _skillController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEFEFF6),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Back Button
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.blue),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//
//                 // Profile Card with image and title
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.asset(
//                           widget.image,
//                           width: 60,
//                           height: 60,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           widget.title,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // Skills input
//                 const Text("Skills", style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 6),
//                 Container(
//                   width: double.infinity,
//                   height: 50,
//                   child: TextField(
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       focusColor: Colors.white,
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.white, width: 2.0),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       border: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.white, width: 2.0),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.white, width: 2.0),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       hintText: 'Add Your Skills',
//                       hintStyle: const TextStyle(color: Colors.grey),
//                       suffixIcon: Padding(
//                         padding: const EdgeInsets.only(right: 15.0),
//                         child: Icon(Icons.search),
//                       ),
//                     ),
//                   ),
//                 ),
//
//
//                 const SizedBox(height: 20),
//                 const Text("Select your skills", style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//
//                 // Skill Chips
//                 Center(
//                   child: Wrap(
//                     spacing: 20,
//                     runSpacing: 10,
//                     children: _availableSkills.map((skill) {
//                       return GestureDetector(
//                         onTap: () => _addSkill(skill),
//                         child: Chip(
//                           backgroundColor: Colors.orange.shade300,
//                           label: Text(skill, style: const TextStyle(color: Colors.white)),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//
//                 if (_selectedSkills.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Your Selected Skills:",
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: _selectedSkills.map((skill) {
//                           return Chip(
//                             backgroundColor: Colors.blue.shade200,
//                             label: Text(skill),
//                             onDeleted: () {
//                               setState(() {
//                                 _selectedSkills.remove(skill);
//                               });
//                             },
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//
//                SizedBox(height: 300,),
//
//                 // Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text("Back",
//                         style: TextStyle(color: Colors.white,
//                             fontWeight: FontWeight.bold,fontSize: 16),),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8)
//                         )
//                       ),
//                       onPressed: () {
//                         Navigator.push(context,
//                             MaterialPageRoute(builder: (context)=>HomeScreen(
//                             )));
//
//                         print("Selected Skills: $_selectedSkills");
//                       },
//                       child: const Text("Next",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
//                     ),)
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





// import 'package:flutter/material.dart';
// import 'package:thenaukrimitra/Home_screens/home_screen.dart';
//
// import '../main_Screen/main_screen.dart';
//
//
// class FresherScreen extends StatefulWidget {
//   final String title;
//   final String image;
//
//   const FresherScreen({super.key, required this.title, required this.image});
//
//   @override
//   State<FresherScreen> createState() => _FresherScreenState();
// }
//
// class _FresherScreenState extends State<FresherScreen> {
//   final TextEditingController _skillController = TextEditingController();
//   final List<String> _availableSkills = [
//     'AutoCad',
//     'Photoshop',
//     'Corel Draw',
//     'Animation',
//     'Video Editing',
//     'UI_UX'
//   ];
//   final List<String> _selectedSkills = [];
//
//   void _addSkill(String skill) {
//     if (!_selectedSkills.contains(skill)) {
//       setState(() {
//         _selectedSkills.add(skill);
//       });
//     }
//     _skillController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFEFEFF6),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Back Button
//                 IconButton(
//                   icon: const Icon(Icons.arrow_back, color: Colors.blue),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//
//                 // Profile Card with image and title
//                 Container(
//                   margin: const EdgeInsets.symmetric(vertical: 10),
//                   padding: const EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         blurRadius: 5,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8),
//                         child: Image.asset(
//                           widget.image,
//                           width: 60,
//                           height: 60,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(width: 10),
//                       Expanded(
//                         child: Text(
//                           widget.title,
//                           style: const TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 // Skills input
//                 const Text("Skills", style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 6),
//                 Container(
//                   width: double.infinity,
//                   height: 50,
//                   child: TextField(
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.white,
//                       focusColor: Colors.white,
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.white, width: 2.0),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       border: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.white, width: 2.0),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: const BorderSide(color: Colors.white, width: 2.0),
//                         borderRadius: BorderRadius.circular(30),
//                       ),
//                       hintText: 'Add Your Skills',
//                       hintStyle: const TextStyle(color: Colors.grey),
//                       suffixIcon: Padding(
//                         padding: const EdgeInsets.only(right: 15.0),
//                         child: Icon(Icons.search),
//                       ),
//                     ),
//                   ),
//                 ),
//
//
//                 const SizedBox(height: 20),
//                 const Text("Select your skills", style: TextStyle(fontWeight: FontWeight.bold)),
//                 const SizedBox(height: 10),
//
//                 // Skill Chips
//                 Center(
//                   child: Wrap(
//                     spacing: 20,
//                     runSpacing: 10,
//                     children: _availableSkills.map((skill) {
//                       return GestureDetector(
//                         onTap: () => _addSkill(skill),
//                         child: Chip(
//                           backgroundColor: Colors.orange.shade300,
//                           label: Text(skill, style: const TextStyle(color: Colors.white)),
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//
//                 if (_selectedSkills.isNotEmpty)
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text("Your Selected Skills:",
//                           style: TextStyle(fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 8),
//                       Wrap(
//                         spacing: 8,
//                         runSpacing: 8,
//                         children: _selectedSkills.map((skill) {
//                           return Chip(
//                             backgroundColor: Colors.blue.shade200,
//                             label: Text(skill),
//                             onDeleted: () {
//                               setState(() {
//                                 _selectedSkills.remove(skill);
//                               });
//                             },
//                           );
//                         }).toList(),
//                       ),
//                     ],
//                   ),
//
//                 SizedBox(height: 300,),
//
//                 // Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       onPressed: () => Navigator.pop(context),
//                       child: const Text("Back",
//                         style: TextStyle(color: Colors.white,
//                             fontWeight: FontWeight.bold,fontSize: 16),),
//                     ),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.blue,
//                           padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8)
//                           )
//                       ),
//                       onPressed: () {
//                         Navigator.pushReplacement(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => const MainScreen(initialIndex: 0), // 👈 Home tab
//                           ),
//                         );
//
//
//                         print("Selected Skills: $_selectedSkills");
//                       },
//                       child: const Text("Next",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
//                       ),)
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
