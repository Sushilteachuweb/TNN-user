import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../utils/custom_app_bar.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoPath; // Local asset path
  final String title;

  const VideoPlayerScreen({
    Key? key,
    required this.videoPath,
    required this.title,
  }) : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _videoController;
  ChewieController? _chewieController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoController = VideoPlayerController.asset(widget.videoPath);
    await _videoController.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController,
      autoPlay: true,
      looping: false,
    );
    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _chewieController?.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: widget.title,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : AspectRatio(
          aspectRatio: _videoController.value.aspectRatio,
          child: Chewie(controller: _chewieController!),
        ),
      ),
    );
  }
}





// import 'package:flutter/material.dart';
// import 'package:video_player/video_player.dart';
// import "package:chewie/chewie.dart";
//
// class VideoPlayerScreen extends StatefulWidget {
//   final String videoUrl;
//   final String? title;
//
//   const VideoPlayerScreen({
//     Key? key,
//     required this.videoUrl,
//     this.title,
//   }) : super(key: key);
//
//   @override
//   State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
// }
//
// class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
//   VideoPlayerController? _videoController;
//   ChewieController? _chewieController;
//   bool _isLoading = true;
//   bool _hasError = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _initializePlayer();
//   }
//
//   Future<void> _initializePlayer() async {
//     try {
//       _videoController = VideoPlayerController.network(widget.videoUrl);
//       await _videoController!.initialize();
//       _chewieController = ChewieController(
//         videoPlayerController: _videoController!,
//         autoPlay: true,
//         looping: false,
//       );
//       if (!mounted) return;
//       setState(() => _isLoading = false);
//     } catch (e) {
//       if (!mounted) return;
//       setState(() {
//         _isLoading = false;
//         _hasError = true;
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _chewieController?.dispose();
//     _videoController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.title ?? 'Video')),
//       body: Center(
//         child: _isLoading
//             ? const CircularProgressIndicator()
//             : _hasError
//             ? const Text('Failed to load video')
//             : AspectRatio(
//           aspectRatio: _videoController!.value.aspectRatio,
//           child: Chewie(controller: _chewieController!),
//         ),
//       ),
//     );
//   }
// }
