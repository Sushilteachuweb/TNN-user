import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:thenaukrimitra/Screens/job_categories.dart';
import '../provider/CreateProfileProvider.dart';


class CreateProfile extends StatefulWidget {
  final String phone;
  const CreateProfile({
    super.key,
    required this.phone,
  });
  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? selectedGender;
  String? selectedEducation;
  String? selectedExperience;
  File? selectedImage;

  final ImagePicker picker = ImagePicker();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // 📸 Image Picker with permission
  Future<void> _pickImage(ImageSource source) async {
    if (source == ImageSource.camera) {
      var cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Camera permission denied")),
        );
        return;
      }
    } else {
      var storageStatus = await Permission.photos.request();
      if (!storageStatus.isGranted) {
        var androidStatus = await Permission.storage.request();
        if (!androidStatus.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Storage permission denied")),
          );
          return;
        }
      }
    }

    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
    if (mounted) Navigator.pop(context);
  }

  // 📸 BottomSheet to choose Camera/Gallery
  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Choose Profile Photo",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo),
                    label: const Text("Gallery"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔹 Reusable Option Selector
  Widget _buildOptions({
    required String title,
    required List<String> options,
    required String? selectedValue,
    required Function(String) onSelected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return InkWell(
              onTap: () => onSelected(option),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.blue : Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  option,
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CreateProfileProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(236, 236, 245, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.blue)),
              const SizedBox(height: 15),

              const Center(
                child: Text(
                  'Introduce yourself in three easy steps.',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 📸 Profile Photo
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage:
                      selectedImage != null ? FileImage(selectedImage!) : null,
                      child: selectedImage == null
                          ? const Icon(Icons.person,
                          size: 60, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 12),
                    InkWell(
                      onTap: _showImagePickerSheet,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.camera_alt,
                              color: Colors.blue, size: 20),
                          SizedBox(width: 5),
                          Text(
                            "Add Photo",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),
              const Text("Full Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 5),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              const Text("Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 5),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "example@email.com",
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              // 🚻 Gender
              _buildOptions(
                title: "Gender",
                options: ["Male", "Female", "Other"],
                selectedValue: selectedGender,
                onSelected: (val) => setState(() => selectedGender = val),
              ),
              _buildOptions(
                title: "Work Experience",
                options: ["I am a fresher", "I have experience"],
                selectedValue: selectedExperience,
                onSelected: (val) => setState(() => selectedExperience = val),
              ),
              _buildOptions(
                title: "Education",
                options: [
                  "10th Pass",
                  "12th Pass",
                  "Diploma",
                  "Graduate",
                  "Post Graduate"
                ],
                selectedValue: selectedEducation,
                onSelected: (val) => setState(() => selectedEducation = val),
              ),

              const SizedBox(height: 40),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: provider.isLoading
                        ? null
                        : () async {
                      // ✅ Validate email format
                      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      
                      if (nameController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("⚠️ Please enter your full name")),
                        );
                        return;
                      }
                      
                      if (emailController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("⚠️ Please enter your email")),
                        );
                        return;
                      }
                      
                      if (!emailRegex.hasMatch(emailController.text.trim())) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("⚠️ Please enter a valid email address")),
                        );
                        return;
                      }
                      
                      if (nameController.text.isNotEmpty &&
                          emailController.text.isNotEmpty &&
                          selectedGender != null &&
                          selectedEducation != null &&
                          selectedExperience != null &&
                          selectedImage != null) {
                        final boolExp = selectedExperience == "I have experience";


                        final result = await provider.saveProfile(
                          context,
                          fullName: nameController.text.trim(),
                          gender: selectedGender!,
                          education: selectedEducation!,
                          isExperienced: boolExp,
                          currentSalary: 50000,
                          email: emailController.text.trim(),
                          totalExperience: 2,
                          jobCategory: "Software",
                          skills: "Flutter",
                          image: selectedImage,
                          phone: widget.phone,
                        );

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(result['message'] ?? 'No message')),
                          );
                        }

                        if (result['success'] == true) {
                          if (mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobCategories(

                                  fullName: nameController.text,
                                  gender: selectedGender!,
                                  education: selectedEducation!,
                                  workExperience: selectedExperience!,
                                  imageFile: selectedImage!,

                                  skills: [],
                                ),
                              ),
                            );
                          }
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("⚠️ Please complete all fields")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Next",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold)),
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





// 29-09-2025

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:thenaukrimitra/Screens/job_categories.dart';
// import '../provider/CreateProfileProvider.dart';
//
//
// class CreateProfile extends StatefulWidget {
//   final String phone;
//   const CreateProfile({
//     super.key,
//     required this.phone,
//   });
//   @override
//   State<CreateProfile> createState() => _CreateProfileState();
// }
//
// class _CreateProfileState extends State<CreateProfile> {
//   final TextEditingController nameController = TextEditingController();
//   String? selectedGender;
//   String? selectedEducation;
//   String? selectedExperience;
//   File? selectedImage;
//
//   final ImagePicker picker = ImagePicker();
//
//   // 📸 Image Picker with permission
//   Future<void> _pickImage(ImageSource source) async {
//     if (source == ImageSource.camera) {
//       var cameraStatus = await Permission.camera.request();
//       if (!cameraStatus.isGranted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Camera permission denied")),
//         );
//         return;
//       }
//     } else {
//       var storageStatus = await Permission.photos.request();
//       if (!storageStatus.isGranted) {
//         var androidStatus = await Permission.storage.request();
//         if (!androidStatus.isGranted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Storage permission denied")),
//           );
//           return;
//         }
//       }
//     }
//
//     final XFile? image = await picker.pickImage(source: source);
//     if (image != null) {
//       setState(() {
//         selectedImage = File(image.path);
//       });
//     }
//     if (mounted) Navigator.pop(context);
//   }
//
//   // 📸 BottomSheet to choose Camera/Gallery
//   void _showImagePickerSheet() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text("Choose Profile Photo",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.camera),
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text("Camera"),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.gallery),
//                     icon: const Icon(Icons.photo),
//                     label: const Text("Gallery"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // 🔹 Reusable Option Selector
//   Widget _buildOptions({
//     required String title,
//     required List<String> options,
//     required String? selectedValue,
//     required Function(String) onSelected,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//         Text(title,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: options.map((option) {
//             final isSelected = selectedValue == option;
//             return InkWell(
//               onTap: () => onSelected(option),
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.blue : Colors.orange,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   option,
//                   style: const TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CreateProfileProvider>(context);
//
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(236, 236, 245, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),
//               InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: const Icon(Icons.arrow_back, color: Colors.blue)),
//               const SizedBox(height: 15),
//
//               const Center(
//                 child: Text(
//                   'Introduce yourself in three easy steps.',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25),
//
//               // 📸 Profile Photo
//               Center(
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage:
//                       selectedImage != null ? FileImage(selectedImage!) : null,
//                       child: selectedImage == null
//                           ? const Icon(Icons.person,
//                           size: 60, color: Colors.white)
//                           : null,
//                     ),
//                     const SizedBox(height: 12),
//                     InkWell(
//                       onTap: _showImagePickerSheet,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(Icons.camera_alt,
//                               color: Colors.blue, size: 20),
//                           SizedBox(width: 5),
//                           Text(
//                             "Add Photo",
//                             style: TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//               const Text("Full Name",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               const SizedBox(height: 5),
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//
//               // 🚻 Gender
//               _buildOptions(
//                 title: "Gender",
//                 options: ["Male", "Female", "Other"],
//                 selectedValue: selectedGender,
//                 onSelected: (val) => setState(() => selectedGender = val),
//               ),
//               _buildOptions(
//                 title: "Work Experience",
//                 options: ["I am a fresher", "I have experience"],
//                 selectedValue: selectedExperience,
//                 onSelected: (val) => setState(() => selectedExperience = val),
//               ),
//               _buildOptions(
//                 title: "Education",
//                 options: [
//                   "10th Pass",
//                   "12th Pass",
//                   "Diploma",
//                   "Graduate",
//                   "Post Graduate"
//                 ],
//                 selectedValue: selectedEducation,
//                 onSelected: (val) => setState(() => selectedEducation = val),
//               ),
//
//               const SizedBox(height: 40),
//               Center(
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: provider.isLoading
//                         ? null
//                         : () async {
//                       if (nameController.text.isNotEmpty &&
//                           selectedGender != null &&
//                           selectedEducation != null &&
//                           selectedExperience != null &&
//                           selectedImage != null) {
//                         final boolExp = selectedExperience == "I have experience";
//
//
//                         final result = await provider.saveProfile(
//                           context,
//                           fullName: nameController.text,
//                           gender: selectedGender!,
//                           education: selectedEducation!,
//                           isExperienced: boolExp,
//                           currentSalary: 50000,
//                           email: "Ali@gmail.com",
//                           totalExperience: 2,
//                           jobCategory: "Software",
//                           skills: "Flutter",
//                           image: selectedImage,
//                           phone: widget.phone,
//                         );
//
//                         if (mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(result['message'] ?? 'No message')),
//                           );
//                         }
//
//                         if (result['success'] == true) {
//                           if (mounted) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => JobCategories(
//
//                                   fullName: nameController.text,
//                                   gender: selectedGender!,
//                                   education: selectedEducation!,
//                                   workExperience: selectedExperience!,
//                                   imageFile: selectedImage!,
//
//                                   skills: [],
//                                 ),
//                               ),
//                             );
//                           }
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("⚠️ Please complete all fields")),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8))),
//                     child: provider.isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text("Next",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//













//
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:thenaukrimitra/Screens/job_categories.dart';
//
// import '../provider/CreateProfileProvider.dart';
// class CreateProfile extends StatefulWidget {
//   final phone;
//   const CreateProfile({super.key,
//   required this.phone,
//   });
//
//   @override
//   State<CreateProfile> createState() => _CreateProfileState();
// }
//
// class _CreateProfileState extends State<CreateProfile> {
//   final TextEditingController nameController = TextEditingController();
//   String? selectedGender;
//   String? selectedEducation;
//   String? selectedExperience;
//   File? selectedImage;
//
//   final ImagePicker picker = ImagePicker();
//
//   // 📸 Image Picker with permission
//   Future<void> _pickImage(ImageSource source) async {
//     if (source == ImageSource.camera) {
//       var cameraStatus = await Permission.camera.request();
//       if (!cameraStatus.isGranted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Camera permission denied")),
//         );
//         return;
//       }
//     } else {
//       var storageStatus = await Permission.photos.request(); // iOS ke liye
//       if (!storageStatus.isGranted) {
//         var androidStatus = await Permission.storage.request(); // Android ke liye
//         if (!androidStatus.isGranted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Storage permission denied")),
//           );
//           return;
//         }
//       }
//     }
//
//     final XFile? image = await picker.pickImage(source: source);
//     if (image != null) {
//       setState(() {
//         selectedImage = File(image.path);
//       });
//     }
//     if (mounted) Navigator.pop(context); // bottom sheet band
//   }
//
//   // 📸 BottomSheet to choose Camera/Gallery
//   void _showImagePickerSheet() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text("Choose Profile Photo",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.camera),
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text("Camera"),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.gallery),
//                     icon: const Icon(Icons.photo),
//                     label: const Text("Gallery"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // 🔹 Reusable Option Selector
//   Widget _buildOptions({
//     required String title,
//     required List<String> options,
//     required String? selectedValue,
//     required Function(String) onSelected,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//         Text(title,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: options.map((option) {
//             final isSelected = selectedValue == option;
//             return InkWell(
//               onTap: () => onSelected(option),
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.blue : Colors.orange,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   option,
//                   style: const TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<CreateProfileProvider>(context);
//
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(236, 236, 245, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔙 Back Button
//               const SizedBox(height: 10),
//               InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: const Icon(Icons.arrow_back, color: Colors.blue)),
//               const SizedBox(height: 15),
//
//               const Center(
//                 child: Text(
//                   'Introduce yourself in three easy steps.',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25),
//
//               // 📸 Profile Photo
//               Center(
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage:
//                       selectedImage != null ? FileImage(selectedImage!) : null,
//                       child: selectedImage == null
//                           ? const Icon(Icons.person,
//                           size: 60, color: Colors.white)
//                           : null,
//                     ),
//                     const SizedBox(height: 12),
//                     InkWell(
//                       onTap: _showImagePickerSheet,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(Icons.camera_alt,
//                               color: Colors.blue, size: 20),
//                           SizedBox(width: 5),
//                           Text(
//                             "Add Photo",
//                             style: TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//               const Text("Full Name",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               const SizedBox(height: 5),
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//
//               // 🚻 Gender
//               _buildOptions(
//                 title: "Gender",
//                 options: ["Male", "Female", "Other"],
//                 selectedValue: selectedGender,
//                 onSelected: (val) => setState(() => selectedGender = val),
//               ),
//               _buildOptions(
//                 title: "Work Experience",
//                 options: ["I am a fresher", "I have experience"],
//                 selectedValue: selectedExperience,
//                 onSelected: (val) => setState(() => selectedExperience = val),
//               ),
//               _buildOptions(
//                 title: "Education",
//                 options: [
//                   "10th Pass",
//                   "12th Pass",
//                   "Diploma",
//                   "Graduate",
//                   "Post Graduate"
//                 ],
//                 selectedValue: selectedEducation,
//                 onSelected: (val) => setState(() => selectedEducation = val),
//               ),
//
//               const SizedBox(height: 40),
//               Center(
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: provider.isLoading
//                         ? null
//                         : () async {
//                       // validation same as before
//                       if (nameController.text.isNotEmpty &&
//                           selectedGender != null &&
//                           selectedEducation != null &&
//                           selectedExperience != null &&
//                           selectedImage != null) {
//                         // call provider to save
//                         final boolExp =
//                             selectedExperience == "I have experience";
//                         final result = await provider.saveProfile(
//                           fullName: nameController.text,
//                           gender: selectedGender!,
//                           education: selectedEducation!,
//                           isExperienced: boolExp,
//                           image: selectedImage,
//                         );
//
//                         // Show response message
//                         final msg = result['message'] ?? 'No message';
//                         final success = result['success'] == true;
//
//                         if (mounted) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(msg)),
//                           );
//                         }
//
//                         if (success) {
//                           // Navigate to JobCategories passing current screen data (same as you had)
//                           if (mounted) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => JobCategories(
//                                   fullName: nameController.text,
//                                   gender: selectedGender!,
//                                   education: selectedEducation!,
//                                   workExperience: selectedExperience!,
//                                   imageFile: selectedImage!, skills: [],
//                                 ),
//                               ),
//                             );
//                           }
//                         } else {
//
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text("⚠️ Please complete all fields")),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8))),
//                     child: provider.isLoading
//                         ? const CircularProgressIndicator(color: Colors.white)
//                         : const Text("Next",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//












// Toaday correct code 01-09-2025
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:thenaukrimitra/Screens/job_categories.dart';
// import '../main_Screen/main_screen.dart';
// import '../provider/create_provider.dart';
//
// class CreateProfile extends StatefulWidget {
//   final String phone;
//   const CreateProfile({
//     super.key,
//     required this.phone
//   });
//
//   @override
//   State<CreateProfile> createState() => _CreateProfileState();
// }
//
// class _CreateProfileState extends State<CreateProfile> {
//   final TextEditingController nameController = TextEditingController();
//   String? selectedGender;
//   String? selectedEducation;
//   String? selectedExperience;
//   File? selectedImage;
//
//   final ImagePicker picker = ImagePicker();
//   // 📸 Image Picker with permission
//   Future<void> _pickImage(ImageSource source) async {
//     if (source == ImageSource.camera) {
//       var cameraStatus = await Permission.camera.request();
//       if (!cameraStatus.isGranted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Camera permission denied")),
//         );
//         return;
//       }
//     } else {
//       var storageStatus = await Permission.photos.request(); // iOS
//       if (!storageStatus.isGranted) {
//         var androidStatus = await Permission.storage.request(); // Android
//         if (!androidStatus.isGranted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Storage permission denied")),
//           );
//           return;
//         }
//       }
//     }
//
//     final XFile? image = await picker.pickImage(source: source);
//     if (image != null) {
//       setState(() {
//         selectedImage = File(image.path);
//       });
//     }
//     if (mounted) Navigator.pop(context); // bottom sheet band
//   }
//
//   // 📸 BottomSheet to choose Camera/Gallery
//   void _showImagePickerSheet() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text("Choose Profile Photo",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.camera),
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text("Camera"),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.gallery),
//                     icon: const Icon(Icons.photo),
//                     label: const Text("Gallery"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // 🔹 Reusable Option Selector Widget
//   Widget _buildOptions({
//     required String title,
//     required List<String> options,
//     required String? selectedValue,
//     required Function(String) onSelected,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//         Text(title,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: options.map((option) {
//             final isSelected = selectedValue == option;
//             return InkWell(
//               onTap: () => onSelected(option),
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.blue : Colors.orange,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   option,
//                   style: const TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(236, 236, 245, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔙 Back Button
//               const SizedBox(height: 10),
//               InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: const Icon(Icons.arrow_back, color: Colors.blue)),
//               const SizedBox(height: 15),
//
//               const Center(
//                 child: Text(
//                   'Introduce yourself in three easy steps.',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               // 📸 Profile Photo
//               Center(
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage: selectedImage != null
//                           ? FileImage(selectedImage!)
//                           : null,
//                       child: selectedImage == null
//                           ? const Icon(Icons.person,
//                           size: 60, color: Colors.white)
//                           : null,
//                     ),
//                     const SizedBox(height: 12),
//                     InkWell(
//                       onTap: _showImagePickerSheet,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(Icons.camera_alt,
//                               color: Colors.blue, size: 20),
//                           SizedBox(width: 5),
//                           Text(
//                             "Add Photo",
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               const Text("Full Name",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               const SizedBox(height: 5),
//
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//
//               // 🚻 Gender
//               _buildOptions(
//                 title: "Gender",
//                 options: ["Male", "Female", "Other"],
//                 selectedValue: selectedGender,
//                 onSelected: (val) => setState(() => selectedGender = val),
//               ),
//
//               // 🧑‍💼 Experience
//               _buildOptions(
//                 title: "Work Experience",
//                 options: ["I am a fresher", "I have experience"],
//                 selectedValue: selectedExperience,
//                 onSelected: (val) => setState(() => selectedExperience = val),
//               ),
//
//               // 🎓 Education
//               _buildOptions(
//                 title: "Education",
//                 options: [
//                   "10th Pass",
//                   "12th Pass",
//                   "Diploma",
//                   "Graduate",
//                   "Post Graduate"
//                 ],
//                 selectedValue: selectedEducation,
//                 onSelected: (val) => setState(() => selectedEducation = val),
//               ),
//               const SizedBox(height: 40),
//               Center(
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (nameController.text.isNotEmpty &&
//                           selectedGender != null &&
//                           selectedEducation != null &&
//                           selectedExperience != null) {
//
//                         final provider = Provider.of<CreateProvider>(context, listen: false);
//
//                         final bool success = await provider.createUserProfile(
//                           fullName: nameController.text,
//                           phone: widget.phone,
//                           gender: (selectedGender ?? "male").toLowerCase(),
//                           education: selectedEducation!,
//                           jobCategory: "fresher",
//                           skills: "python",
//                           isExperienced: selectedExperience == "I have experience",
//                           totalExperience: "4",
//                           currentSalary: "50000",
//                           email: "divya@gmail.com",
//                           imageFile: selectedImage,
//                         );
//
//                         if (success) {
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => JobCategories(
//                                 fullName: nameController.text,
//                                 gender: selectedGender!,
//                                 education: selectedEducation!,
//                                 workExperience: selectedExperience!,
//                                 imageFile: File(selectedImage!.path),
//                                 skills: const [],
//                               ),
//                             ),
//                           );
//                         } else {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(content: Text(provider.message ?? "⚠️ Server error!")),
//                           );
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("⚠️ Please complete all fields")),
//                         );
//                       }
//                     },
//
//
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8)),
//                     ),
//                     child: const Text(
//                       "Next",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }






// old and new wala condition laga hai

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:thenaukrimitra/Screens/job_categories.dart';
// import '../main_Screen/main_screen.dart';
// import '../provider/create_provider.dart';
//
// class CreateProfile extends StatefulWidget {
//   final String phone;
//   const CreateProfile({
//     super.key,
//     required this.phone
//   });
//
//   @override
//   State<CreateProfile> createState() => _CreateProfileState();
// }
//
// class _CreateProfileState extends State<CreateProfile> {
//   final TextEditingController nameController = TextEditingController();
//   String? selectedGender;
//   String? selectedEducation;
//   String? selectedExperience;
//   File? selectedImage;
//
//   final ImagePicker picker = ImagePicker();
//   // 📸 Image Picker with permission
//   Future<void> _pickImage(ImageSource source) async {
//     if (source == ImageSource.camera) {
//       var cameraStatus = await Permission.camera.request();
//       if (!cameraStatus.isGranted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Camera permission denied")),
//         );
//         return;
//       }
//     } else {
//       var storageStatus = await Permission.photos.request(); // iOS
//       if (!storageStatus.isGranted) {
//         var androidStatus = await Permission.storage.request(); // Android
//         if (!androidStatus.isGranted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Storage permission denied")),
//           );
//           return;
//         }
//       }
//     }
//
//     final XFile? image = await picker.pickImage(source: source);
//     if (image != null) {
//       setState(() {
//         selectedImage = File(image.path);
//       });
//     }
//     if (mounted) Navigator.pop(context); // bottom sheet band
//   }
//
//   // 📸 BottomSheet to choose Camera/Gallery
//   void _showImagePickerSheet() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text("Choose Profile Photo",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.camera),
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text("Camera"),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.gallery),
//                     icon: const Icon(Icons.photo),
//                     label: const Text("Gallery"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // 🔹 Reusable Option Selector Widget
//   Widget _buildOptions({
//     required String title,
//     required List<String> options,
//     required String? selectedValue,
//     required Function(String) onSelected,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//         Text(title,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: options.map((option) {
//             final isSelected = selectedValue == option;
//             return InkWell(
//               onTap: () => onSelected(option),
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.blue : Colors.orange,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   option,
//                   style: const TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(236, 236, 245, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔙 Back Button
//               const SizedBox(height: 10),
//               InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: const Icon(Icons.arrow_back, color: Colors.blue)),
//               const SizedBox(height: 15),
//
//               const Center(
//                 child: Text(
//                   'Introduce yourself in three easy steps.',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               // 📸 Profile Photo
//               Center(
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage: selectedImage != null
//                           ? FileImage(selectedImage!)
//                           : null,
//                       child: selectedImage == null
//                           ? const Icon(Icons.person,
//                           size: 60, color: Colors.white)
//                           : null,
//                     ),
//                     const SizedBox(height: 12),
//                     InkWell(
//                       onTap: _showImagePickerSheet,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(Icons.camera_alt,
//                               color: Colors.blue, size: 20),
//                           SizedBox(width: 5),
//                           Text(
//                             "Add Photo",
//                             style: TextStyle(
//                               color: Colors.blue,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//
//               const Text("Full Name",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               const SizedBox(height: 5),
//
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//
//               // 🚻 Gender
//               _buildOptions(
//                 title: "Gender",
//                 options: ["Male", "Female", "Other"],
//                 selectedValue: selectedGender,
//                 onSelected: (val) => setState(() => selectedGender = val),
//               ),
//
//               // 🧑‍💼 Experience
//               _buildOptions(
//                 title: "Work Experience",
//                 options: ["I am a fresher", "I have experience"],
//                 selectedValue: selectedExperience,
//                 onSelected: (val) => setState(() => selectedExperience = val),
//               ),
//
//               // 🎓 Education
//               _buildOptions(
//                 title: "Education",
//                 options: [
//                   "10th Pass",
//                   "12th Pass",
//                   "Diploma",
//                   "Graduate",
//                   "Post Graduate"
//                 ],
//                 selectedValue: selectedEducation,
//                 onSelected: (val) => setState(() => selectedEducation = val),
//               ),
//               const SizedBox(height: 40),
//               Center(
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (nameController.text.isNotEmpty &&
//                           selectedGender != null &&
//                           selectedEducation != null &&
//                           selectedExperience != null) {
//
//                         final provider = Provider.of<CreateProvider>(context, listen: false);
//
//                         final bool success = await provider.createUserProfile(
//                           fullName: nameController.text,
//                           phone: widget.phone,
//                           gender: (selectedGender ?? "male").toLowerCase(),
//                           education: selectedEducation!,
//                           jobCategory: "fresher",
//                           skills: "python",
//                           isExperienced: selectedExperience == "I have experience",
//                           totalExperience: "4",
//                           currentSalary: "50000",
//                           email: "divya@gmail.com",
//                           imageFile: selectedImage, // null bhi ho sakta hai
//                         );
//
//                         if (success) {
//                           // ✅ New user → JobCategories
//                           Navigator.pushReplacement(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => JobCategories(
//                                 fullName: nameController.text,
//                                 gender: selectedGender!,
//                                 education: selectedEducation!,
//                                 workExperience: selectedExperience!,
//                                 imageFile:  File(selectedImage!.path),
//                                 skills: const [],
//                               ),
//                             ),
//                           );
//                         } else {
//                           final msg = (provider.message ?? "").toLowerCase();
//
//                           if (msg.contains("already") || msg.contains("exist")) {
//                             // ✅ Duplicate number → MainScreen
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => MainScreen(
//                                   title: '',
//                                   image: '',
//                                   fullName: nameController.text,
//                                   gender: selectedGender!,
//                                   education: selectedEducation!,
//                                   workExperience: selectedExperience!,
//                                   salary: "50000",
//                                   imageFile:  File(selectedImage!.path),
//                                   skills: const [],
//                                 ),
//                               ),
//                             );
//                           } else {
//                             // ⚠️ Any other error
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(content: Text(provider.message ?? "⚠️ Server error!")),
//                             );
//                           }
//                         }
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("⚠️ Please complete all fields")),
//                         );
//                       }
//                     },
//
//
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8)),
//                     ),
//                     child: const Text(
//                       "Next",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//





// ye bina server ka code hai

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:provider/provider.dart';
// import 'package:thenaukrimitra/Screens/job_categories.dart';
//
// import '../provider/create_provider.dart';
//
// class CreateProfile extends StatefulWidget {
//   const CreateProfile({super.key});
//
//   @override
//   State<CreateProfile> createState() => _CreateProfileState();
// }
//
// class _CreateProfileState extends State<CreateProfile> {
//   final TextEditingController nameController = TextEditingController();
//   String? selectedGender;
//   String? selectedEducation;
//   String? selectedExperience;
//   File? selectedImage;
//
//   final ImagePicker picker = ImagePicker();
//
//   // 📸 Image Picker with permission
//   Future<void> _pickImage(ImageSource source) async {
//     if (source == ImageSource.camera) {
//       var cameraStatus = await Permission.camera.request();
//       if (!cameraStatus.isGranted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Camera permission denied")),
//         );
//         return;
//       }
//     } else {
//       var storageStatus = await Permission.photos.request(); // iOS ke liye
//       if (!storageStatus.isGranted) {
//         var androidStatus = await Permission.storage.request(); // Android ke liye
//         if (!androidStatus.isGranted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Storage permission denied")),
//           );
//           return;
//         }
//       }
//     }
//
//     final XFile? image = await picker.pickImage(source: source);
//     if (image != null) {
//       setState(() {
//         selectedImage = File(image.path);
//       });
//     }
//     if (mounted) Navigator.pop(context); // bottom sheet band
//   }
//
//   // 📸 BottomSheet to choose Camera/Gallery
//   void _showImagePickerSheet() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text("Choose Profile Photo",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.camera),
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text("Camera"),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.gallery),
//                     icon: const Icon(Icons.photo),
//                     label: const Text("Gallery"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // 🔹 Reusable Option Selector
//   Widget _buildOptions({
//     required String title,
//     required List<String> options,
//     required String? selectedValue,
//     required Function(String) onSelected,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//         Text(title,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: options.map((option) {
//             final isSelected = selectedValue == option;
//             return InkWell(
//               onTap: () => onSelected(option),
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.blue : Colors.orange,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   option,
//                   style: const TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(236, 236, 245, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔙 Back Button
//               const SizedBox(height: 10),
//               InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: const Icon(Icons.arrow_back, color: Colors.blue)),
//               const SizedBox(height: 15),
//
//               const Center(
//                 child: Text(
//                   'Introduce yourself in three easy steps.',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25),
//
//               // 📸 Profile Photo
//               Center(
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage:
//                       selectedImage != null ? FileImage(selectedImage!) : null,
//                       child: selectedImage == null
//                           ? const Icon(Icons.person,
//                           size: 60, color: Colors.white)
//                           : null,
//                     ),
//                     const SizedBox(height: 12),
//                     InkWell(
//                       onTap: _showImagePickerSheet,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(Icons.camera_alt,
//                               color: Colors.blue, size: 20),
//                           SizedBox(width: 5),
//                           Text(
//                             "Add Photo",
//                             style: TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//               const Text("Full Name",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               const SizedBox(height: 5),
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//
//               // 🚻 Gender
//               _buildOptions(
//                 title: "Gender",
//                 options: ["Male", "Female", "Other"],
//                 selectedValue: selectedGender,
//                 onSelected: (val) => setState(() => selectedGender = val),
//               ),
//               _buildOptions(
//                 title: "Work Experience",
//                 options: ["I am a fresher", "I have experience"],
//                 selectedValue: selectedExperience,
//                 onSelected: (val) => setState(() => selectedExperience = val),
//               ),
//               _buildOptions(
//                 title: "Education",
//                 options: [
//                   "10th Pass",
//                   "12th Pass",
//                   "Diploma",
//                   "Graduate",
//                   "Post Graduate"
//                 ],
//                 selectedValue: selectedEducation,
//                 onSelected: (val) => setState(() => selectedEducation = val),
//               ),
//
//               const SizedBox(height: 40),
//               Center(
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () async {
//                       if (nameController.text.isNotEmpty &&
//                           selectedGender != null &&
//                           selectedEducation != null &&
//                           selectedExperience != null &&
//                           selectedImage != null) {
//
//                         final provider = Provider.of<CreateProvider>(context, listen: false);
//
//                         await provider.createUserProfile(
//                           fullName: nameController.text,
//                           phone: "9199527041",   // abhi static rakha hai
//                           gender: selectedGender!,
//                           education: selectedEducation!,
//                           workExperience: selectedExperience!,
//                           imageFile: selectedImage!,
//                         );
//
//                         // ✅ Ab directly JobCategories pe jao
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => JobCategories(
//                               fullName: provider.fullName!,
//                               gender: provider.gender!,
//                               education: provider.education!,
//                               workExperience: provider.workExperience!,
//                               imageFile: provider.imageFile!, // 👈 provider se bhejo
//                             ),
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(content: Text("⚠️ Please complete all fields")),
//                         );
//                       }
//                     },
//
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue,
//                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     ),
//                     child: const Text(
//                       "Next",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//










// bina api integration wala hai


// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:thenaukrimitra/Screens/job_categories.dart';
//
// class CreateProfile extends StatefulWidget {
//   const CreateProfile({super.key});
//
//   @override
//   State<CreateProfile> createState() => _CreateProfileState();
// }
//
// class _CreateProfileState extends State<CreateProfile> {
//   final TextEditingController nameController = TextEditingController();
//   String? selectedGender;
//   String? selectedEducation;
//   String? selectedExperience;
//   File? selectedImage;
//
//   final ImagePicker picker = ImagePicker();
//
//   // 📸 Image Picker with permission
//   Future<void> _pickImage(ImageSource source) async {
//     if (source == ImageSource.camera) {
//       var cameraStatus = await Permission.camera.request();
//       if (!cameraStatus.isGranted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Camera permission denied")),
//         );
//         return;
//       }
//     } else {
//       var storageStatus = await Permission.photos.request(); // iOS ke liye
//       if (!storageStatus.isGranted) {
//         var androidStatus = await Permission.storage.request(); // Android ke liye
//         if (!androidStatus.isGranted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Storage permission denied")),
//           );
//           return;
//         }
//       }
//     }
//
//     final XFile? image = await picker.pickImage(source: source);
//     if (image != null) {
//       setState(() {
//         selectedImage = File(image.path);
//       });
//     }
//     if (mounted) Navigator.pop(context); // bottom sheet band
//   }
//
//   // 📸 BottomSheet to choose Camera/Gallery
//   void _showImagePickerSheet() {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (_) {
//         return Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Text("Choose Profile Photo",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 15),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.camera),
//                     icon: const Icon(Icons.camera_alt),
//                     label: const Text("Camera"),
//                   ),
//                   ElevatedButton.icon(
//                     onPressed: () => _pickImage(ImageSource.gallery),
//                     icon: const Icon(Icons.photo),
//                     label: const Text("Gallery"),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   // 🔹 Reusable Option Selector
//   Widget _buildOptions({
//     required String title,
//     required List<String> options,
//     required String? selectedValue,
//     required Function(String) onSelected,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//         Text(title,
//             style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: options.map((option) {
//             final isSelected = selectedValue == option;
//             return InkWell(
//               onTap: () => onSelected(option),
//               child: Container(
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.blue : Colors.orange,
//                   borderRadius: BorderRadius.circular(20),
//                 ),
//                 child: Text(
//                   option,
//                   style: const TextStyle(
//                       color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(236, 236, 245, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔙 Back Button
//               const SizedBox(height: 10),
//               InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: const Icon(Icons.arrow_back, color: Colors.blue)),
//               const SizedBox(height: 15),
//
//               const Center(
//                 child: Text(
//                   'Introduce yourself in three easy steps.',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25),
//
//               // 📸 Profile Photo
//               Center(
//                 child: Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey[300],
//                       backgroundImage:
//                       selectedImage != null ? FileImage(selectedImage!) : null,
//                       child: selectedImage == null
//                           ? const Icon(Icons.person,
//                           size: 60, color: Colors.white)
//                           : null,
//                     ),
//                     const SizedBox(height: 12),
//                     InkWell(
//                       onTap: _showImagePickerSheet,
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: const [
//                           Icon(Icons.camera_alt,
//                               color: Colors.blue, size: 20),
//                           SizedBox(width: 5),
//                           Text(
//                             "Add Photo",
//                             style: TextStyle(
//                                 color: Colors.blue,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(height: 25),
//               const Text("Full Name",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//               const SizedBox(height: 5),
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//
//               // 🚻 Gender
//               _buildOptions(
//                 title: "Gender",
//                 options: ["Male", "Female", "Other"],
//                 selectedValue: selectedGender,
//                 onSelected: (val) => setState(() => selectedGender = val),
//               ),
//               _buildOptions(
//                 title: "Work Experience",
//                 options: ["I am a fresher", "I have experience"],
//                 selectedValue: selectedExperience,
//                 onSelected: (val) => setState(() => selectedExperience = val),
//               ),
//               _buildOptions(
//                 title: "Education",
//                 options: [
//                   "10th Pass",
//                   "12th Pass",
//                   "Diploma",
//                   "Graduate",
//                   "Post Graduate"
//                 ],
//                 selectedValue: selectedEducation,
//                 onSelected: (val) => setState(() => selectedEducation = val),
//               ),
//
//               const SizedBox(height: 40),
//               Center(
//                 child: SizedBox(
//                   width: double.infinity,
//                   height: 50,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       if (nameController.text.isNotEmpty &&
//                           selectedGender != null &&
//                           selectedEducation != null &&
//                           selectedExperience != null &&
//                           selectedImage != null) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => JobCategories(
//                               fullName: nameController.text,
//                               gender: selectedGender!,
//                               education: selectedEducation!,
//                               workExperience: selectedExperience!,
//                               imageFile: selectedImage!,
//                             ),
//                           ),
//                         );
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                               content: Text("⚠️ Please complete all fields")),
//                         );
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blue,
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8))),
//                     child: const Text("Next",
//                         style: TextStyle(
//                             color: Colors.white,
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold)),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//











// import 'package:flutter/material.dart';
// import 'package:thenaukrimitra/Screens/job_categories.dart';
//
// class CreateProfile extends StatefulWidget {
//   const CreateProfile({super.key});
//
//   @override
//   State<CreateProfile> createState() => _CreateProfileState();
// }
//
// class _CreateProfileState extends State<CreateProfile> {
//   String? selectedGender;
//   String? selectedExperience;
//   String? selectedEducation;
//
//   final TextEditingController nameController = TextEditingController();
//
//   Widget _buildSelectableChip({
//     required String label,
//     required String? selectedValue,
//     required Function(String) onSelected,
//   }) {
//     bool isSelected = selectedValue == label;
//     return InkWell(
//       onTap: () => onSelected(label),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
//         decoration: BoxDecoration(
//           color: isSelected ? Colors.blue : Colors.orange,
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: const [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 4,
//               offset: Offset(2, 2),
//             ),
//           ],
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSection({
//     required String title,
//     required List<String> options,
//     required String? selectedValue,
//     required Function(String) onSelected,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 20),
//         Text(title, style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
//         const SizedBox(height: 10),
//         Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: options
//               .map((option) => _buildSelectableChip(
//             label: option,
//             selectedValue: selectedValue,
//             onSelected: onSelected,
//           ))
//               .toList(),
//         ),
//         if (selectedValue != null) ...[
//           const SizedBox(height: 6),
//           Text(
//             "Selected: $selectedValue",
//             style: const TextStyle(
//               fontSize: 13,
//               fontStyle: FontStyle.italic,
//               color: Colors.blueGrey,
//             ),
//           ),
//         ]
//       ],
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Color.fromRGBO(236, 236, 245, 1),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 20),
//               InkWell(
//                   onTap: () {
//                     Navigator.pop(context);
//                   },
//                   child: const Icon(Icons.arrow_back, color: Colors.blue)),
//               const SizedBox(height: 10),
//               const Center(
//                 child: Text(
//                   'Introduce yourself in three easy steps.',
//                   style: TextStyle(
//                     fontSize: 18,
//                     color: Colors.blue,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 25),
//               Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundColor: Colors.grey,
//                       child: const Icon(Icons.person,
//                           size: 60, color: Colors.white),
//                     ),
//                     const SizedBox(height: 20),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: const [
//                         Icon(Icons.camera_alt, color: Colors.blue, size: 20),
//                         SizedBox(width: 5),
//                         Text(
//                           "Add Photo",
//                           style: TextStyle(
//                             color: Colors.blue,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 "Full Name",
//                 style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
//               ),
//               const SizedBox(height: 5),
//               TextFormField(
//                 controller: nameController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   contentPadding:
//                   const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                     borderSide: BorderSide.none,
//                   ),
//                 ),
//               ),
//
//               // Gender Section
//               _buildSection(
//                 title: "Gender",
//                 options: ["Male", "Female", "Other"],
//                 selectedValue: selectedGender,
//                 onSelected: (val) {
//                   setState(() {
//                     selectedGender = val;
//                   });
//                 },
//               ),
//
//               // Work Experience Section
//               _buildSection(
//                 title: "Work Experience",
//                 options: ["I am a fresher", "I have experience"],
//                 selectedValue: selectedExperience,
//                 onSelected: (val) {
//                   setState(() {
//                     selectedExperience = val;
//                   });
//                 },
//               ),
//
//               // Education Section
//               _buildSection(
//                 title: "Education",
//                 options: [
//                   "10th Pass",
//                   "12th Pass",
//                   "Diploma",
//                   "Graduate",
//                   "Post Graduate"
//                 ],
//                 selectedValue: selectedEducation,
//                 onSelected: (val) {
//                   setState(() {
//                     selectedEducation = val;
//                   });
//                 },
//               ),
//
//               const SizedBox(height: 40),
//
//
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 30, vertical: 10),
//                       child: SizedBox(
//                         height: 45,
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ),
//                           child: const Text(
//                             "Back",
//                             style: TextStyle(
//                                 color: Colors.white,fontSize: 18,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 10),
//                       child: SizedBox(
//                         height: 45,
//                         child: ElevatedButton(
//                           onPressed: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) =>
//                                     const JobCategories()));
//                           },
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(6),
//                             ),
//                           ),
//                           child: const Text(
//                             "Next",
//                             style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
