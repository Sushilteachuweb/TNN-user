import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends State<VideoScreen> {
  final List<Map<String, String>> stories = [
    {"name": "Hello", "image": "images/man.jpg"},
    {"name": "RockStar", "image": "images/man.jpg"},
    {"name": "User3", "image": "images/man.jpg"},
    {"name": "User4", "image": "images/man.jpg"},
    {"name": "User5", "image": "images/man.jpg"},
    {"name": "User6", "image": "images/man.jpg"},
    {"name": "User7", "image": "images/man.jpg"},
  ];

  final List<Map<String, String>> videos = [
    {"video": "videos/ads.mp4",  "about": "I am A Flutter developer"},
    {"video": "videos/ads2.mp4", "about": "Fintech Wallet UI Demo।"},
    {"video": "videos/ads3.mp4",  "about": "I am A Flutter developer"},
    {"video": "videos/ads.mp4", "about": "Fintech Wallet UI Demo।"},
    {"video": "videos/ads2.mp4",  "about": "I am A Flutter developer"},
    {"video": "videos/ads3.mp4", "about": "Fintech Wallet UI Demo।"},
    {"video": "videos/ads.mp4",  "about": "I am A Flutter developer"},
    {"video": "videos/ads2.mp4", "about": "Fintech Wallet UI Demo।"},

  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Video Feed"),
        backgroundColor: Colors.white,
        elevation: 1,
        foregroundColor: Colors.black,
      ),

      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          SizedBox(
            height: 106,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: stories.length,
              itemBuilder: (context, index) {
                final s = stories[index];
                return SizedBox(
                  width: 78,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(s["image"]!),
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        height: 16,
                        child: Text(
                          s["name"]!,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const Divider(height: 1),
          ...videos.map((v) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 250,
                  width: double.infinity,
                  child: VideoPlayerWidget(videoPath: v["video"]!),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                  child: Text(
                    v["about"]!,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
                const Divider(height: 16),
              ],
            );
          }),
        ],
      ),
    );
  }
}


class VideoPlayerWidget extends StatefulWidget {
  final String videoPath;
  const VideoPlayerWidget({super.key, required this.videoPath});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoPath)
      ..initialize().then((_) {
        if (mounted) setState(() {});
      });
    _chewieController = ChewieController(
      videoPlayerController: _controller,
      autoPlay: false,
      looping: false,
      showControls: true,
    );
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: Chewie(controller: _chewieController!),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
//
// class VideoScreen extends StatefulWidget {
//   const VideoScreen({super.key});
//
//   @override
//   State<VideoScreen> createState() => _VideoFeedScreenState();
// }
//
// class _VideoFeedScreenState extends State<VideoScreen> {
//   final List<Map<String, String>> stories = [
//     {"name": "Hello", "image": "images/man.jpg"},
//     {"name": "RockStar", "image": "images/man.jpg"},
//     {"name": "User3", "image": "images/man.jpg"},
//     {"name": "User4", "image": "images/man.jpg"},
//     {"name": "User5", "image": "images/man.jpg"},
//     {"name": "User6", "image": "images/man.jpg"},
//     {"name": "User7", "image": "images/man.jpg"},
//   ];
//
//   final List<Map<String, String>> videos = [
//     {"video": "videos/ads.mp4",  "about": "I am A Flutter developer"},
//     {"video": "videos/ads2.mp4", "about": "Fintech Wallet UI Demo।"},
//     {"video": "videos/ads3.mp4",  "about": "I am A Flutter developer"},
//     {"video": "videos/ads.mp4", "about": "Fintech Wallet UI Demo।"},
//     {"video": "videos/ads2.mp4",  "about": "I am A Flutter developer"},
//     {"video": "videos/ads3.mp4", "about": "Fintech Wallet UI Demo।"},
//     {"video": "videos/ads.mp4",  "about": "I am A Flutter developer"},
//     {"video": "videos/ads2.mp4", "about": "Fintech Wallet UI Demo।"},
//
//   ];
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text("Video Feed"),
//         backgroundColor: Colors.white,
//         elevation: 1,
//         foregroundColor: Colors.black,
//       ),
//
//       body: ListView(
//         physics: const BouncingScrollPhysics(),
//         children: [
//           SizedBox(
//             height: 106,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 10),
//               itemCount: stories.length,
//               itemBuilder: (context, index) {
//                 final s = stories[index];
//                 return SizedBox(
//                   width: 78,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       CircleAvatar(
//                         radius: 30,
//                         backgroundImage: AssetImage(s["image"]!),
//                       ),
//                       const SizedBox(height: 6),
//                       SizedBox(
//                         height: 16,
//                         child: Text(
//                           s["name"]!,
//                           textAlign: TextAlign.center,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           const Divider(height: 1),
//           ...videos.map((v) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 250,
//                   width: double.infinity,
//                   child: VideoPlayerWidget(videoPath: v["video"]!),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
//                   child: Text(
//                     v["about"]!,
//                     style: const TextStyle(fontSize: 14, color: Colors.black87),
//                   ),
//                 ),
//                 const Divider(height: 16),
//               ],
//             );
//           }),
//         ],
//       ),
//     );
//   }
// }
//
//
// class VideoPlayerWidget extends StatefulWidget {
//   final String videoPath;
//   const VideoPlayerWidget({super.key, required this.videoPath});
//
//   @override
//   State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
// }
//
// class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
//   late VideoPlayerController _controller;
//   ChewieController? _chewieController;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = VideoPlayerController.asset(widget.videoPath)
//       ..initialize().then((_) {
//         if (mounted) setState(() {});
//       });
//     _chewieController = ChewieController(
//       videoPlayerController: _controller,
//       autoPlay: false,
//       looping: false,
//       showControls: true,
//     );
//   }
//
//   @override
//   void dispose() {
//     _chewieController?.dispose();
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_controller.value.isInitialized) {
//       return const Center(child: CircularProgressIndicator());
//     }
//
//     return AspectRatio(
//       aspectRatio: _controller.value.aspectRatio,
//       child: Chewie(controller: _chewieController!),
//     );
//   }
// }






// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
//
// class VideoScreen extends StatefulWidget {
//   const VideoScreen({super.key});
//
//   @override
//   State<VideoScreen> createState() => _VideoScreenState();
// }
//
// class _VideoScreenState extends State<VideoScreen> {
//   final List<Map<String, String>> videos = [
//     {
//       "path": "videos/ads.mp4",
//       "title": "Flutter Video Player Demo",
//       "channel": "Tech Channel",
//       "views": "12K views · 2 days ago"
//     },
//     {
//       "path": "videos/ads2.mp4",
//       "title": "Chewie Player Example",
//       "channel": "Code with Asif",
//       "views": "8.5K views · 1 week ago"
//     },
//     {
//       "path": "videos/ads3.mp4",
//       "title": "YouTube Style UI in Flutter",
//       "channel": "Flutter Dev",
//       "views": "20K views · 1 month ago"
//     },
//   ];
//
//   final List<VideoPlayerController> _videoControllers = [];
//   final List<ChewieController> _chewieControllers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _initializeVideos();
//   }
//
//   Future<void> _initializeVideos() async {
//     for (var video in videos) {
//       final controller = VideoPlayerController.asset(video["path"]!);
//       await controller.initialize();
//       final chewieController = ChewieController(
//         videoPlayerController: controller,
//         autoPlay: false,
//         looping: false,
//         showControls: true,
//       );
//       _videoControllers.add(controller);
//       _chewieControllers.add(chewieController);
//     }
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     for (var c in _videoControllers) {
//       c.dispose();
//     }
//     for (var c in _chewieControllers) {
//       c.dispose();
//     }
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("The Naukri Mitra"),
//         backgroundColor: const Color(0xFFE7EAF6),
//       ),
//       body: _videoControllers.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//         itemCount: videos.length,
//         itemBuilder: (context, index) {
//           return Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Video Player
//               AspectRatio(
//                 aspectRatio:
//                 _videoControllers[index].value.aspectRatio,
//                 child: Chewie(
//                   controller: _chewieControllers[index],
//                 ),
//               ),
//               // Title + Channel + Views
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   videos[index]["title"]!,
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                 child: Text(
//                   "${videos[index]["channel"]} • ${videos[index]["views"]}",
//                   style: const TextStyle(color: Colors.grey),
//                 ),
//               ),
//               // Actions Row (Like, Share, Save)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: const [
//                     Icon(Icons.thumb_up_alt_outlined),
//                     Icon(Icons.thumb_down_alt_outlined),
//                     Icon(Icons.share),
//                     Icon(Icons.download),
//                     Icon(Icons.playlist_add),
//                   ],
//                 ),
//               ),
//               const Divider(),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
