









//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../UpdateProfileScreen/UpdateProfileScreen.dart';
// import '../provider/ProfileProvider.dart';
// import 'Setting_Screen.dart';
// import 'resume_service.dart';
// import 'bottom_sheet_helper.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   String? resumeFilePath;
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch profile after first frame
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ProfileProvider>(context);
//     final profile = provider.user;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           "My Profile",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               ),
//               onPressed: () {},
//               icon: const Icon(Icons.share, color: Colors.white, size: 18),
//               label: const Text(
//                 "Share App",
//                 style: TextStyle(color: Colors.white, fontSize: 12),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings, color: Colors.black),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => const SettingScreen()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             // Profile Card
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xfff0f3ff),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 35,
//                     backgroundColor: Colors.grey,
//                     backgroundImage: profile?.image != null
//                         ? NetworkImage(profile!.image!)
//                         : null,
//                     child: profile?.image == null
//                         ? const Icon(Icons.person, size: 45, color: Colors.white)
//                         : null,
//                   ),
//                   const SizedBox(width: 20),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           profile?.fullName ?? "User Name",
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             const Icon(Icons.location_on, size: 14, color: Colors.blue),
//                             const SizedBox(width: 4),
//                             Text(
//                               profile?.userLocation ?? "Not Provided",
//                               style: const TextStyle(fontSize: 12),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Icon(Icons.phone, size: 14, color: Colors.blue),
//                             const SizedBox(width: 4),
//                             Text(
//                               profile?.phone ?? "Not Provided",
//                               style: const TextStyle(fontSize: 12),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Icon(Icons.work, size: 14, color: Colors.blue),
//                             const SizedBox(width: 4),
//                             Text(
//                               profile?.jobCategory ?? "Not Provided",
//                               style: const TextStyle(fontSize: 12),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
//                     onPressed: () {
//                       showModalBottomSheet(
//                         context: context,
//                         isScrollControlled: true,
//                         shape: const RoundedRectangleBorder(
//                           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//                         ),
//                         builder: (context) => Padding(
//                           padding: EdgeInsets.only(
//                             bottom: MediaQuery.of(context).viewInsets.bottom,
//                           ),
//                           child: UpdateProfileSheet(
//                             fullName: profile?.fullName ?? "",
//                             email: profile?.email ?? "",
//                             gender: profile?.gender ?? "",
//                             education: profile?.education ?? "",
//                           ),
//                         ),
//                       ).then((_) {
//                         Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             // Work Experience
//             _buildCard(
//               title: "Work Experience",
//               trailing: "Add New",
//               content: [
//                 _ListItem(
//                   icon: Icons.work,
//                   value: profile?.isExperienced == true
//                       ? "${profile?.totalExperience} Years"
//                       : "Fresher",
//                 ),
//               ],
//             ),
//
//             // Personal Information
//             _buildCard(
//               title: "Personal Information",
//               editable: true,
//               content: [
//                 _InfoRow(
//                   label: "Email",
//                   value: profile?.email ?? "Not Provided",
//                 ),
//                 _InfoRow(
//                   label: "Gender",
//                   value: profile?.gender ?? "Not Provided",
//                 ),
//                 _InfoRow(
//                   label: "Education Level",
//                   value: profile?.education ?? "Not Provided",
//                 ),
//               ],
//             ),
//
//             // Language
//             _buildCard(
//               title: "Language",
//               content: (profile?.language ?? [])
//                   .map((lang) => _ListItem(value: lang))
//                   .toList(),
//             ),
//
//             // Skills
//             _buildCard(
//               title: "Skills",
//               editable: true,
//               onEdit: () async {
//                 final updatedSkills = await BottomSheetHelper.showSkillsSelector(
//                   context: context,
//                   currentSkills: profile?.skills ?? [],
//                 );
//                 if (updatedSkills != null) {
//                   setState(() {
//                     profile?.skills = updatedSkills;
//                   });
//                 }
//               },
//               content: (profile?.skills ?? []).map((s) => _ListItem(value: s)).toList(),
//             ),
//
//             // Resume
//             _buildCard(
//               title: "Resume",
//               editable: true,
//               onEdit: () async {
//                 final filePath = await ResumeService.pickResume(context);
//                 if (filePath != null) {
//                   setState(() {
//                     resumeFilePath = filePath;
//                   });
//                 }
//               },
//               content: [
//                 _ListItem(
//                   value: profile?.resume != null
//                       ? profile!.resume!.split('/').last
//                       : "Add Resume",
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCard({
//     required String title,
//     List<Widget> content = const [],
//     bool editable = false,
//     String? trailing,
//     VoidCallback? onEdit,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               if (trailing != null)
//                 GestureDetector(
//                   onTap: () {},
//                   child: Text(
//                     trailing,
//                     style: const TextStyle(
//                       color: Colors.blue,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               if (editable)
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
//                   onPressed: onEdit,
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           ...content,
//         ],
//       ),
//     );
//   }
// }
//
// class _InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//
//   const _InfoRow({required this.label, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: const TextStyle(fontSize: 12, color: Colors.black87),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ListItem extends StatelessWidget {
//   final IconData? icon;
//   final String? text;
//   final String? value;
//
//   const _ListItem({this.icon, this.text, this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (icon != null)
//             Icon(icon, size: 16, color: Colors.blue)
//           else
//             const SizedBox(width: 16),
//           if (icon != null) const SizedBox(width: 4),
//           Expanded(
//             child: Text(
//               text != null ? (value != null ? "$text: $value" : text!) : value ?? "",
//               style: const TextStyle(fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//







//29-09-2025

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../UpdateProfileScreen/UpdateProfileScreen.dart';
import '../provider/ProfileProvider.dart';
import '../utils/custom_app_bar.dart';
import 'Setting_Screen.dart';
import 'resume_service.dart';
import 'bottom_sheet_helper.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key,});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? resumeFilePath;
  List<String> skills = ["PHP", "Dart", "Flutter"];
  List<String> personalInformation=[

    "email", "Gender"," Education Lavel",
  ];

  @override
  void initState() {
    super.initState();
    // ✅ FIX: Call fetchProfile after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProfileProvider>(context);
    final profile = provider.user;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "My Profile",
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // Profile Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xfff0f3ff),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey,
                    backgroundImage: profile?.image != null
                        ? NetworkImage(profile!.image!)
                        : null,
                    child: profile?.image == null
                        ? const Icon(Icons.person, size: 45, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile?.fullName ?? "User Name ",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: const [
                            Icon(Icons.location_on, size: 14, color: Colors.blue),
                            SizedBox(width: 4),
                            Text("Sector 63, Noida",
                                style: TextStyle(fontSize: 12)), // default
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.phone,
                                size: 14, color: Colors.blue),
                            const SizedBox(width: 4),
                            Text(profile?.phone ?? "phone",
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        Row(
                          children: [
                            const Icon(Icons.work,
                                size: 14, color: Colors.blue),
                            const SizedBox(width: 4),
                            Text(profile?.jobCategory ?? "Flutter Developer",
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: UpdateProfileSheet (
                                fullName: profile?.fullName ?? "",
                                email: profile?.email ?? "",
                                gender: profile?.gender ?? "",
                                education: profile?.education ?? "",
                              ),
                            ),
                          ).then((_) {
                            Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings, color: Colors.blue, size: 20),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            _buildCard(
              title: "Work Experience",
              trailing: "Add New",
              content: [
                _ListItem(
                    icon: Icons.work,
                    value: profile?.isExperienced == true
                        ? "${profile?.totalExperience} Years"
                        : "Fresher"),
              ],
            ),
            _buildCard(
              title: "Personal Information",
              editable: true,
              content: [
                _InfoRow(
                    label: "Email",
                    value: profile?.email ?? "codingwalle@gmail.com"),
                _InfoRow(
                    label: "Gender", value: profile?.gender ?? "Male"),
                _InfoRow(
                    label: "Education Level",
                    value: profile?.education ?? "Graduate"),
              ],


            ),
            _buildCard(
              title: "Language",
              content: const [
                _ListItem(text: "English Level", value: "Good English"),
              ],
            ),
            _buildCard(
              title: "Skills",
              editable: true,
              onEdit: () async {
                final updatedSkills =
                await BottomSheetHelper.showSkillsSelector(
                  context: context,
                  currentSkills: skills,
                );
                if (updatedSkills != null) {
                  setState(() {
                    skills = updatedSkills;
                  });
                }
              },
              content: skills.map((s) => _ListItem(value: s)).toList(),
            ),
            _buildCard(
              title: "Resume",
              editable: true,
              onEdit: () async {
                final filePath = await ResumeService.pickResume(context);
                if (filePath != null) {
                  setState(() {
                    resumeFilePath = filePath;
                  });
                }
              },
              content: [
                _ListItem(
                  value: resumeFilePath != null
                      ? resumeFilePath!.split('/').last
                      : "Add Resume",
                ),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _buildCard({
    required String title,
    List<Widget> content = const [],
    bool editable = false,
    String? trailing,
    VoidCallback? onEdit,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              if (trailing != null)
                GestureDetector(
                  onTap: () {},
                  child: Text(
                    trailing,
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                    ),
                  ),
                ),
              if (editable)
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
                  onPressed: onEdit,
                ),
            ],
          ),
          const SizedBox(height: 8),
          ...content,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ListItem extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final String? value;

  const _ListItem({this.icon, this.text, this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Icon(icon, size: 16, color: Colors.blue)
          else
            const SizedBox(width: 16),
          if (icon != null) const SizedBox(width: 4),
          Expanded(
            child: Text(
              text != null
                  ? (value != null ? "$text: $value" : text!)
                  : value ?? "",
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}































// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/ProfileProvider.dart';
//
// import 'Setting_Screen.dart';
// import 'resume_service.dart';
// import 'bottom_sheet_helper.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   String? resumeFilePath;
//   List<String> skills = ["PHP", "Dart", "Flutter"];
//
//   @override
//   void initState() {
//     super.initState();
//     Provider.of<ProfileProvider>(context, listen: false).fetchProfile();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final provider = Provider.of<ProfileProvider>(context);
//     final user = provider.user;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           "My Profile",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               ),
//               onPressed: () {},
//               icon: const Icon(Icons.share, color: Colors.white, size: 18),
//               label: const Text(
//                 "Share App",
//                 style: TextStyle(color: Colors.white, fontSize: 12),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings, color: Colors.black),
//             onPressed: () {
//               Navigator.push(context,
//                   MaterialPageRoute(builder: (context) => SettingScreen()));
//             },
//           ),
//         ],
//       ),
//       body: provider.isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             // Profile Card
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xfff0f3ff),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 35,
//                     backgroundColor: Colors.grey,
//                     backgroundImage: user?.image != null
//                         ? NetworkImage(user!.image!)
//                         : null,
//                     child: user?.image == null
//                         ? const Icon(Icons.person,
//                         size: 40, color: Colors.white)
//                         : null,
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           user?.fullName ?? "User Name",
//                           style: const TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             const Icon(Icons.phone,
//                                 size: 14, color: Colors.blue),
//                             const SizedBox(width: 4),
//                             Text(user?.phone ?? "phone",
//                                 style: const TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             const Icon(Icons.work,
//                                 size: 14, color: Colors.blue),
//                             const SizedBox(width: 4),
//                             Text(user?.jobCategory ??
//                                 "Flutter Developer",
//                                 style: const TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.edit,
//                         color: Colors.blue, size: 18),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             _buildCard(
//               title: "Work Experience",
//               trailing: "Add New",
//               content: [
//                 _ListItem(
//                     icon: Icons.work,
//                     value: user?.isExperienced == true
//                         ? "${user?.totalExperience} Years"
//                         : "Fresher"),
//               ],
//             ),
//
//             _buildCard(
//               title: "Personal Information",
//               editable: true,
//               content: [
//                 _InfoRow(
//                     label: "Email",
//                     value: user?.email ?? "codingwalle@gmail.com"),
//                 _InfoRow(
//                     label: "Gender",
//                     value: user?.gender ?? "Gender"),
//                 _InfoRow(
//                     label: "Education Level",
//                     value: user?.education ?? "Education"),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCard({
//     required String title,
//     List<Widget> content = const [],
//     bool editable = false,
//     String? trailing,
//     VoidCallback? onEdit,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               if (trailing != null)
//                 GestureDetector(
//                   onTap: () {},
//                   child: Text(
//                     trailing,
//                     style: const TextStyle(
//                       color: Colors.blue,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               if (editable)
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
//                   onPressed: onEdit,
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           ...content,
//         ],
//       ),
//     );
//   }
// }
//
// class _InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//
//   const _InfoRow({required this.label, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: const TextStyle(fontSize: 12, color: Colors.black87),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ListItem extends StatelessWidget {
//   final IconData? icon;
//   final String? text;
//   final String? value;
//
//   const _ListItem({this.icon, this.text, this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (icon != null)
//             Icon(icon, size: 16, color: Colors.blue)
//           else
//             const SizedBox(width: 16),
//           if (icon != null) const SizedBox(width: 4),
//           Expanded(
//             child: Text(
//               text != null
//                   ? (value != null ? "$text: $value" : text!)
//                   : value ?? "",
//               style: const TextStyle(fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
//
//



//
//
//
//
//
//
// import 'package:flutter/material.dart';
// import 'Setting_Screen.dart';
// import 'resume_service.dart';
// import 'bottom_sheet_helper.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   String? resumeFilePath;
//   List<String> skills = ["PHP", "Dart", "Flutter"];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           "My Profile",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               ),
//               onPressed: () {},
//               icon: const Icon(Icons.share, color: Colors.white, size: 18),
//               label: const Text(
//                 "Share App",
//                 style: TextStyle(color: Colors.white, fontSize: 12),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings, color: Colors.black),
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingScreen()));
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             // Profile Card
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xfff0f3ff),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const CircleAvatar(
//                     radius: 35,
//                     backgroundColor: Colors.grey,
//                     child: Icon(Icons.person, size: 40, color: Colors.white),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text(
//                           "Asif Ali Khan",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.location_on,
//                                 size: 14, color: Colors.blue),
//                             SizedBox(width: 4),
//                             Text("Sector 63, Noida",
//                                 style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.phone, size: 14, color: Colors.blue),
//                             SizedBox(width: 4),
//                             Text("9199786786",
//                                 style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.work, size: 14, color: Colors.blue),
//                             SizedBox(width: 4),
//                             Text("Flutter Developer",
//                                 style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             _buildCard(
//               title: "Work Experience",
//               trailing: "Add New",
//               content: const [
//                 _ListItem(icon: Icons.work, value: "Full Stack Developer"),
//               ],
//             ),
//
//             // ✅ Updated Personal Information
//             _buildCard(
//               title: "Personal Information",
//               editable: true,
//               content: const [
//                 _InfoRow(label: "Email", value: "codingwalle@gmail.com"),
//                 _InfoRow(label: "Gender", value: "Male"),
//                 _InfoRow(label: "Education Level", value: "Graduate"),
//               ],
//             ),
//             _buildCard(
//               title: "Language",
//               content: const [
//                 _ListItem(text: "English Level", value: "Good English"),
//               ],
//             ),
//             _buildCard(
//               title: "Skills",
//               editable: true,
//               onEdit: () async {
//                 final updatedSkills =
//                 await BottomSheetHelper.showSkillsSelector(
//                   context: context,
//                   currentSkills: skills,
//                 );
//                 if (updatedSkills != null) {
//                   setState(() {
//                     skills = updatedSkills;
//                   });
//                 }
//               },
//               content: skills.map((s) => _ListItem(value: s)).toList(),
//             ),
//             _buildCard(
//               title: "Resume",
//               editable: true,
//               onEdit: () async {
//                 final filePath = await ResumeService.pickResume(context);
//                 if (filePath != null) {
//                   setState(() {
//                     resumeFilePath = filePath;
//                   });
//                 }
//               },
//               content: [
//                 _ListItem(
//                   value: resumeFilePath != null
//                       ? resumeFilePath!.split('/').last
//                       : "Add Resume",
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCard({
//     required String title,
//     List<Widget> content = const [],
//     bool editable = false,
//     String? trailing,
//     VoidCallback? onEdit,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               if (trailing != null)
//                 GestureDetector(
//                   onTap: () {},
//                   child: Text(
//                     trailing,
//                     style: const TextStyle(
//                       color: Colors.blue,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               if (editable)
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
//                   onPressed: onEdit,
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           ...content,
//         ],
//       ),
//     );
//   }
// }
//
// // 🔹 New widget for left label + right bold value
// class _InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//
//   const _InfoRow({required this.label, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: const TextStyle(fontSize: 12, color: Colors.black87),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ListItem extends StatelessWidget {
//   final IconData? icon;
//   final String? text;
//   final String? value;
//
//   const _ListItem({this.icon, this.text, this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (icon != null)
//             Icon(icon, size: 16, color: Colors.blue)
//           else
//             const SizedBox(width: 16),
//           if (icon != null) const SizedBox(width: 4),
//           Expanded(
//             child: Text(
//               text != null ? (value != null ? "$text: $value" : text!) : value ?? "",
//               style: const TextStyle(fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }






// Without use Api

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/ProfileProvider.dart';
// import 'Setting_Screen.dart';
// import 'resume_service.dart';
// import 'bottom_sheet_helper.dart';
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   String? resumeFilePath;
//   List<String> skills = ["PHP", "Dart", "Flutter"];
//
//   @override
//   Widget build(BuildContext context) {
//     final profileProvider = Provider.of<ProfileProvider>(context);
//     final profile = profileProvider.profile;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           "My Profile",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               ),
//               onPressed: () {},
//               icon: const Icon(Icons.share, color: Colors.white, size: 18),
//               label: const Text(
//                 "Share App",
//                 style: TextStyle(color: Colors.white, fontSize: 12),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings, color: Colors.black),
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingScreen()));
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             // Profile Card
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xfff0f3ff),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   CircleAvatar(
//                     radius: 35,
//                     backgroundColor: Colors.grey,
//                     backgroundImage: profile?.imageUrl != null
//                         ? NetworkImage(profile!.imageUrl!)
//                         : null,
//                     child: profile?.imageUrl == null
//                         ? const Icon(Icons.person, size: 40, color: Colors.white)
//                         : null,
//                   ),
//                   SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           profile?.name ?? "N/A",
//                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.phone, size: 14, color: Colors.blue),
//                             SizedBox(width: 4),
//                             Text(profile?.mobile ?? "N/A", style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.work, size: 14, color: Colors.blue),
//                             SizedBox(width: 4),
//                             Text(profile?.jobCategory ?? "N/A", style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             _buildCard(
//               title: "Work Experience",
//               trailing: "Add New",
//               content: const [
//                 _ListItem(icon: Icons.work, value: "Full Stack Developer"),
//               ],
//             ),
//
//             // ✅ Updated Personal Information
//             _buildCard(
//               title: "Personal Information",
//               editable: true,
//               content: [
//                 _InfoRow(label: "Email", value: profile?.email ?? "N/A"),
//                 _InfoRow(label: "Gender", value: profile?.gender ?? "N/A"),
//                 _InfoRow(label: "Education", value: profile?.education ?? "N/A"),
//               ],
//             ),
//
//             _buildCard(
//               title: "Language",
//               content: const [
//                 _ListItem(text: "English Level", value: "Good English"),
//               ],
//             ),
//             _buildCard(
//               title: "Skills",
//               editable: true,
//               content: (profile?.skills.isNotEmpty == true
//                   ? profile!.skills.split(",").map((s) => _ListItem(value: s)).toList()
//                   : [_ListItem(value: "No skills added")]),
//             ),
//
//             _buildCard(
//               title: "Resume",
//               editable: true,
//               onEdit: () async {
//                 final filePath = await ResumeService.pickResume(context);
//                 if (filePath != null) {
//                   setState(() {
//                     resumeFilePath = filePath;
//                   });
//                 }
//               },
//               content: [
//                 _ListItem(
//                   value: resumeFilePath != null
//                       ? resumeFilePath!.split('/').last
//                       : "Add Resume",
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCard({
//     required String title,
//     List<Widget> content = const [],
//     bool editable = false,
//     String? trailing,
//     VoidCallback? onEdit,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               if (trailing != null)
//                 GestureDetector(
//                   onTap: () {},
//                   child: Text(
//                     trailing,
//                     style: const TextStyle(
//                       color: Colors.blue,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               if (editable)
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
//                   onPressed: onEdit,
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           ...content,
//         ],
//       ),
//     );
//   }
// }
//
// // 🔹 New widget for left label + right bold value
// class _InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//
//   const _InfoRow({required this.label, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: const TextStyle(fontSize: 12, color: Colors.black87),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ListItem extends StatelessWidget {
//   final IconData? icon;
//   final String? text;
//   final String? value;
//
//   const _ListItem({this.icon, this.text, this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (icon != null)
//             Icon(icon, size: 16, color: Colors.blue)
//           else
//             const SizedBox(width: 16),
//           if (icon != null) const SizedBox(width: 4),
//           Expanded(
//             child: Text(
//               text != null ? (value != null ? "$text: $value" : text!) : value ?? "",
//               style: const TextStyle(fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//




// correct code
//

// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'Setting_Screen.dart';
// import 'resume_service.dart';
// import 'bottom_sheet_helper.dart';
//
// class ProfileScreen extends StatefulWidget {
//   // final String fullName;
//   // final String gender;
//   // final String education;
//   // final String workExperience;
//   // final File imageFile;
//   const ProfileScreen({super.key,
//     // required this.fullName,
//     // required this.gender,
//     // required this.education,
//     // required this.workExperience,
//     // required this.imageFile, required List skills, required String salary,
//   });
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   String? resumeFilePath;
//   List<String> skills = ["PHP", "Dart", "Flutter"];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text(
//           "My Profile",
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 padding:
//                 const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               ),
//               onPressed: () {},
//               icon: const Icon(Icons.share, color: Colors.white, size: 18),
//               label: const Text(
//                 "Share App",
//                 style: TextStyle(color: Colors.white, fontSize: 12),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings, color: Colors.black),
//             onPressed: () {
//              Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingScreen()));
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             // Profile Card
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xfff0f3ff),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const CircleAvatar(
//                     radius: 35,
//                     backgroundColor: Colors.grey,
//                     child: Icon(Icons.person, size: 40, color: Colors.white),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         Text(
//                           "Asif Ali Khan",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.location_on,
//                                 size: 14, color: Colors.blue),
//                             SizedBox(width: 4),
//                             Text("Sector 63, Noida",
//                                 style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.phone, size: 14, color: Colors.blue),
//                             SizedBox(width: 4),
//                             Text("9199786786",
//                                 style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                         Row(
//                           children: [
//                             Icon(Icons.work, size: 14, color: Colors.blue),
//                             SizedBox(width: 4),
//                             Text("Flutter Developer",
//                                 style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
//                     onPressed: () {},
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             _buildCard(
//               title: "Work Experience",
//               trailing: "Add New",
//               content: const [
//                 _ListItem(icon: Icons.work, value: "Full Stack Developer"),
//               ],
//             ),
//
//             // ✅ Updated Personal Information
//             _buildCard(
//               title: "Personal Information",
//               editable: true,
//               content: const [
//                 _InfoRow(label: "Email", value: "codingwalle@gmail.com"),
//                 _InfoRow(label: "Gender", value: "Male"),
//                 _InfoRow(label: "Education Level", value: "Graduate"),
//               ],
//             ),
//             _buildCard(
//               title: "Language",
//               content: const [
//                 _ListItem(text: "English Level", value: "Good English"),
//               ],
//             ),
//             _buildCard(
//               title: "Skills",
//               editable: true,
//               onEdit: () async {
//                 final updatedSkills =
//                 await BottomSheetHelper.showSkillsSelector(
//                   context: context,
//                   currentSkills: skills,
//                 );
//                 if (updatedSkills != null) {
//                   setState(() {
//                     skills = updatedSkills;
//                   });
//                 }
//               },
//               content: skills.map((s) => _ListItem(value: s)).toList(),
//             ),
//             _buildCard(
//               title: "Resume",
//               editable: true,
//               onEdit: () async {
//                 final filePath = await ResumeService.pickResume(context);
//                 if (filePath != null) {
//                   setState(() {
//                     resumeFilePath = filePath;
//                   });
//                 }
//               },
//               content: [
//                 _ListItem(
//                   value: resumeFilePath != null
//                       ? resumeFilePath!.split('/').last
//                       : "Add Resume",
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCard({
//     required String title,
//     List<Widget> content = const [],
//     bool editable = false,
//     String? trailing,
//     VoidCallback? onEdit,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.2),
//             blurRadius: 4,
//             offset: const Offset(0, 2),
//           ),
//         ],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   title,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 14,
//                   ),
//                 ),
//               ),
//               if (trailing != null)
//                 GestureDetector(
//                   onTap: () {},
//                   child: Text(
//                     trailing,
//                     style: const TextStyle(
//                       color: Colors.blue,
//                       fontSize: 12,
//                     ),
//                   ),
//                 ),
//               if (editable)
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
//                   onPressed: onEdit,
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           ...content,
//         ],
//       ),
//     );
//   }
// }
//
// // 🔹 New widget for left label + right bold value
// class _InfoRow extends StatelessWidget {
//   final String label;
//   final String value;
//
//   const _InfoRow({required this.label, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Expanded(
//             flex: 2,
//             child: Text(
//               label,
//               style: const TextStyle(fontSize: 12, color: Colors.black87),
//             ),
//           ),
//           Expanded(
//             flex: 3,
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 12,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ListItem extends StatelessWidget {
//   final IconData? icon;
//   final String? text;
//   final String? value;
//
//   const _ListItem({this.icon, this.text, this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (icon != null)
//             Icon(icon, size: 16, color: Colors.blue)
//           else
//             const SizedBox(width: 16),
//           if (icon != null) const SizedBox(width: 4),
//           Expanded(
//             child: Text(
//               text != null ? (value != null ? "$text: $value" : text!) : value ?? "",
//               style: const TextStyle(fontSize: 12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//






//
//
// import 'package:flutter/material.dart';
// import 'package:thenaukrimitra/custom/Setting_Screen.dart';
// // import 'package:thenaukrimitra/custom/custom_buttom_nav.dart';
// import 'package:thenaukrimitra/custom/resume_service.dart';
// import 'bottom_sheet_helper.dart';
//
//
// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   String? resumeFileName;
//   // int _selectedIndex = 0;
//   //
//   // void _onBottomNavTap(int index) {
//   //   setState(() {
//   //     _selectedIndex = index;
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: const Text("My Profile",
//             style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               ),
//               onPressed: () {},
//               icon: const Icon(Icons.share, color: Colors.white, size: 18),
//               label: const Text("Share App", style: TextStyle(color: Colors.white, fontSize: 12)),
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.settings, color: Colors.black),
//             onPressed: () {
//               Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingScreen()));
//
//
//             },
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             // Profile Card
//             Container(
//               padding: const EdgeInsets.all(12),
//               decoration: BoxDecoration(
//                 color: const Color(0xfff0f3ff),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const CircleAvatar(
//                     radius: 35,
//                     backgroundColor: Colors.grey,
//                     child: Icon(Icons.person, size: 40, color: Colors.white),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text("Asif Ali Khan",
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//                         Row(
//                           children: const [
//                             Icon(Icons.location_on, size: 14, color: Colors.blue),
//                             SizedBox(width: 4),
//                             Text("Sector 63, Noida", style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                         Row(
//                           children: const [
//                             Icon(Icons.phone, size: 14, color: Colors.blue),
//                             SizedBox(width: 4),
//                             Text("9199786786", style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                         Row(
//                           children: const [
//                             Icon(Icons.work, size: 14, color: Colors.blue),
//                             SizedBox(width: 4),
//                             Text("Flutter Developer", style: TextStyle(fontSize: 12)),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
//                     onPressed: () {
//                       BottomSheetHelper.show(
//                         context: context,
//                         title: "Edit Profile",
//                         content: "Here you can edit profile details.",
//                       );
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 12),
//
//             _buildCard(
//               title: "Work Experience",
//               trailing: "Add New",
//               content: const [_ListItem(icon: Icons.work, text: "Full Stack Developer")],
//             ),
//             _buildCard(
//               title: "Personal Information",
//               editable: true,
//               content: const [
//                 _ListItem(text: "Email", value: "codingwalle@gmail.com"),
//                 _ListItem(text: "Gender", value: "Male"),
//                 _ListItem(text: "Education Level", value: "Graduate"),
//               ],
//             ),
//             _buildCard(
//               title: "Language",
//               content: const [_ListItem(text: "English Level", value: "Good English")],
//             ),
//             _buildCard(
//               title: "Skills",
//               editable: true,
//               content: const [
//                 _ListItem(value: "PHP"),
//                 _ListItem(value: "Dart"),
//                 _ListItem(value: "Flutter"),
//               ],
//             ),
//             _buildCard(
//               title: "Resume",
//               editable: true,
//               onEdit: () async {
//                 final fileName = await ResumeService.pickResume(context);
//                 if (fileName != null) {
//                   setState(() {
//                     resumeFileName = fileName;
//                   });
//                 }
//               },
//               content: [
//                 _ListItem(value: resumeFileName ?? "Add Resume    Resume File name"),
//               ],
//             ),
//           ],
//         ),
//       ),
//
//       // bottomNavigationBar: CustomBottomNav(
//       //   currentIndex: _selectedIndex,
//       //   onTap: _onBottomNavTap,
//       // ),
//
//     );
//   }
//
//   Widget _buildCard({
//     required String title,
//     List<Widget> content = const [],
//     bool editable = false,
//     String? trailing,
//     VoidCallback? onEdit,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [
//           BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 4, offset: const Offset(0, 2))
//         ],
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
//               if (trailing != null)
//                 GestureDetector(
//                   onTap: () {},
//                   child: Text(trailing, style: const TextStyle(color: Colors.blue, fontSize: 12)),
//                 ),
//               if (editable)
//                 IconButton(
//                   icon: const Icon(Icons.edit, color: Colors.blue, size: 18),
//                   onPressed: onEdit ??
//                           () {
//                         BottomSheetHelper.show(
//                           context: context,
//                           title: "Edit $title",
//                           content: "Here you can edit $title details.",
//                         );
//                       },
//                 ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           ...content
//         ],
//       ),
//     );
//   }
// }
//
// class _ListItem extends StatelessWidget {
//   final IconData? icon;
//   final String? text;
//   final String? value;
//
//   const _ListItem({this.icon, this.text, this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (icon != null)
//             Icon(icon, size: 16, color: Colors.blue)
//           else
//             const SizedBox(width: 16),
//           if (icon != null) const SizedBox(width: 4),
//           if (text != null)
//             Expanded(
//               child: Text(
//                 value != null ? "$text\n$value" : text!,
//                 style: TextStyle(
//                   fontSize: 12,
//                   fontWeight: value != null ? FontWeight.normal : FontWeight.bold,
//                 ),
//               ),
//             )
//           else if (value != null)
//             Expanded(
//               child: Text(value!, style: const TextStyle(fontSize: 12)),
//             ),
//         ],
//       ),
//     );
//   }
// }
