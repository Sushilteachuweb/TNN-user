// working hai 09-09-2025


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/AppliedJobsProvider.dart';

class MyActivity extends StatelessWidget {
  const MyActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final appliedJobs = Provider.of<AppliedJobsProvider>(context).appliedJobs;
    return Scaffold(
      backgroundColor: const Color(0xfff2f4f8),
      appBar: AppBar(
        backgroundColor: const Color(0xfff2f4f8),
        elevation: 0,
        title: const Text(
          "My Activity",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              onPressed: () {},
              icon: const Icon(Icons.share, color: Colors.white, size: 18),
              label: const Text(
                "Share App",
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Image.asset("images/notification1.png", height: 30),
          ),
        ],
      ),
      body: appliedJobs.isEmpty
          ? const Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text(
              "You have not applied to any jobs yet.",
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ))
          : ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: appliedJobs.length,
        itemBuilder: (context, index) {
          final job = appliedJobs[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  job.title,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  job.companyName,
                  style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 13,
                      fontWeight: FontWeight.w400),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.location_on,
                        size: 16, color: Colors.blueAccent),
                    const SizedBox(width: 4),
                    Text(
                      job.workLocation,
                      style: const TextStyle(
                          fontSize: 13, color: Colors.black87),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.currency_rupee,
                        size: 16, color: Colors.blueAccent),
                    const SizedBox(width: 4),
                    Text(
                      "${job.minSalary} - ${job.maxSalary}",
                      style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding:
                          const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: Image.asset(
                          "images/what2.png",
                          height: 20,
                        ),
                        label: const Text(
                          "Chat HR",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () async {
                          final provider =
                          Provider.of<AppliedJobsProvider>(context,
                              listen: false);
                          String result =
                          await provider.applyJob(job.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(result == "success"
                                    ? "Job Applied Successfully"
                                    : result)),
                          );

                          if (result == "success") {
                            provider.setTabIndex(2);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent.shade700,
                          padding:
                          const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        icon: const Icon(Icons.call, color: Colors.white),
                        label: const Text(
                          "Call HR",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () async {
                          final provider =
                          Provider.of<AppliedJobsProvider>(context,
                              listen: false);
                          String result =
                          await provider.applyJob(job.id);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(result == "success"
                                    ? "Job Applied Successfully"
                                    : result)),
                          );

                          if (result == "success") {
                            provider.setTabIndex(2);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}










// Post and get dono hai
// my_activity.dart
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../provider/AppliedJobsProvider.dart';
//
// class MyActivity extends StatefulWidget {
//   final String cookie;
//   final String userId; // ✅ Required for GET API
//
//   const MyActivity({super.key, required this.cookie, required this.userId});
//
//   @override
//   State<MyActivity> createState() => _MyActivityState();
// }
//
// class _MyActivityState extends State<MyActivity> {
//   @override
//   void initState() {
//     super.initState();
//     if (widget.cookie.isNotEmpty && widget.userId.isNotEmpty) {
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         Provider.of<AppliedJobsProvider>(context, listen: false)
//             .fetchAppliedJobs(widget.cookie, widget.userId);
//       });
//     }
//   }
//
//   Future<void> _refreshJobs() async {
//     if (widget.cookie.isNotEmpty && widget.userId.isNotEmpty) {
//       await Provider.of<AppliedJobsProvider>(context, listen: false)
//           .fetchAppliedJobs(widget.cookie, widget.userId);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<AppliedJobsProvider>(
//       builder: (context, provider, _) {
//         final jobs = provider.appliedJobs;
//         final isLoading = provider.isLoading;
//
//         return Scaffold(
//           backgroundColor: const Color(0xfff2f4f8),
//           appBar: AppBar(
//             backgroundColor: const Color(0xfff2f4f8),
//             elevation: 0,
//             title: const Text(
//               "My Activity",
//               style: TextStyle(
//                   color: Colors.black,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 18),
//             ),
//           ),
//           body: isLoading
//               ? const Center(child: CircularProgressIndicator())
//               : RefreshIndicator(
//             onRefresh: _refreshJobs,
//             child: jobs.isEmpty
//                 ? const Center(
//               child: Padding(
//                 padding: EdgeInsets.all(20),
//                 child: Text(
//                   "You have not applied to any jobs yet.",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                       color: Colors.black54, fontSize: 16),
//                 ),
//               ),
//             )
//                 : ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: jobs.length,
//               itemBuilder: (context, index) {
//                 final job = jobs[index];
//                 return Container(
//                   margin: const EdgeInsets.only(bottom: 12),
//                   padding: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                           color: Colors.grey.withOpacity(0.2),
//                           blurRadius: 6,
//                           offset: const Offset(0, 3))
//                     ],
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(job.title,
//                           style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600)),
//                       const SizedBox(height: 4),
//                       Text(job.companyName,
//                           style: const TextStyle(
//                               fontSize: 13, color: Colors.black54)),
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           const Icon(Icons.location_on,
//                               size: 16, color: Colors.blueAccent),
//                           const SizedBox(width: 4),
//                           Text(job.workLocation),
//                         ],
//                       ),
//                       const SizedBox(height: 4),
//                       Row(
//                         children: [
//                           const Icon(Icons.currency_rupee,
//                               size: 16, color: Colors.blueAccent),
//                           const SizedBox(width: 4),
//                           Text("${job.minSalary} - ${job.maxSalary}"),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       Row(
//                         children: [
//                           Expanded(
//                             child: ElevatedButton.icon(
//                               onPressed: () async {
//                                 bool success =
//                                 await provider.applyJob(
//                                   job.id,
//                                   widget.cookie,
//                                   userId: widget.userId,
//                                 );
//
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(
//                                   SnackBar(
//                                     content: Text(success
//                                         ? "Job Applied Successfully"
//                                         : "Failed to apply job"),
//                                   ),
//                                 );
//                               },
//                               icon: const Icon(Icons.message),
//                               label: const Text("Chat HR"),
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green),
//                             ),
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: ElevatedButton.icon(
//                               onPressed: () async {
//                                 bool success =
//                                 await provider.applyJob(
//                                   job.id,
//                                   widget.cookie,
//                                   userId: widget.userId,
//                                 );
//
//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(
//                                   SnackBar(
//                                     content: Text(success
//                                         ? "Job Applied Successfully"
//                                         : "Failed to apply job"),
//                                   ),
//                                 );
//                               },
//                               icon: const Icon(Icons.call),
//                               label: const Text("Call HR"),
//                               style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.green),
//                             ),
//                           ),
//                         ],
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:thenaukrimitra/custom/ViewJobsUser.dart';
//
// class MyActivity extends StatefulWidget {
//   const MyActivity({super.key});
//
//   @override
//   State<MyActivity> createState() => _MyActivityState();
// }
//
// class _MyActivityState extends State<MyActivity> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xfff2f4f8),
//       appBar: AppBar(
//         backgroundColor: const Color(0xfff2f4f8),
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.blue),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text(
//           "My Activity",
//           style: TextStyle(
//             color: Colors.black,
//             fontWeight: FontWeight.w600,
//             fontSize: 18,
//           ),
//         ),
//         actions: [
//
//           Container(
//             margin: const EdgeInsets.only(right: 10),
//             padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//             decoration: BoxDecoration(
//               color: Colors.green,
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: const Row(
//               children: [
//                 Icon(Icons.share, size: 16, color: Colors.white),
//                 SizedBox(width: 5),
//                 Text(
//                   "Share App",
//                   style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 12,
//                       fontWeight: FontWeight.w500),
//                 ),
//               ],
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 10.0),
//             child: Image.asset("images/notification1.png",height: 30,),
//           ),
//           // onPressed: () {},
//
//           // IconButton(
//           //   icon: const Icon(Icons.notifications, color: Colors.blue),
//
//           // ),
//         ],
//       ),
//
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 60),
//
//             // Title
//             const Text(
//               "Welcome To My Activity",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 18,
//               ),
//               textAlign: TextAlign.center,
//             ),
//
//             const SizedBox(height: 10),
//
//             // Subtitle
//             const Text(
//               "You Can View Applied and saved Jobs, Jobs invite and closed jobs in one place.",
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.black54,
//               ),
//               textAlign: TextAlign.center,
//             ),
//
//             const SizedBox(height: 20),
//             Center(
//               child: Image.asset(
//                 "images/mergepic1.png",
//                 height: MediaQuery.of(context).size.height * 0.25,
//                 fit: BoxFit.contain,
//               ),
//             ),
//
//             const SizedBox(height: 5),
//
//             // Button
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 onPressed: () {
//                  Navigator.push(
//                      context, MaterialPageRoute(builder: (context)=>ViewJobsUser()));
//                 },
//                 child: const Text(
//                   "View Jobs",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
