import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class DictionaryVideoPlayer extends StatefulWidget {
  final String videoUrl;

  const DictionaryVideoPlayer({super.key, required this.videoUrl});

  @override
  State<DictionaryVideoPlayer> createState() => _DictionaryVideoPlayerState();
}

class _DictionaryVideoPlayerState extends State<DictionaryVideoPlayer> {
  late VideoPlayerController _controller;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    Future.delayed(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      _controller
          .initialize()
          .then((_) {
            if (mounted) {
              setState(() {});
              _controller.play();
              _controller.setLooping(true);
            }
          })
          .catchError((error) {
            if (mounted) {
              setState(() {
                _hasError = true;
              });
            }
          });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(
        child: Text(
          "Error loading video.",
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    return _controller.value.isInitialized
        ? Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                child: Container(
                  color: Colors.transparent,
                  child: Center(
                    child: AnimatedOpacity(
                      opacity: _controller.value.isPlaying ? 0.0 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )
        : const Center(
            child: CircularProgressIndicator(color: Color(0xFFFFB800)),
          );
  }
}
