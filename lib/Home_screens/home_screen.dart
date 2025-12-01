import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:thenaukrimitra/Home_screens/video_player_screen.dart';
import 'package:thenaukrimitra/all_job/view_all_job.dart';
import 'package:thenaukrimitra/custom/JobSearch.dart';
import '../all_job/job_full_details.dart';
import '../main_Screen/main_screen.dart';
import '../provider/JobProvider.dart';
class HomeScreen extends StatefulWidget {
  final String title;
  final String image;
  final String fullName;
  final String gender;
  final String education;
  final String workExperience;
  final String salary;
  final File? imageFile;
  final List<String> skills;
  const HomeScreen({super.key,
    required this.title,
    required this.image,
    required this.fullName,
    required this.gender,
    required this.education,
    required this.workExperience,
    required this.salary,
    required this.imageFile,
    required this.skills,


  });
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<JobProvider>().fetchJobs());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

        return false;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFE7EAF6),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).padding.bottom + 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      // child: Row(
                      //   children: const [
                      //     Icon(Icons.location_on, color: Colors.blue),
                      //     SizedBox(width: 5),
                      //     Text(
                      //       "Noida\nSector 62",
                      //       style: TextStyle(
                      //           fontWeight: FontWeight.w500, fontSize: 13),
                      //     ),
                      //   ],
                      // ),
                      child: Row(
                        children: const [
                          Icon(Icons.location_on, color: Colors.blue),
                          SizedBox(width: 5),
                          Text(
                            "Noida\nSector 62",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        const Image(
                          image: AssetImage('images/logo3.png'),
                          height: 35,
                        ),
                        const SizedBox(width: 90),
                        Image.asset(
                          'images/arrow2.png',
                          height: 25,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 5),
                        Padding(
                          padding: const EdgeInsets.only(right: 12.0),
                          child: Image.asset(
                            'images/notification1.png',
                            height: 25,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 5),
      
                // 🔍 Search Box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF8E9EFD), Color(0xFF4A64FE)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search Job",
                      hintStyle:
                      const TextStyle(color: Colors.white, fontSize: 18),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          context
                              .read<JobProvider>()
                              .searchJobs(_searchController.text.trim());
                        },
                      ),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.white),
                    onChanged: (value) {
                      context.read<JobProvider>().searchJobs(value);
                    },
                  ),
                ),
      
                const SizedBox(height: 20),
      
                // 📝 Apply to these jobs
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 12.0),
                      child: Text(
                        "Apply to these jobs",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MainScreen(
                                initialIndex: 1,
                              //   title: widget.title,
                              //   image: widget.image,
                              //   fullName: widget.fullName,
                              //   gender: widget.gender,
                              //   education: widget.education,
                              //   workExperience: widget.workExperience,
                              //   salary: widget.salary,
                              //   imageFile: widget.imageFile,
                              //   skills: const [],
                              // ),
                                title: "",
                                image: "",
                                fullName: "fullName",
                                gender: "",
                                education: "",
                                workExperience: "",
                                salary: "",
                                imageFile: null,
                                skills: const [],
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "View All",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),


                Consumer<JobProvider>(
                  builder: (context, jobProvider, child) {
                    if (jobProvider.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (jobProvider.jobs.isEmpty) {
                      return const Center(child: Text("No jobs found"));
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: jobProvider.jobs.length,
                      itemBuilder: (context, index) {
                        final job = jobProvider.jobs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => JobFullDetails(job: job),
                              ),
                            );
                          },
                          child: _buildJobCard(
                            title: job.title,
                            company: job.companyName,
                            location: job.workLocation,
                            salary: (job.minSalary > 0 && job.maxSalary > 0)
                                ? "${job.minSalary} - ${job.maxSalary}"
                                : job.salaryType,
                            isUrgent: true,
                          ),
                        );
                      },
                    );
                  },
                ),



                //
                // Consumer<JobProvider>(
                //   builder: (context, jobProvider, child) {
                //     if (jobProvider.isLoading) {
                //       return const Center(child: CircularProgressIndicator());
                //     }
                //     if (jobProvider.jobs.isEmpty) {
                //       return const Center(child: Text("No jobs found"));
                //     }
                //     return ListView.builder(
                //       shrinkWrap: true,
                //       physics: const NeverScrollableScrollPhysics(),
                //       itemCount: jobProvider.jobs.length,
                //       itemBuilder: (context, index) {
                //         final job = jobProvider.jobs[index];
                //         return GestureDetector(
                //           onTap: () {
                //             Navigator.push(
                //               context,
                //               MaterialPageRoute(
                //                 builder: (_) => JobFullDetails(job: job),
                //               ),
                //             );
                //           },
                //           child: _buildJobCard(
                //             title: job.title,
                //             company: job.companyName,
                //             location: job.workLocation,
                //             salary: "${job.minSalary} - ${job.maxSalary}",
                //             isUrgent: true,
                //           ),
                //         );
                //       },
                //     );
                //   },
                // ),

                //
      
                // Job List
                // _buildJobCard(
                //   title: "PHP Laravel Developer",
                //   company: "Techuweb pvt ltd",
                //   location: "Noida, Sector 63",
                //   salary: " 10000 - 150000",
                //   isUrgent: true,
                // ),
                // _buildJobCard(
                //   title: "Backend Developer",
                //   company: "Techuweb pvt ltd",
                //   location: "Noida, Sector 63",
                //   salary: "10000 - 150000",
                //   isUrgent: true,
                // ),
      

                const SizedBox(height: 20),
      
      

                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text(
                    "Near by Jobs",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(width: 3,),
                SizedBox(
                  height: 100,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    children: [
                      _buildNearbyJobCard("Sector 63 - Noida", "0.5 km", "10 Jobs"),
                      _buildNearbyJobCard("Ashok - Delhi", "0.5 km", "10 Jobs"),
                      _buildNearbyJobCard("Sector 63 - Noida", "0.5 km", "10 Jobs"),
                      _buildNearbyJobCard("Sector 63 - Noida", "0.5 km", "10 Jobs"),
                      _buildNearbyJobCard("Ashok - Delhi", "0.5 km", "10 Jobs"),
                      _buildNearbyJobCard("Sector 63 - Noida", "0.5 km", "10 Jobs"),
                    ],
                  ),
                ),
      
                // Learn from video
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text(
                    "Learn from video",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: SizedBox(
                    height: 200,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildVideoCard(context, "Interview Question", "videos/ads.mp4"),
                        _buildVideoCard(context, "Another Video", "videos/ads.mp4"),
                        _buildVideoCard(context, "Interview Question", "videos/ads.mp4"),
                        _buildVideoCard(context, "Another Video", "videos/ads.mp4"),
                      ],
                    ),
                  ),
                ),
                // All Jobs
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: const Text(
                    "Jobs Categories",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                  child: GridView.count(
                    shrinkWrap: true, // <-- important
                    physics: const NeverScrollableScrollPhysics(), // <-- important
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    children: [
                      _buildCategoryCard("Delivery,", "images/man.jpg"),
                      _buildCategoryCard("Hospitality", "images/man.jpg"),
                      _buildCategoryCard("Receptionist", "images/man.jpg"),
                    ],
                  ),
                ),
      
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0,),
                  child: const Text(
                    "All Jobs",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildAllJobsCard("Part Time ", "200 jobs View", Icons.access_time),
                      _buildAllJobsCard("New Jobs", "200 jobs View", Icons.notifications),
                      _buildAllJobsCard("Within 5 km", "200 jobs View", Icons.location_on),
                    ],
      
                  ),
                ),
                SizedBox(height: 15,),
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAllJobsCard("Part Time ", "200 jobs View", Icons.access_time),
                      _buildAllJobsCard("Within 5 km", "200 jobs View", Icons.location_on),
                      _buildAllJobsCard("Within 5 km", "200 jobs View", Icons.location_on),
                    ],
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  height: 150,
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 1))],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "Your experience of job search on  The NaukriMitra?",
                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
                  ),
                ),
                SizedBox(height: 15,),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 5,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Lottie.asset(
                        'animations/chat1.json',
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Chat With us",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      const Text(
                        "Any Time",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      
      
      ),
    );
  }

  // Job Card Widget
  Widget _buildJobCard({
    required String title,
    required String company,
    required String location,
    required String salary,
    bool isUrgent = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
      child: Card(

        color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title + Urgent
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                  if (isUrgent)
                    Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "Urgent Hiring",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 10),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(company, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined,
                      size: 16, color: Colors.blue),
                  const SizedBox(width: 5),
                  Text(location),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.currency_rupee,
                      size: 16, color: Colors.blue),
                  Text(salary),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  _buildTag("New Job", Colors.orange),
                  const SizedBox(width: 20),
                  _buildTag("10 Vacancies", Colors.deepOrange),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  // Tag Chip
  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 10, fontWeight: FontWeight.w500, color: color),
      ),
    );
  }
}
// Near By Jobs
Widget _buildNearbyJobCard(String location, String distance, String jobs) {
  return Container(
    width: 150 ,
    margin: const EdgeInsets.only(right: 1,left: 15),
    padding: const EdgeInsets.all(6),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.blue),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(location, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(distance, style: const TextStyle(color: Colors.grey)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Spacer(),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                jobs,
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildCategoryCard(String title, String imagePath) {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.blueAccent,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 1),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath, height: 60),
        const SizedBox(height: 6),
        Text(title, style: const TextStyle(fontSize: 12)),
      ],
    ),
  );
}
// Video widget
Widget _buildVideoCard(BuildContext context, String title, String videoPath) {
  return Container(
    width: 120,
    margin: const EdgeInsets.only(right: 10),
    child: Column(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>  VideoPlayerScreen(
                  videoPath: videoPath,
                  title: title,
                ),
              ),
            );
          },
          child: Container(
            height: 170,
            width: 120,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.play_circle_fill,
                color: Colors.blue, size: 40),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
        ),
      ],
    ),
  );
}
Widget _buildAllJobsCard(String title, String subtitle, IconData icon) {
  return Expanded(
    child: Container(
      width: 130,
      margin: EdgeInsets.only(left: 15),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 30),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle, style: const TextStyle(fontSize: 12)),
        ],
      ),
    ),
  );
}



// correct and working all job show and job Search
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:lottie/lottie.dart';
// import 'package:provider/provider.dart';
// import 'package:thenaukrimitra/Home_screens/video_player_screen.dart';
// import 'package:thenaukrimitra/all_job/view_all_job.dart';
//
// import '../provider/JobProvider.dart';
// class HomeScreen extends StatefulWidget {
//   final String title;
//   final String image;
//   final String fullName;
//   final String gender;
//   final String education;
//   final String workExperience;
//   final String salary;
//   final File? imageFile;
//   final List<String> skills;
//   const HomeScreen({super.key,
//     required this.title,
//     required this.image,
//     required this.fullName,
//     required this.gender,
//     required this.education,
//     required this.workExperience,
//     required this.salary,
//     required this.imageFile,
//     required this.skills,
//
//
//   });
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
// class _HomeScreenState extends State<HomeScreen> {
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     // Page load hote hi jobs fetch
//     Future.microtask(() =>
//         context.read<JobProvider>().fetchJobs());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE7EAF6),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).padding.bottom + 60),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🔝 Top Bar
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: const [
//                         Icon(Icons.location_on, color: Colors.blue),
//                         SizedBox(width: 5),
//                         Text(
//                           "Noida\nSector 62",
//                           style: TextStyle(
//                               fontWeight: FontWeight.w500, fontSize: 13),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       const Image(
//                         image: AssetImage('images/logo3.png'),
//                         height: 35,
//                       ),
//                       const SizedBox(width: 90),
//                       Image.asset(
//                         'images/arrow2.png',
//                         height: 25,
//                         color: Colors.blue,
//                       ),
//                       const SizedBox(width: 5),
//                       Padding(
//                         padding: const EdgeInsets.only(right: 12.0),
//                         child: Image.asset(
//                           'images/notification1.png',
//                           height: 25,
//                           color: Colors.blue,
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               const SizedBox(height: 5),
//
//               // 🔍 Search Box
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 20),
//                 margin: const EdgeInsets.symmetric(horizontal: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF8E9EFD), Color(0xFF4A64FE)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     hintText: "Search Job",
//                     hintStyle:
//                     const TextStyle(color: Colors.white, fontSize: 18),
//                     suffixIcon: IconButton(
//                       icon: const Icon(Icons.search, color: Colors.white),
//                       onPressed: () {
//                         context
//                             .read<JobProvider>()
//                             .searchJobs(_searchController.text.trim());
//                       },
//                     ),
//                     border: InputBorder.none,
//                   ),
//                   style: const TextStyle(color: Colors.white),
//                   onChanged: (value) {
//                     context.read<JobProvider>().searchJobs(value);
//                   },
//                 ),
//               ),
//
//               const SizedBox(height: 20),
//
//               // 📝 Apply to these jobs
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.only(left: 12.0),
//                     child: Text(
//                       "Apply to these jobs",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(right: 12.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                               builder: (context) => ViewAllJob()),
//                         );
//                       },
//                       child: Text(
//                         "View All",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 10),
//
//               // 📋 Jobs List
//               Consumer<JobProvider>(
//                 builder: (context, jobProvider, child) {
//                   if (jobProvider.isLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   if (jobProvider.jobs.isEmpty) {
//                     return const Center(child: Text("No jobs found"));
//                   }
//                   return ListView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     itemCount: jobProvider.jobs.length,
//                     itemBuilder: (context, index) {
//                       final job = jobProvider.jobs[index];
//                       return _buildJobCard(
//                         title: job.title,
//                         company: job.companyName,
//                         location: job.workLocation,
//                         salary: "${job.minSalary} - ${job.maxSalary}",
//                         isUrgent: false,
//                       );
//                     },
//                   );
//                 },
//               ),
//
//
//               // Job List
//               _buildJobCard(
//                 title: "PHP Laravel Developer",
//                 company: "Techuweb pvt ltd",
//                 location: "Noida, Sector 63",
//                 salary: " 10000 - 150000",
//                 isUrgent: true,
//               ),
//               _buildJobCard(
//                 title: "Backend Developer",
//                 company: "Techuweb pvt ltd",
//                 location: "Noida, Sector 63",
//                 salary: "10000 - 150000",
//                 isUrgent: true,
//               ),
//
//
//               // After the last _buildJobCard(...)
//               const SizedBox(height: 20),
//
//
//               // Near by Jobs Section
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: const Text(
//                   "Near by Jobs",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(width: 3,),
//               SizedBox(
//                 height: 100,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   physics: const BouncingScrollPhysics(),
//                   children: [
//                     _buildNearbyJobCard("Sector 63 - Noida", "0.5 km", "10 Jobs"),
//                     _buildNearbyJobCard("Ashok - Delhi", "0.5 km", "10 Jobs"),
//                     _buildNearbyJobCard("Sector 63 - Noida", "0.5 km", "10 Jobs"),
//                     _buildNearbyJobCard("Sector 63 - Noida", "0.5 km", "10 Jobs"),
//                     _buildNearbyJobCard("Ashok - Delhi", "0.5 km", "10 Jobs"),
//                     _buildNearbyJobCard("Sector 63 - Noida", "0.5 km", "10 Jobs"),
//                   ],
//                 ),
//               ),
//
//               // Learn from video
//               const SizedBox(height: 15),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: const Text(
//                   "Learn from video",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.blue),
//                 ),
//               ),
//               const SizedBox(height: 5),
//               Padding(
//                 padding: const EdgeInsets.only(left: 10.0),
//                 child: SizedBox(
//                   height: 200,
//                   child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     children: [
//                       _buildVideoCard(context, "Interview Question", "videos/ads.mp4"),
//                       _buildVideoCard(context, "Another Video", "videos/ads.mp4"),
//                       _buildVideoCard(context, "Interview Question", "videos/ads.mp4"),
//                       _buildVideoCard(context, "Another Video", "videos/ads.mp4"),
//                     ],
//                   ),
//                 ),
//               ),
//               // All Jobs
//               const SizedBox(height: 15),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: const Text(
//                   "Jobs Categories",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0,right: 8.0),
//                 child: GridView.count(
//                   shrinkWrap: true, // <-- important
//                   physics: const NeverScrollableScrollPhysics(), // <-- important
//                   crossAxisCount: 3,
//                   mainAxisSpacing: 8,
//                   crossAxisSpacing: 8,
//                   children: [
//                     _buildCategoryCard("Delivery,", "images/man.jpg"),
//                     _buildCategoryCard("Hospitality", "images/man.jpg"),
//                     _buildCategoryCard("Receptionist", "images/man.jpg"),
//                   ],
//                 ),
//               ),
//
//               SizedBox(height: 10,),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0,),
//                 child: const Text(
//                   "All Jobs",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.blue),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Padding(
//                 padding: const EdgeInsets.only(right: 10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     _buildAllJobsCard("Part Time ", "200 jobs View", Icons.access_time),
//                     _buildAllJobsCard("New Jobs", "200 jobs View", Icons.notifications),
//                     _buildAllJobsCard("Within 5 km", "200 jobs View", Icons.location_on),
//                   ],
//
//                 ),
//               ),
//               SizedBox(height: 15,),
//               Padding(
//                 padding: const EdgeInsets.only(right: 10.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildAllJobsCard("Part Time ", "200 jobs View", Icons.access_time),
//                     _buildAllJobsCard("Within 5 km", "200 jobs View", Icons.location_on),
//                     _buildAllJobsCard("Within 5 km", "200 jobs View", Icons.location_on),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 15,),
//               Container(
//                 height: 150,
//                 width: double.infinity,
//                 margin: EdgeInsets.all(10),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 1))],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Text(
//                   "Your experience of job search on  The NaukriMitra?",
//                   style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
//                 ),
//               ),
//               SizedBox(height: 15,),
//               Container(
//                 width: double.infinity,
//                 margin: EdgeInsets.all(10),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Colors.blue, Colors.blueAccent],
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey,
//                       blurRadius: 5,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Lottie.asset(
//                       'animations/chat1.json',
//                       height: 100,
//                       width: 100,
//                       fit: BoxFit.cover,
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Chat With us",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                     const Text(
//                       "Any Time",
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//
//     );
//   }
//
//   // Job Card Widget
//   Widget _buildJobCard({
//     required String title,
//     required String company,
//     required String location,
//     required String salary,
//     bool isUrgent = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8.0,right: 8.0),
//       child: Card(
//
//         color: Colors.white,
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         elevation: 4,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title + Urgent
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(title,
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold)),
//                   if (isUrgent)
//                     Container(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade100,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Text(
//                         "Urgent Hiring",
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 10),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Text(company, style: const TextStyle(color: Colors.black54)),
//               const SizedBox(height: 6),
//               Row(
//                 children: [
//                   const Icon(Icons.location_on_outlined,
//                       size: 16, color: Colors.blue),
//                   const SizedBox(width: 5),
//                   Text(location),
//                 ],
//               ),
//               const SizedBox(height: 6),
//               Row(
//                 children: [
//                   const Icon(Icons.currency_rupee,
//                       size: 16, color: Colors.blue),
//                   Text(salary),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   _buildTag("New Job", Colors.orange),
//                   const SizedBox(width: 20),
//                   _buildTag("10 Vacancies", Colors.deepOrange),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Tag Chip
//   Widget _buildTag(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//             fontSize: 10, fontWeight: FontWeight.w500, color: color),
//       ),
//     );
//   }
// }
// // Near By Jobs
// Widget _buildNearbyJobCard(String location, String distance, String jobs) {
//   return Container(
//     width: 150 ,
//     margin: const EdgeInsets.only(right: 1,left: 15),
//     padding: const EdgeInsets.all(6),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(8),
//       border: Border.all(color: Colors.blue),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(location, style: const TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 6),
//         Text(distance, style: const TextStyle(color: Colors.grey)),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const Spacer(),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Text(
//                 jobs,
//                 style: const TextStyle(color: Colors.white, fontSize: 12),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _buildCategoryCard(String title, String imagePath) {
//   return Container(
//     padding: const EdgeInsets.all(8),
//     decoration: BoxDecoration(
//       color: Colors.blueAccent,
//       borderRadius: BorderRadius.circular(8),
//       boxShadow: [
//         BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 1),
//       ],
//     ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(imagePath, height: 60),
//         const SizedBox(height: 6),
//         Text(title, style: const TextStyle(fontSize: 12)),
//       ],
//     ),
//   );
// }
// // Video widget
// Widget _buildVideoCard(BuildContext context, String title, String videoPath) {
//   return Container(
//     width: 120,
//     margin: const EdgeInsets.only(right: 10),
//     child: Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) =>  VideoPlayerScreen(
//                   videoPath: videoPath,
//                   title: title,
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             height: 170,
//             width: 120,
//             decoration: BoxDecoration(
//               color: Colors.black12,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(Icons.play_circle_fill,
//                 color: Colors.blue, size: 40),
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           title,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
//         ),
//       ],
//     ),
//   );
// }
// Widget _buildAllJobsCard(String title, String subtitle, IconData icon) {
//   return Expanded(
//     child: Container(
//       width: 130,
//       margin: EdgeInsets.only(left: 15),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: Colors.blue, size: 30),
//           const SizedBox(height: 5),
//           Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(subtitle, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     ),
//   );
// }









// bina data bheje Home page hai
//
// import 'package:flutter/material.dart';
// import 'package:lottie/lottie.dart';
// import 'package:thenaukrimitra/Home_screens/video_player_screen.dart';
// import 'package:thenaukrimitra/all_job/view_all_job.dart';
// import 'package:thenaukrimitra/custom/JobSearch.dart';
// import 'package:thenaukrimitra/custom/ProfileScreen.dart';
// import 'package:thenaukrimitra/custom/custom_buttom_nav.dart';
//
// import '../custom/VideoScreen.dart';
// import '../custom/myActivity.dart';
//
// class HomeScreen extends StatefulWidget {
//
//   const HomeScreen({super.key});
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
// class _HomeScreenState extends State<HomeScreen> {
//   int _selectedIndex = 0;
//   final List<Widget> _screens =  [
//     const HomeScreen(),
//     const JobSearch(),
//     MyActivity(),
//     VideoScreen(),
//     const ProfileScreen(),
//   ];
//   void _onBottomNavTap(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE7EAF6),
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 60),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Top Bar
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Row(
//                       children: const [
//                         Icon(Icons.location_on, color: Colors.blue),
//                         SizedBox(width: 5),
//                         Text(
//                           "Noida\nSector 62",
//                           style: TextStyle(fontWeight: FontWeight.w500,fontSize: 13),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       const Image(
//                         image: AssetImage('images/logo3.png'),
//                         height: 35,
//                       ),
//                       const SizedBox(width: 90),
//
//                       // Arrow icon as image
//                       Image.asset(
//                         'images/arrow2.png', // replace with your arrow image
//                         height: 25,
//                         color: Colors.blue, // optional tint
//                       ),
//
//                       const SizedBox(width: 5),
//                       // Notification icon as image
//                       Padding(
//                         padding: const EdgeInsets.only(right: 12.0),
//                         child: Image.asset(
//                           'images/notification1.png', // replace with your notification image
//                           height: 25,
//                           color: Colors.blue, // optional tint
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//               const SizedBox(height: 5),
//
//               // Search Box
//               Container(
//                 padding: EdgeInsets.only(left: 20,right: 20),
//                 margin: EdgeInsets.only(right: 10,left: 10),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8),
//                   gradient: const LinearGradient(
//                     colors: [Color(0xFF8E9EFD), Color(0xFF4A64FE)],
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                   ),
//                 ),
//                 child: const TextField(
//                   decoration: InputDecoration(
//                     hintText: "Search Job",
//                     hintStyle: TextStyle(color: Colors.white,fontSize: 18),
//                     suffixIcon: Icon(Icons.search, color: Colors.white),
//                     border: InputBorder.none,
//                   ),
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // Apply to these jobs
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Padding(
//                     padding: EdgeInsets.only(left: 12.0),
//                     child: Text(
//                       "Apply to these jobs",
//                       style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(right: 12.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (context) => ViewAllJob()),
//                         );
//                       },
//                       child: Text(
//                         "View All",
//                         style: TextStyle(
//                           color: Colors.blue,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//
//                 ],
//               ),
//
//               const SizedBox(height: 10),
//
//               // Job List
//               _buildJobCard(
//                 title: "PHP Laravel Developer",
//                 company: "Techuweb pvt ltd",
//                 location: "Noida, Sector 63",
//                 salary: " 10000 - 150000",
//                 isUrgent: true,
//               ),
//               _buildJobCard(
//                 title: "Backend Developer",
//                 company: "Techuweb pvt ltd",
//                 location: "Noida, Sector 63",
//                 salary: "10000 - 150000",
//                 isUrgent: true,
//               ),
//               _buildJobCard(
//                 title: "Backend Developer",
//                 company: "Techuweb pvt ltd",
//                 location: "Noida, Sector 63",
//                 salary: " 10000 - 150000",
//                 isUrgent: true,
//               ),
//               _buildJobCard(
//                 title: "Backend Developer",
//                 company: "Techuweb pvt ltd",
//                 location: "Noida, Sector 63",
//                 salary: " 10000 - 150000",
//                 isUrgent: true,
//               ),
//               // After the last _buildJobCard(...)
//               const SizedBox(height: 20),
//
//
//               // Near by Jobs Section
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: const Text(
//                   "Near by Jobs",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               SizedBox(
//                 height: 100,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   physics: const BouncingScrollPhysics(),
//                   children: [
//                     _buildNearbyJobCard("Sector 63 - Noida", "0.5 km", "10 Jobs"),
//                     _buildNearbyJobCard("Ashok - Delhi", "0.5 km", "10 Jobs"),
//                     _buildNearbyJobCard("Sector 63 - Noida", "0.5 km", "10 Jobs"),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Jobs Categories Section
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: const Text(
//                   "Jobs Categories",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               GridView.count(
//                 shrinkWrap: true, // <-- important
//                 physics: const NeverScrollableScrollPhysics(), // <-- important
//                 crossAxisCount: 3,
//                 mainAxisSpacing: 8,
//                 crossAxisSpacing: 8,
//                 children: [
//                   _buildCategoryCard("Delivery,", "images/man.jpg"),
//                   _buildCategoryCard("Hospitality", "images/man.jpg"),
//                   _buildCategoryCard("Receptionist", "images/man.jpg"),
//                 ],
//               ),
//               SizedBox(height: 20,),
//               // Learn from video
//               const SizedBox(height: 15),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: const Text(
//                   "Learn from video",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.blue),
//                 ),
//               ),
//               const SizedBox(height: 5),
//               SizedBox(
//                 height: 200,
//                 child: ListView(
//                   scrollDirection: Axis.horizontal,
//                   children: [
//                     _buildVideoCard(context, "Interview Question", "videos/ads.mp4"),
//                     _buildVideoCard(context, "Another Video", "videos/ads.mp4"),
//                     _buildVideoCard(context, "Interview Question", "videos/ads.mp4"),
//                     _buildVideoCard(context, "Another Video", "videos/ads.mp4"),
//                   ],
//                 ),
//               ),
//               // All Jobs
//               const SizedBox(height: 15),
//               Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: const Text(
//                   "All Jobs",
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16,color: Colors.blue),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   _buildAllJobsCard("Part Time ", "200 jobs View", Icons.access_time),
//                   _buildAllJobsCard("New Jobs", "200 jobs View", Icons.notifications),
//                   _buildAllJobsCard("Within 5 km", "200 jobs View", Icons.location_on),
//                 ],
//
//               ),
//               SizedBox(height: 15,),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildAllJobsCard("Part Time ", "200 jobs View", Icons.access_time),
//                   _buildAllJobsCard("Within 5 km", "200 jobs View", Icons.location_on),
//                   _buildAllJobsCard("Within 5 km", "200 jobs View", Icons.location_on),
//                 ],
//               ),
//               SizedBox(height: 15,),
//               Container(
//                 height: 150,
//                 width: double.infinity,
//                 margin: EdgeInsets.all(10),
//                 padding: const EdgeInsets.all(20),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 5, offset: Offset(0, 1))],
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Text(
//                   "Your experience of job search on  The NaukriMitra?",
//                   style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),
//                 ),
//               ),
//               SizedBox(height: 15,),
//               Container(
//                 width: double.infinity,
//                 margin: EdgeInsets.all(10),
//                 padding: const EdgeInsets.all(16),
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     colors: [Colors.blue, Colors.blueAccent],
//                   ),
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey,
//                       blurRadius: 5,
//                       offset: Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Lottie.asset(
//                       'animations/chat1.json',
//                       height: 100,
//                       width: 100,
//                       fit: BoxFit.cover,
//                     ),
//                     const SizedBox(height: 8),
//                     const Text(
//                       "Chat With us",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 20,
//                       ),
//                     ),
//                     const Text(
//                       "Any Time",
//                       style: TextStyle(color: Colors.white70),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//
//       // Bottom Navigation Bar
//       bottomNavigationBar: CustomBottomNav(
//         currentIndex: _selectedIndex,
//         onTap: _onBottomNavTap,
//       ),
//     );
//   }
//
//   // Job Card Widget
//   Widget _buildJobCard({
//     required String title,
//     required String company,
//     required String location,
//     required String salary,
//     bool isUrgent = false,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 8.0,right: 8.0),
//       child: Card(
//
//         color: Colors.white,
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         elevation: 4,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Title + Urgent
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(title,
//                       style: const TextStyle(
//                           fontSize: 16, fontWeight: FontWeight.bold)),
//                   if (isUrgent)
//                     Container(
//                       padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//                       decoration: BoxDecoration(
//                         color: Colors.blue.shade100,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: const Text(
//                         "Urgent Hiring",
//                         style: TextStyle(
//                             color: Colors.black,
//                             fontWeight: FontWeight.w600,
//                             fontSize: 10),
//                       ),
//                     ),
//                 ],
//               ),
//               const SizedBox(height: 4),
//               Text(company, style: const TextStyle(color: Colors.black54)),
//               const SizedBox(height: 6),
//               Row(
//                 children: [
//                   const Icon(Icons.location_on_outlined,
//                       size: 16, color: Colors.blue),
//                   const SizedBox(width: 5),
//                   Text(location),
//                 ],
//               ),
//               const SizedBox(height: 6),
//               Row(
//                 children: [
//                   const Icon(Icons.currency_rupee,
//                       size: 16, color: Colors.blue),
//                   Text(salary),
//                 ],
//               ),
//               const SizedBox(height: 10),
//               Row(
//                 children: [
//                   _buildTag("New Job", Colors.orange),
//                   const SizedBox(width: 20),
//                   _buildTag("10 Vacancies", Colors.deepOrange),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // Tag Chip
//   Widget _buildTag(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.2),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(
//             fontSize: 10, fontWeight: FontWeight.w500, color: color),
//       ),
//     );
//   }
// }
// // Near By Jobs
// Widget _buildNearbyJobCard(String location, String distance, String jobs) {
//   return Container(
//     width: 150,
//     margin: const EdgeInsets.only(right: 1,left: 15),
//     padding: const EdgeInsets.all(8),
//     decoration: BoxDecoration(
//       color: Colors.white,
//
//       borderRadius: BorderRadius.circular(8),
//       border: Border.all(color: Colors.blue),
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(location, style: const TextStyle(fontWeight: FontWeight.bold)),
//         const SizedBox(height: 4),
//         Text(distance, style: const TextStyle(color: Colors.grey)),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             const Spacer(),
//           ],
//         ),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 borderRadius: BorderRadius.circular(6),
//               ),
//               child: Text(
//                 jobs,
//                 style: const TextStyle(color: Colors.white, fontSize: 12),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// Widget _buildCategoryCard(String title, String imagePath) {
//   return Container(
//     padding: const EdgeInsets.all(8),
//     decoration: BoxDecoration(
//       color: Colors.blueAccent,
//       borderRadius: BorderRadius.circular(8),
//       boxShadow: [
//         BoxShadow(color: Colors.grey.shade300, blurRadius: 4, spreadRadius: 1),
//       ],
//     ),
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Image.asset(imagePath, height: 60),
//         const SizedBox(height: 6),
//         Text(title, style: const TextStyle(fontSize: 12)),
//       ],
//     ),
//   );
// }
//
//
//
//
// // Video widget
// Widget _buildVideoCard(BuildContext context, String title, String videoPath) {
//   return Container(
//     width: 120,
//     margin: const EdgeInsets.only(right: 10),
//     child: Column(
//       children: [
//         GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) =>  VideoPlayerScreen(
//                   videoPath: videoPath,
//                   title: title,
//                 ),
//               ),
//             );
//           },
//           child: Container(
//             height: 170,
//             width: 120,
//             decoration: BoxDecoration(
//               color: Colors.black12,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(Icons.play_circle_fill,
//                 color: Colors.blue, size: 40),
//           ),
//         ),
//         const SizedBox(height: 5),
//         Text(
//           title,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
//         ),
//       ],
//     ),
//   );
// }
// Widget _buildAllJobsCard(String title, String subtitle, IconData icon) {
//   return Expanded(
//     child: Container(
//       width: 130,
//       margin: EdgeInsets.only(left: 15),
//       padding: const EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(8),
//         boxShadow: [
//           BoxShadow(color: Colors.grey.shade300, blurRadius: 4),
//         ],
//       ),
//       child: Column(
//         children: [
//           Icon(icon, color: Colors.blue, size: 30),
//           const SizedBox(height: 5),
//           Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//           Text(subtitle, style: const TextStyle(fontSize: 12)),
//         ],
//       ),
//     ),
//   );
// }
//
//
//








