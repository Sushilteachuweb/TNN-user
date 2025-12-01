import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thenaukrimitra/all_job/job_full_details.dart';
import 'package:thenaukrimitra/filter/filter_row.dart';


import '../model/JobModel.dart';
import '../provider/JobProvider.dart';

class JobSearch extends StatefulWidget {
  final List<JobModel> jobs;
  const JobSearch({super.key, required this.jobs});

  @override
  State<JobSearch> createState() => _JobSearchState();
}
class _JobSearchState extends State<JobSearch> {
  TextEditingController searchController = TextEditingController();
  List<JobModel> filteredJobs = [];
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<JobProvider>(context, listen: false);
      provider.fetchJobs().then((_) {
        setState(() {
          filteredJobs = provider.jobs;
        });
      });
    });
  }

  void _filterJobs(String query, List<JobModel> allJobs) {
    if (query.isEmpty) {
      setState(() {
        filteredJobs = allJobs;
      });
    } else {
      setState(() {
        filteredJobs = allJobs
            .where((job) =>
        job.title.toLowerCase().contains(query.toLowerCase()) ||
            job.companyName.toLowerCase().contains(query.toLowerCase()) ||
            job.workLocation.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = Provider.of<JobProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFE7EAF6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 12),
              _buildSearchBar(jobProvider.jobs),
              const SizedBox(height: 12),
              const FilterRow(),
              const SizedBox(height: 8),

              // ---------------- API Job List ----------------
              Expanded(
                child: filteredJobs.isEmpty
                    ? const Center(child: Text("No jobs available"))
                    : ListView.builder(
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = filteredJobs[index];
                    return _buildJobCard(context, job);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // ---------------- HEADER ----------------
  Widget _buildHeader() {
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.blue),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Noida",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              "Sector 62",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
        ),
        const Spacer(),
        Image.asset(
          "images/logo3.png",
          height: 30,
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 8.0),
          child: Image.asset(
            'images/arrow2.png',
            height: 25,
          ),
        ),
      ],
    );
  }

  // ---------------- SEARCH BAR ----------------
  Widget _buildSearchBar(List<JobModel> allJobs) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: const LinearGradient(
          colors: [Color(0xFF8E9EFD), Color(0xFF4A64FE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) => _filterJobs(value, allJobs), // 🔹 filter call
        decoration: const InputDecoration(
          hintText: "Search Job",
          hintStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(Icons.search, color: Colors.white),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  // ---------------- JOB CARD ----------------
  Widget _buildJobCard(BuildContext context, JobModel job) {
    return GestureDetector(
      onTap: () {
        // ✅ Pass full JobModel object
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => JobFullDetails(job: job),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (job.jobType.toLowerCase().contains("urgent"))
                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "Urgent Hiring",
                      style: TextStyle(color: Colors.blue, fontSize: 10),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 4),
            Text(job.companyName, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.location_on, size: 14, color: Colors.blue),
                const SizedBox(width: 4),
                Text(job.workLocation, style: const TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "₹${job.minSalary} - ₹${job.maxSalary}",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _buildTag("New Job", Colors.orange),
                const SizedBox(width: 6),
                _buildTag("Vacancies: ${job.vacancies}", Colors.orange),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, color: color),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:thenaukrimitra/all_job/job_full_details.dart';
// import 'package:thenaukrimitra/filter/filter_row.dart';
//
//
// import '../ model/JobModel.dart';
// import '../provider/JobProvider.dart';
//
// class JobSearch extends StatefulWidget {
//   final List<JobModel> jobs;
//   const JobSearch({super.key, required this.jobs});
//
//   @override
//   State<JobSearch> createState() => _JobSearchState();
// }
//
// class _JobSearchState extends State<JobSearch> {
//   TextEditingController searchController = TextEditingController();
//   List<JobModel> filteredJobs = [];
//
//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(() {
//       final provider = Provider.of<JobProvider>(context, listen: false);
//       provider.fetchJobs().then((_) {
//         setState(() {
//           filteredJobs = provider.jobs;
//         });
//       });
//     });
//   }
//
//   void _filterJobs(String query, List<JobModel> allJobs) {
//     if (query.isEmpty) {
//       setState(() {
//         filteredJobs = allJobs;
//       });
//     } else {
//       setState(() {
//         filteredJobs = allJobs
//             .where((job) =>
//         job.title.toLowerCase().contains(query.toLowerCase()) ||
//             job.companyName.toLowerCase().contains(query.toLowerCase()) ||
//             job.workLocation.toLowerCase().contains(query.toLowerCase()))
//             .toList();
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final jobProvider = Provider.of<JobProvider>(context);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFE7EAF6),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               const SizedBox(height: 12),
//               _buildSearchBar(jobProvider.jobs),
//               const SizedBox(height: 12),
//               const FilterRow(),
//               const SizedBox(height: 8),
//
//               // ---------------- API Job List ----------------
//               Expanded(
//                 child: filteredJobs.isEmpty
//                     ? const Center(child: Text("No jobs available"))
//                     : ListView.builder(
//                   itemCount: filteredJobs.length,
//                   itemBuilder: (context, index) {
//                     final job = filteredJobs[index];
//                     return _buildJobCard(
//                       context,
//                       title: job.title,
//                       company: job.companyName,
//                       location: job.workLocation,
//                       salary: "₹${job.minSalary} - ₹${job.maxSalary}",
//                       urgent: job.jobType.toLowerCase().contains("urgent"),
//                       vacancies: 5,
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ---------------- HEADER ----------------
//   Widget _buildHeader() {
//     return Row(
//       children: [
//         const Icon(Icons.location_on, color: Colors.blue),
//         const SizedBox(width: 4),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               "Noida",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             Text(
//               "Sector 62",
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//           ],
//         ),
//         const Spacer(),
//         Image.asset(
//           "images/logo3.png",
//           height: 30,
//         ),
//         const Spacer(),
//         Padding(
//           padding: const EdgeInsets.only(
//             right: 8.0,
//           ),
//           child: Image.asset(
//             'images/arrow2.png',
//             height: 25,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ---------------- SEARCH BAR ----------------
//   Widget _buildSearchBar(List<JobModel> allJobs) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF8E9EFD), Color(0xFF4A64FE)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: TextField(
//         controller: searchController,
//         onChanged: (value) => _filterJobs(value, allJobs), // 🔹 filter call
//         decoration: const InputDecoration(
//           hintText: "Search Job",
//           hintStyle: TextStyle(color: Colors.white),
//           prefixIcon: Icon(Icons.search, color: Colors.white),
//           border: InputBorder.none,
//         ),
//         style: const TextStyle(color: Colors.white),
//       ),
//     );
//   }
//
//   // ---------------- JOB CARD ----------------
//   Widget _buildJobCard(
//       BuildContext context, {
//         required String title,
//         required String company,
//         required String location,
//         required String salary,
//         required bool urgent,
//         required int vacancies,
//       }) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => JobFullDetails(
//               title: title,
//               company: company,
//               location: location,
//               salary: salary,
//               urgent: urgent,
//               vacancies: vacancies,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: double.infinity,
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade200,
//               blurRadius: 4,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 if (urgent)
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 6, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade100,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: const Text(
//                       "Urgent Hiring",
//                       style: TextStyle(color: Colors.blue, fontSize: 10),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Text(company, style: const TextStyle(fontSize: 12)),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 const Icon(Icons.location_on, size: 14, color: Colors.blue),
//                 const SizedBox(width: 4),
//                 Text(location, style: const TextStyle(fontSize: 12)),
//               ],
//             ),
//             const SizedBox(height: 6),
//             Text(
//               salary,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Row(
//               children: [
//                 _buildTag("New Job", Colors.orange),
//                 const SizedBox(width: 6),
//                 _buildTag("$vacancies Vacancies", Colors.orange),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTag(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 10, color: color),
//       ),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:thenaukrimitra/all_job/job_full_details.dart';
//
// import 'package:thenaukrimitra/filter/filter_row.dart';
//
// import '../ model/JobModel.dart';
// import '../provider/JobProvider.dart';
// class JobSearch extends StatefulWidget {
//   final List<JobModel> jobs;
//   const JobSearch({super.key, required this.jobs});
//
//   @override
//   State<JobSearch> createState() => _JobSearchState();
// }
//
// class _JobSearchState extends State<JobSearch> {
//   @override
//   void initState() {
//     super.initState();
//
//     Future.microtask(() {
//       Provider.of<JobProvider>(context, listen: false).fetchJobs();
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     final jobProvider = Provider.of<JobProvider>(context);
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFE7EAF6),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 8.0, right: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               const SizedBox(height: 12),
//               _buildSearchBar(),
//               const SizedBox(height: 12),
//               const FilterRow(),
//               const SizedBox(height: 8),
//
//               // ---------------- API Job List ----------------
//               Expanded(
//                 child: jobProvider.jobs.isEmpty
//                     ? const Center(child: Text("No jobs available"))
//                     : ListView.builder(
//                   itemCount: jobProvider.jobs.length,
//                   itemBuilder: (context, index) {
//                     final job = jobProvider.jobs[index];
//                     return _buildJobCard(
//                       context,
//                       title: job.title,
//                       company: job.companyName,
//                       location: job.workLocation,
//                       salary: "₹${job.minSalary} - ₹${job.maxSalary}",
//                       urgent: job.jobType.toLowerCase().contains("urgent"),
//                       vacancies: 5,
//                     );
//                   },
//                 ),
//               ),
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ---------------- HEADER ----------------
//   Widget _buildHeader() {
//     return Row(
//       children: [
//         const Icon(Icons.location_on, color: Colors.blue),
//         const SizedBox(width: 4),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               "Noida",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             Text(
//               "Sector 62",
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//           ],
//         ),
//         const Spacer(),
//         Image.asset(
//           "images/logo3.png",
//           height: 30,
//         ),
//         const Spacer(),
//         Padding(
//           padding: const EdgeInsets.only(
//             right: 8.0,
//           ),
//           child: Image.asset(
//             'images/arrow2.png',
//             height: 25,
//           ),
//         ),
//       ],
//     );
//   }
//
//   // ---------------- SEARCH BAR ----------------
//   Widget _buildSearchBar() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF8E9EFD), Color(0xFF4A64FE)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: const TextField(
//         decoration: InputDecoration(
//           hintText: "Search Job",
//           hintStyle: TextStyle(color: Colors.white),
//           prefixIcon: Icon(Icons.search, color: Colors.white),
//           border: InputBorder.none,
//         ),
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }
//
//   // ---------------- JOB CARD ----------------
//   Widget _buildJobCard(
//       BuildContext context, {
//         required String title,
//         required String company,
//         required String location,
//         required String salary,
//         required bool urgent,
//         required int vacancies,
//       }) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => JobFullDetails(
//               title: title,
//               company: company,
//               location: location,
//               salary: salary,
//               urgent: urgent,
//               vacancies: vacancies,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: double.infinity,
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade200,
//               blurRadius: 4,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//                 if (urgent)
//                   Container(
//                     padding:
//                     const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade100,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: const Text(
//                       "Urgent Hiring",
//                       style: TextStyle(color: Colors.blue, fontSize: 10),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Text(company, style: const TextStyle(fontSize: 12)),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 const Icon(Icons.location_on, size: 14, color: Colors.blue),
//                 const SizedBox(width: 4),
//                 Text(location, style: const TextStyle(fontSize: 12)),
//               ],
//             ),
//             const SizedBox(height: 6),
//             Text(
//               salary,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Row(
//               children: [
//                 _buildTag("New Job", Colors.orange),
//                 const SizedBox(width: 6),
//                 _buildTag("$vacancies Vacancies", Colors.orange),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTag(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 10, color: color),
//       ),
//     );
//   }
// }
//
















// bina APi se data aaye
// import 'package:flutter/material.dart';
// import 'package:thenaukrimitra/all_job/job_full_details.dart';
// import 'package:thenaukrimitra/custom/custom_buttom_nav.dart';
// import 'package:thenaukrimitra/filter/filter_row.dart';
//
// import '../ model/JobModel.dart';
//
// class JobSearch extends StatefulWidget {
//   final List<JobModel> jobs;
//   const JobSearch({super.key,  required this.jobs});
//
//   @override
//   State<JobSearch> createState() => _JobSearchState();
// }
// class _JobSearchState extends State<JobSearch> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE7EAF6),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 8.0,right: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               const SizedBox(height: 12),
//               _buildSearchBar(),
//               const SizedBox(height: 12),
//
//               const FilterRow(),
//               const SizedBox(height: 8),
//
//
//
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       _buildJobCard(
//                         context,
//                         title: "PHP Laravel Developer",
//                         company: "Techuweb pvt ltd",
//                         location: "Noida, Sector 63",
//                         salary: "₹ 10000 - 150000",
//                         urgent: true,
//                         vacancies: 10,
//                       ),
//                       _buildJobCard(
//                         context,
//                         title: "Backend Developer",
//                         company: "Techuweb pvt ltd",
//                         location: "Noida, Sector 63",
//                         salary: "₹ 10000 - 150000",
//                         urgent: true,
//                         vacancies: 8,
//                       ),
//                       _buildJobCard(
//                         context,
//                         title: "Backend Developer",
//                         company: "Techuweb pvt ltd",
//                         location: "Noida, Sector 63",
//                         salary: "₹ 10000 - 150000",
//                         urgent: true,
//                         vacancies: 8,
//                       ),_buildJobCard(
//                         context,
//                         title: "Backend Developer",
//                         company: "Techuweb pvt ltd",
//                         location: "Noida, Sector 63",
//                         salary: "₹ 10000 - 150000",
//                         urgent: true,
//                         vacancies: 8,
//                       ),
//                       _buildJobCard(
//                         context,
//                         title: "Backend Developer",
//                         company: "Techuweb pvt ltd",
//                         location: "Noida, Sector 63",
//                         salary: "₹ 10000 - 150000",
//                         urgent: true,
//                         vacancies: 8,
//                       ),
//                       _buildJobCard(
//                         context,
//                         title: "Office Boy",
//                         company: "Techuweb pvt ltd",
//                         location: "Noida, Sector 63",
//                         salary: "₹ 10000 - 150000",
//                         urgent: true,
//                         vacancies: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ---------------- HEADER ----------------
//   Widget _buildHeader() {
//     return Row(
//       children: [
//         const Icon(Icons.location_on, color: Colors.blue),
//         const SizedBox(width: 4),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               "Noida",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             Text(
//               "Sector 62",
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//           ],
//         ),
//         const Spacer(),
//         Image.asset(
//           "images/logo3.png",
//           height: 30,
//         ),
//         const Spacer(),
//         Padding(
//           padding: const EdgeInsets.only(right: 8.0,),
//           child: Image.asset(
//             'images/arrow2.png',
//             height: 25,
//           ),
//
//         ),
//
//       ],
//     );
//   }
//   // ---------------- SEARCH BAR ----------------
//   Widget _buildSearchBar() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF8E9EFD), Color(0xFF4A64FE)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: const TextField(
//         decoration: InputDecoration(
//           hintText: "Search Job",
//           hintStyle: TextStyle(color: Colors.white),
//           prefixIcon: Icon(Icons.search, color: Colors.white),
//           border: InputBorder.none,
//         ),
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }
//
//   // ---------------- FILTER ROW ----------------
//
//
//
//   // ---------------- JOB CARD ----------------
//   Widget _buildJobCard(
//       BuildContext context, {
//         required String title,
//         required String company,
//         required String location,
//         required String salary,
//         required bool urgent,
//         required int vacancies,
//       }) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => JobFullDetails(
//               title: title,
//               company: company,
//               location: location,
//               salary: salary,
//               urgent: urgent,
//               vacancies: vacancies,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: double.infinity,
//
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade200,
//               blurRadius: 4,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//
//                 if (urgent)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade100,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: const Text(
//                       "Urgent Hiring",
//                       style: TextStyle(color: Colors.blue, fontSize: 10),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Text(company, style: const TextStyle(fontSize: 12)),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 const Icon(Icons.location_on, size: 14, color: Colors.blue),
//                 const SizedBox(width: 4),
//                 Text(location, style: const TextStyle(fontSize: 12)),
//               ],
//             ),
//             const SizedBox(height: 6),
//             Text(
//               salary,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Row(
//               children: [
//                 _buildTag("New Job", Colors.orange),
//                 const SizedBox(width: 6),
//                 _buildTag("$vacancies Vacancies", Colors.orange),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTag(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 10, color: color),
//       ),
//     );
//   }
// }
//







// import 'package:flutter/material.dart';
// import 'package:thenaukrimitra/all_job/job_full_details.dart';
// import 'package:thenaukrimitra/custom/custom_buttom_nav.dart';
// import 'package:thenaukrimitra/filter/filter_row.dart';
//
// class JobSearch extends StatefulWidget {
//   const JobSearch({super.key});
//
//   @override
//   State<JobSearch> createState() => _JobSearchState();
// }
// class _JobSearchState extends State<JobSearch> {
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFE7EAF6),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 8.0,right: 8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildHeader(),
//               const SizedBox(height: 12),
//               _buildSearchBar(),
//               const SizedBox(height: 12),
//
//               const FilterRow(),
//               const SizedBox(height: 8),
//
//               // Scrollable Job Cards
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       _buildJobCard(
//                         context,
//                         title: "PHP Laravel Developer",
//                         company: "Techuweb pvt ltd",
//                         location: "Noida, Sector 63",
//                         salary: "₹ 10000 - 150000",
//                         urgent: true,
//                         vacancies: 10,
//                       ),
//                       _buildJobCard(
//                         context,
//                         title: "Backend Developer",
//                         company: "Techuweb pvt ltd",
//                         location: "Noida, Sector 63",
//                         salary: "₹ 10000 - 150000",
//                         urgent: true,
//                         vacancies: 8,
//                       ),
//                       _buildJobCard(
//                         context,
//                         title: "Backend Developer",
//                         company: "Techuweb pvt ltd",
//                         location: "Noida, Sector 63",
//                         salary: "₹ 10000 - 150000",
//                         urgent: true,
//                         vacancies: 8,
//                       ),_buildJobCard(
//                         context,
//                         title: "Backend Developer",
//                         company: "Techuweb pvt ltd",
//                         location: "Noida, Sector 63",
//                         salary: "₹ 10000 - 150000",
//                         urgent: true,
//                         vacancies: 8,
//                       ),
//                       _buildJobCard(
//                         context,
//                         title: "Backend Developer",
//                         company: "Techuweb pvt ltd",
//                         location: "Noida, Sector 63",
//                         salary: "₹ 10000 - 150000",
//                         urgent: true,
//                         vacancies: 8,
//                       ),
//                       _buildJobCard(
//                         context,
//                         title: "Office Boy",
//                         company: "Techuweb pvt ltd",
//                         location: "Noida, Sector 63",
//                         salary: "₹ 10000 - 150000",
//                         urgent: true,
//                         vacancies: 2,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   // ---------------- HEADER ----------------
//   Widget _buildHeader() {
//     return Row(
//       children: [
//         const Icon(Icons.location_on, color: Colors.blue),
//         const SizedBox(width: 4),
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: const [
//             Text(
//               "Noida",
//               style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//             ),
//             Text(
//               "Sector 62",
//               style: TextStyle(color: Colors.grey, fontSize: 12),
//             ),
//           ],
//         ),
//         const Spacer(),
//         Image.asset(
//           "images/logo3.png",
//           height: 30,
//         ),
//         const Spacer(),
//         Padding(
//           padding: const EdgeInsets.only(right: 8.0,),
//           child: Image.asset(
//             'images/arrow2.png',
//             height: 25,
//           ),
//
//         ),
//
//       ],
//     );
//   }
//   // ---------------- SEARCH BAR ----------------
//   Widget _buildSearchBar() {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         gradient: const LinearGradient(
//           colors: [Color(0xFF8E9EFD), Color(0xFF4A64FE)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//       ),
//       child: const TextField(
//         decoration: InputDecoration(
//           hintText: "Search Job",
//           hintStyle: TextStyle(color: Colors.white),
//           prefixIcon: Icon(Icons.search, color: Colors.white),
//           border: InputBorder.none,
//         ),
//         style: TextStyle(color: Colors.white),
//       ),
//     );
//   }
//
//   // ---------------- FILTER ROW ----------------
//
//
//
//   // ---------------- JOB CARD ----------------
//   Widget _buildJobCard(
//       BuildContext context, {
//         required String title,
//         required String company,
//         required String location,
//         required String salary,
//         required bool urgent,
//         required int vacancies,
//       }) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => JobFullDetails(
//               title: title,
//               company: company,
//               location: location,
//               salary: salary,
//               urgent: urgent,
//               vacancies: vacancies,
//             ),
//           ),
//         );
//       },
//       child: Container(
//         width: double.infinity,
//
//         margin: const EdgeInsets.symmetric(vertical: 8),
//         padding: const EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(8),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade200,
//               blurRadius: 4,
//               spreadRadius: 2,
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     title,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                 ),
//
//                 if (urgent)
//                   Container(
//                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                     decoration: BoxDecoration(
//                       color: Colors.blue.shade100,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                     child: const Text(
//                       "Urgent Hiring",
//                       style: TextStyle(color: Colors.blue, fontSize: 10),
//                     ),
//                   ),
//               ],
//             ),
//             const SizedBox(height: 4),
//             Text(company, style: const TextStyle(fontSize: 12)),
//             const SizedBox(height: 4),
//             Row(
//               children: [
//                 const Icon(Icons.location_on, size: 14, color: Colors.blue),
//                 const SizedBox(width: 4),
//                 Text(location, style: const TextStyle(fontSize: 12)),
//               ],
//             ),
//             const SizedBox(height: 6),
//             Text(
//               salary,
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.blue,
//               ),
//             ),
//             const SizedBox(height: 6),
//             Row(
//               children: [
//                 _buildTag("New Job", Colors.orange),
//                 const SizedBox(width: 6),
//                 _buildTag("$vacancies Vacancies", Colors.orange),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTag(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.1),
//         borderRadius: BorderRadius.circular(4),
//       ),
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 10, color: color),
//       ),
//     );
//   }
// }
//
