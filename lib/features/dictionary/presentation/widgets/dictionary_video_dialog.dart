import 'package:flutter/material.dart';
import '../../domain/models/dictionary_item.dart';
import 'dictionary_video_player_helpers.dart';
import 'practice_camera_feed.dart';

class DictionaryVideoDialog extends StatefulWidget {
  final List<DictionaryItem> items;
  final int initialIndex;

  const DictionaryVideoDialog({
    super.key,
    required this.items,
    required this.initialIndex,
  });

  @override
  State<DictionaryVideoDialog> createState() => _DictionaryVideoDialogState();
}

class _DictionaryVideoDialogState extends State<DictionaryVideoDialog> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty ||
        _currentIndex < 0 ||
        _currentIndex >= widget.items.length) {
      return const SizedBox.shrink();
    }

    final item = widget.items[_currentIndex];
    final bool hasNext = _currentIndex < widget.items.length - 1;
    final bool hasPrev = _currentIndex > 0;
    final maxHeight = MediaQuery.of(context).size.height * 0.88;

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with Term and Close Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      item.term,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black54),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Scrollable Video and Practice Feed Content
              Flexible(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Video Player Container
                      AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: item.videoUrl != null &&
                                    item.videoUrl!.isNotEmpty
                                ? DictionaryVideoPlayer(
                                    key: ValueKey(item.videoUrl),
                                    videoUrl: item.videoUrl!,
                                  )
                                : const Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.videocam_off_outlined,
                                          size: 44,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          "No video available",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Camera Practice Feed
                      const PracticeCameraFeed(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Navigation Buttons (Previous / Next)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous Button
                  if (hasPrev)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentIndex--;
                        });
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        size: 16,
                      ),
                      label: const Text("Previous"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.grey.shade700,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80),

                  // Next Button
                  if (hasNext)
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _currentIndex++;
                        });
                      },
                      iconAlignment: IconAlignment.end,
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 16,
                      ),
                      label: const Text("Next"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFB800),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        textStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
