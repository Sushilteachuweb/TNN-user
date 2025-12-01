// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/CreateProfileProvider.dart';
// import '../main_Screen/main_screen.dart';
// import '../Screens/fresher_screen.dart';
//
// class JobCate1 extends StatefulWidget {
//   final String title;
//   final String image;
//   final String fullName;
//   final String gender;
//   final String education;
//   final String workExperience;
//   final File imageFile;
//   final String phone;
//   final String email;
//
//
//   const JobCate1({
//     super.key,
//     required this.phone,
//     required this.title,
//     required this.image,
//     required this.fullName,
//     required this.gender,
//     required this.education,
//     required this.workExperience,
//     required this.imageFile,
//
//     required this.email,
//   });
//
//   @override
//   State<JobCate1> createState() => _JobCate1State();
// }
//
// class _JobCate1State extends State<JobCate1> {
//   bool isExperienced = true;
//   String? selectedExperience;
//   final TextEditingController salaryController = TextEditingController();
//
//   final List<String> experienceOptions = [
//     "6 months",
//     "1 year",
//     "2 years",
//     "3 years",
//     "5+ years",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CreateProfileProvider>(context);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6FE),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(Icons.arrow_back, color: Colors.blue),
//               ),
//               const SizedBox(height: 10),
//               _buildJobCard(),
//               const SizedBox(height: 10),
//               if (isExperienced) _buildExperienceFields(),
//               const Spacer(),
//               if (isExperienced) _buildBottomButtons(provider),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildJobCard() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.15),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.asset(
//                   widget.image,
//                   width: 60,
//                   height: 60,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(widget.title,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.w500, fontSize: 16)),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildToggleButton("I'm Experienced", isExperienced, () {
//                 setState(() => isExperienced = true);
//               }),
//               _buildToggleButton("I'm a fresher", !isExperienced, () {
//                 setState(() => isExperienced = false);
//
//                 // Fresher flow: turant FresherScreen
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => FresherScreen(
//                       title: widget.title,
//                       image: widget.image,
//                       fullName: widget.fullName,
//                       gender: widget.gender,
//                       education: widget.education,
//                       workExperience: "Fresher",
//                       salary: "0",
//                       imageFile: widget.imageFile,
//                     ),
//                   ),
//                 );
//               }),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.orange : Colors.orange[100],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.orange,
//             fontWeight: FontWeight.w600,
//             fontSize: 12,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildExperienceFields() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             gradient: const LinearGradient(
//               colors: [Color(0xFFDAE2F8), Color(0xFFD6A4A4)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: DropdownButtonFormField<String>(
//             value: selectedExperience,
//             hint: const Text("Select Experience"),
//             isExpanded: true,
//             decoration: const InputDecoration(border: InputBorder.none),
//             items: experienceOptions.map((exp) {
//               return DropdownMenuItem(
//                 value: exp,
//                 child: Text(exp),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedExperience = value;
//               });
//             },
//           ),
//         ),
//         const SizedBox(height: 12),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             gradient: const LinearGradient(
//               colors: [Color(0xFFDAE2F8), Color(0xFFD6A4A4)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: TextField(
//             controller: salaryController,
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(
//               hintText: 'Current Salary',
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildBottomButtons(CreateProfileProvider provider) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//       children: [
//         ElevatedButton(
//           onPressed: () => Navigator.pop(context),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue,
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//           child: const Text('Back',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold)),
//         ),
//         ElevatedButton(
//           onPressed: provider.isLoading ? null : _saveExperienceAndNext,
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blue,
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//             shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//           ),
//           child: provider.isLoading
//               ? const CircularProgressIndicator(color: Colors.white)
//               : const Text('Next',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold)),
//         ),
//       ],
//     );
//   }
//
//   // 🔹 Save experience + salary to server
//   Future<void> _saveExperienceAndNext() async {
//     if (selectedExperience == null || salaryController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please complete all fields')),
//       );
//       return;
//     }
//
//     final provider = Provider.of<CreateProfileProvider>(context, listen: false);
//
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(child: CircularProgressIndicator()),
//     );
//
//     final result = await provider.saveProfile(
//       context,
//       fullName: widget.fullName,
//       phone: "",
//       // phone: widget.phone, // Replace with actual phone if available
//       gender: widget.gender,
//       education: widget.education,
//       isExperienced: true,
//       totalExperience: _experienceToInt(selectedExperience!),
//       currentSalary: int.parse(salaryController.text),
//       email: "email@example.com", // Replace with actual email if available
//       skills: "", // Skills add karenge FresherScreen me
//       jobCategory: "",
//       image: widget.imageFile,
//     );
//
//     Navigator.pop(context); // close loader
//
//     if (result['success'] == true) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Experience saved successfully")),
//       );
//
//       // Navigate to FresherScreen / Skills / MainScreen
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) => MainScreen(
//             title: widget.title,
//             image: widget.image,
//             fullName: widget.fullName,
//             gender: widget.gender,
//             education: widget.education,
//             workExperience: selectedExperience!,
//             salary: salaryController.text,
//             imageFile: widget.imageFile,
//             skills: [], // FresherScreen ya next screen me set karenge
//           ),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text(result['message'] ?? "Failed to save")),
//       );
//     }
//   }
//
//   int _experienceToInt(String exp) {
//     switch (exp) {
//       case "6 months":
//         return 0;
//       case "1 year":
//         return 1;
//       case "2 years":
//         return 2;
//       case "3 years":
//         return 3;
//       case "5+ years":
//         return 5;
//       default:
//         return 0;
//     }
//   }
// }
//




//Without save expereince and current salary
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:thenaukrimitra/Home_screens/home_screen.dart';
import 'package:thenaukrimitra/Screens/fresher_screen.dart';
import 'package:thenaukrimitra/main_Screen/main_screen.dart';

class JobCate1 extends StatefulWidget {
  final String title;
  final String image;
  final String fullName;
  final String gender;
  final String education;
  final String workExperience;

  final File imageFile;

  const JobCate1({
    super.key,
    required this.title,
    required this.image,
    required this.fullName,
    required this.gender,
    required this.education,
    required this.workExperience,
    required this.imageFile,
  });

  @override
  State<JobCate1> createState() => _JobCate1State();
}

class _JobCate1State extends State<JobCate1> {
  bool isExperienced = true;
  String? selectedExperience;
  final TextEditingController salaryController = TextEditingController();

  final List<String> experienceOptions = [
    "6 months",
    "1 year",
    "2 years",
    "3 years",
    "5+ years",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.blue),
              ),
              const SizedBox(height: 10),

              // Job Card
              _buildJobCard(),

              const SizedBox(height: 10),
              if (isExperienced) _buildExperienceFields(),

              const Spacer(),


              if (isExperienced)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Back',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedExperience == null ||
                            salaryController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please complete all fields'),
                            ),
                          );
                          return;
                        }
                        // 👉 experienced flow
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MainScreen(
                              // yahan pe apna data bhejna hai
                              title: widget.title,
                              image: widget.image,
                              fullName: widget.fullName,
                              gender: widget.gender,
                              education: widget.education,
                              workExperience: selectedExperience!,
                              salary: salaryController.text,
                              imageFile: widget.imageFile, skills: [""],
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Next',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ],
                )
               ],
          ),
        ),
      ),
    );
  }

  Widget _buildJobCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
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
              const SizedBox(width: 12),
              Text(widget.title,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildToggleButton("I'm Experienced", isExperienced, () {
                setState(() => isExperienced = true);
              }),
              _buildToggleButton("I'm a fresher", !isExperienced, () {
                setState(() {
                  isExperienced = false;
                });

                // 👉 Fresher flow turant yahan navigate karega
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FresherScreen(
                      title: widget.title,
                      image: widget.image,
                      fullName: widget.fullName,
                      gender: widget.gender,
                      education: widget.education,
                      workExperience: "Fresher",
                      salary: "0",
                      imageFile: widget.imageFile,
                    ),
                  ),
                );
              }),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildToggleButton(
      String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.orange : Colors.orange[100],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.orange,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
        ),
      ),
    );
  }

  Widget _buildExperienceFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),

        // Experience Dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Color(0xFFDAE2F8), Color(0xFFD6A4A4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: DropdownButtonFormField<String>(
            value: selectedExperience,
            hint: const Text("Select Experience"),
            isExpanded: true,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
            items: experienceOptions.map((exp) {
              return DropdownMenuItem(
                value: exp,
                child: Text(exp),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedExperience = value;
              });
            },
          ),
        ),
        const SizedBox(height: 12),

        // Salary Input
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Color(0xFFDAE2F8), Color(0xFFD6A4A4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: TextField(
            controller: salaryController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              hintText: 'Current Salary',
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}










// without data send

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:thenaukrimitra/Screens/fresher_screen.dart';
//
// class JobCate1 extends StatefulWidget {
//   final String title;
//   final String image;
//   final String fullName;
//   final String gender;
//   final String education;
//   final String workExperience;
//   final File imageFile;
//
//   const JobCate1({super.key,
//     required this.title, required this.image,
//     required this.fullName,
//     required this.gender,
//     required this.education,
//     required this.workExperience,
//     required this.imageFile,
//   });
//
//   @override
//   State<JobCate1> createState() => _JobCate1State();
// }
//
// class _JobCate1State extends State<JobCate1> {
//   bool isExperienced = true;
//   String? selectedExperience;
//   final TextEditingController salaryController = TextEditingController();
//
//   final List<String> experienceOptions = [
//     "6 months",
//     "1 year",
//     "2 years",
//     "3 years",
//     "5+ years",
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6FE),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Back Button
//               IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(Icons.arrow_back, color: Colors.blue),
//               ),
//               const SizedBox(height: 10),
//
//               // Job Card
//               _buildJobCard(),
//
//               const SizedBox(height: 10),
//
//               // Experience Fields
//               if (isExperienced) _buildExperienceFields(),
//
//               const Spacer(),
//
//               // Bottom Buttons
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 30),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text('Back',
//                         style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
//                   ),
//                   ElevatedButton(
//                     onPressed: () {
//                       if (isExperienced) {
//                         if (selectedExperience == null ||
//                             salaryController.text.isEmpty) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('Please complete all fields'),
//                             ),
//                           );
//                           return;
//                         }
//                         // Proceed with experienced details
//                         print("Experience: $selectedExperience");
//                         print("Salary: ${salaryController.text}");
//                       } else {
//                         // Proceed with fresher flow
//                         print("Fresher selected");
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 12, horizontal: 30),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                     ),
//                     child: const Text('Next',
//                         style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold)),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildJobCard() {
//     return Container(
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.15),
//             blurRadius: 6,
//             offset: const Offset(0, 3),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               ClipRRect(
//                 borderRadius: BorderRadius.circular(8),
//                 child: Image.asset(
//                   widget.image,
//                   width: 60,
//                   height: 60,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(widget.title,
//                   style: const TextStyle(
//                       fontWeight: FontWeight.w500, fontSize: 16)),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               _buildToggleButton("I'm Experienced", isExperienced, () {
//                 setState(() => isExperienced = true);
//               }),
//               _buildToggleButton("I'm a fresher", !isExperienced, () {
//                 setState(() {
//                   isExperienced = false;
//                 });
//
//                 // Navigate only if toggled to fresher
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => FresherScreen(
//                       title: widget.title,
//                       image: widget.image,
//                     ),
//                   ),
//                 );
//               }),
//             ],
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget _buildToggleButton(
//       String text, bool isSelected, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.orange : Colors.orange[100],
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: isSelected ? Colors.white : Colors.orange,
//             fontWeight: FontWeight.w600,
//             fontSize: 12,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildExperienceFields() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//
//         // Experience Dropdown
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             gradient: const LinearGradient(
//               colors: [Color(0xFFDAE2F8), Color(0xFFD6A4A4)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: DropdownButtonFormField<String>(
//             value: selectedExperience,
//             hint: const Text("Select Experience"),
//             isExpanded: true,
//             decoration: const InputDecoration(
//               border: InputBorder.none,
//             ),
//             items: experienceOptions.map((exp) {
//               return DropdownMenuItem(
//                 value: exp,
//                 child: Text(exp),
//               );
//             }).toList(),
//             onChanged: (value) {
//               setState(() {
//                 selectedExperience = value;
//               });
//             },
//           ),
//         ),
//         const SizedBox(height: 12),
//
//         // Salary Input
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             gradient: const LinearGradient(
//               colors: [Color(0xFFDAE2F8), Color(0xFFD6A4A4)],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//           child: TextField(
//             controller: salaryController,
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(
//               hintText: 'Current Salary',
//               border: InputBorder.none,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
//
