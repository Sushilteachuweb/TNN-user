import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:thenaukrimitra/Screens/job_cate1.dart';
import 'package:thenaukrimitra/utils/app_colors.dart';
class JobCategories extends StatefulWidget {
  final String fullName;
  // final String phone;
  final String gender;
  final String education;
  final String workExperience;
  final File imageFile;
  const JobCategories({
    super.key,
    // required this.phone,
    required this.fullName,
    required this.gender,
    required this.education,
    required this.workExperience,
    required this.imageFile, required List skills,
  });

  @override
  State<JobCategories> createState() => _JobCategoriesState();
}

class _JobCategoriesState extends State<JobCategories> {
  final List<Map<String, String>> jobList = [
    {'title': 'Graphic Designer', 'image': 'images/man.jpg'},
    {'title': 'Sales / Business Development', 'image': 'images/man.jpg'},
    {'title': 'Data Entry Operator', 'image': 'images/man.jpg'},
    {'title': 'Delivery Executive', 'image': 'images/man.jpg'},
    {'title': 'Customer Support', 'image': 'images/man.jpg'},
    {'title': 'Sales / Business Development', 'image': 'images/man.jpg'},
    {'title': 'Data Entry Operator', 'image': 'images/man.jpg'},
    {'title': 'Delivery Executive', 'image': 'images/man.jpg'},
    {'title': 'Customer Support', 'image': 'images/man.jpg'},
    {'title': 'Field Executive', 'image': 'images/man.jpg'},
  ];
  String searchQuery = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // Simulate API load
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = jobList
        .where((job) => job['title']!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FE),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Arrow
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.blue),
              ),
              const SizedBox(height: 10),


              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Search Job Categories",
                    prefixIcon: const Icon(Icons.search, color: Colors.blue,),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Select Job Category",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),

              // Job List or Shimmer
              Expanded(
                child: isLoading
                    ? _buildShimmerList()
                    : filteredList.isEmpty
                    ? const Center(child: Text('No categories found'))
                    : ListView.builder(
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final job = filteredList[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobCate1(
                              title: job['title']!,
                              image: job['image']!,
                              fullName: widget.fullName,
                              gender: widget.gender,
                              education: widget.education,
                              workExperience: widget.workExperience,
                              imageFile: widget.imageFile,
                              // phone: 'widget.phone', email: '',
                            ),
                          ),
                        );
                      },

                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        padding: const EdgeInsets.all(10),
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
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                job['image']!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                job['title']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  // Shimmer UI
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Shimmer.fromColors(
              baseColor: AppColors.searchIcon,
              highlightColor: Colors.grey[100]!,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  height: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}









// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:shimmer/shimmer.dart';
//
// import 'package:thenaukrimitra/Screens/job_cate1.dart';
// import 'package:thenaukrimitra/utils/app_colors.dart';
//
// class JobCategories extends StatefulWidget {
//   final String fullName;
//   final String gender;
//   final String education;
//   final String workExperience;
//   final File imageFile;
//   const JobCategories({
//     super.key,
//     required this.fullName,
//     required this.gender,
//     required this.education,
//     required this.workExperience,
//     required this.imageFile,
//   });
//
//   @override
//   State<JobCategories> createState() => _JobCategoriesState();
// }
//
// class _JobCategoriesState extends State<JobCategories> {
//   final List<Map<String, String>> jobList = [
//     {'title': 'Graphic Designer', 'image': 'images/man.jpg'},
//     {'title': 'Sales / Business Development', 'image': 'images/man.jpg'},
//     {'title': 'Data Entry Operator', 'image': 'images/man.jpg'},
//     {'title': 'Delivery Executive', 'image': 'images/man.jpg'},
//     {'title': 'Customer Support', 'image': 'images/man.jpg'},
//     {'title': 'Sales / Business Development', 'image': 'images/man.jpg'},
//     {'title': 'Data Entry Operator', 'image': 'images/man.jpg'},
//     {'title': 'Delivery Executive', 'image': 'images/man.jpg'},
//     {'title': 'Customer Support', 'image': 'images/man.jpg'},
//     {'title': 'Field Executive', 'image': 'images/man.jpg'},
//   ];
//
//   String searchQuery = '';
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Simulate API load
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final filteredList = jobList
//         .where((job) => job['title']!.toLowerCase().contains(searchQuery.toLowerCase()))
//         .toList();
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F6FE),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Back Arrow
//               IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: const Icon(Icons.arrow_back, color: Colors.blue),
//               ),
//               const SizedBox(height: 10),
//
//               // Search Field
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.2),
//                       blurRadius: 6,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   onChanged: (value) {
//                     setState(() {
//                       searchQuery = value;
//                     });
//                   },
//                   decoration: InputDecoration(
//                     hintText: "Search Job Categories",
//                     prefixIcon: const Icon(Icons.search, color: Colors.blue,),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//               const Text(
//                 "Select Job Category",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 18,
//                 ),
//               ),
//               const SizedBox(height: 10),
//
//               // Job List or Shimmer
//               Expanded(
//                 child: isLoading
//                     ? _buildShimmerList()
//                     : filteredList.isEmpty
//                     ? const Center(child: Text('No categories found'))
//                     : ListView.builder(
//                   itemCount: filteredList.length,
//                   itemBuilder: (context, index) {
//                     final job = filteredList[index];
//                     return InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => JobCate1(
//                               title: job['title']!,
//                               image: job['image']!,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(12),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.15),
//                               blurRadius: 6,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Row(
//                           children: [
//                             ClipRRect(
//                               borderRadius: BorderRadius.circular(8),
//                               child: Image.asset(
//                                 job['image']!,
//                                 width: 60,
//                                 height: 60,
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             Expanded(
//                               child: Text(
//                                 job['title']!,
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.w500,
//                                   fontSize: 16,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               // Navigation Buttons
//               // Row(
//               //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               //   children: [
//               //     ElevatedButton(
//               //       onPressed: () => Navigator.pop(context),
//               //       style: ElevatedButton.styleFrom(
//               //         backgroundColor: Colors.blue,
//               //         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//               //         shape: RoundedRectangleBorder(
//               //           borderRadius: BorderRadius.circular(8),
//               //         ),
//               //       ),
//               //       child: const Text(
//               //         'Back',
//               //         style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
//               //       ),
//               //     ),
//               //     ElevatedButton(
//               //       onPressed: () {
//               //         // Optional: you can skip or disable this if not used anymore
//               //       },
//               //       style: ElevatedButton.styleFrom(
//               //         backgroundColor: Colors.blue,
//               //         padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
//               //         shape: RoundedRectangleBorder(
//               //           borderRadius: BorderRadius.circular(8),
//               //         ),
//               //       ),
//               //       child: const Text(
//               //         'Next',
//               //         style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
//               //       ),
//               //     ),
//               //   ],
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Shimmer UI
//   Widget _buildShimmerList() {
//     return ListView.builder(
//       itemCount: 6,
//       itemBuilder: (_, __) => Container(
//         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           children: [
//             Shimmer.fromColors(
//               baseColor: AppColors.searchIcon,
//               highlightColor: Colors.grey[100]!,
//               child: Container(
//                 width: 60,
//                 height: 60,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Shimmer.fromColors(
//                 baseColor: Colors.grey[300]!,
//                 highlightColor: Colors.grey[100]!,
//                 child: Container(
//                   height: 20,
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//











