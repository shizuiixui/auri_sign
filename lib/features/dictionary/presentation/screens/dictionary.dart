import 'package:flutter/material.dart';
import '../viewmodels/dictionary_viewmodel.dart';
import '../../domain/models/dictionary_item.dart';
import '../widgets/dictionary_helpers.dart';
import '../widgets/dictionary_video_player_helpers.dart';

class DictionaryPage extends StatefulWidget {
  final DictionaryViewModel viewModel;

  const DictionaryPage({super.key, required this.viewModel});

  @override
  State<DictionaryPage> createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final vm = widget.viewModel;

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Search Bar
                  DictionarySearchBar(
                    controller: _searchController,
                    showFilters: vm.showFilters,
                    onChanged: vm.updateSearchQuery,
                    onFilterToggle: vm.toggleFilters,
                  ),
                  const SizedBox(height: 20),

                  // Filters
                  if (vm.showFilters) ...[
                    CategoryChipsList(
                      categories: vm.categories,
                      selectedIndex: vm.selectedCategoryIndex,
                      onCategorySelected: vm.selectCategory,
                    ),
                    const SizedBox(height: 24),
                  ],

                  // State Handling
                  if (vm.isLoading)
                    const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (vm.errorMessage.isNotEmpty)
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              vm.errorMessage,
                              style: const TextStyle(color: Colors.red),
                            ),
                            TextButton(
                              onPressed: vm.fetchData,
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      ),
                    )
                  else ...[
                    MediaPlaceholderCard(
                      signOfTheDay: vm.signOfTheDay,
                      onPlayTap: () {
                        if (vm.signOfTheDay != null) {
                          _showVideoDialog(context, [vm.signOfTheDay!], 0);
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // List View
                    Expanded(
                      child: vm.filteredList.isEmpty
                          ? Center(
                              child: Text(
                                "No signs found for '${vm.searchQuery}'",
                                style: TextStyle(
                                  color: Colors.grey.shade500,
                                  fontSize: 16,
                                ),
                              ),
                            )
                          : ListView.builder(
                              itemCount: vm.filteredList.length,
                              itemBuilder: (context, index) {
                                final item = vm.filteredList[index];
                                return DictionaryListItem(
                                  title: item.term,
                                  onTap: () => _showVideoDialog(
                                    context,
                                    vm.filteredList,
                                    index,
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Show Video Dialog
  void _showVideoDialog(
    BuildContext context,
    List<DictionaryItem> list,
    int initialIndex,
  ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            final currentIndex = initialIndex;
            final item = list[currentIndex];

            final bool hasNext = currentIndex < list.length - 1;
            final bool hasPrev = currentIndex > 0;

            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              insetPadding: const EdgeInsets.symmetric(horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            item.term,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
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
                    const SizedBox(height: 16),

                    // Show Video
                    AspectRatio(
                      aspectRatio: 16 / 9, // 1.77
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child:
                              item.videoUrl != null && item.videoUrl!.isNotEmpty
                              ? DictionaryVideoPlayer(
                                  key: ValueKey(item.videoUrl),
                                  videoUrl: item.videoUrl!,
                                )
                              : const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.videocam_off_outlined,
                                        size: 48,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "No video available",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Navigation Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Previous Button
                        if (hasPrev)
                          TextButton.icon(
                            onPressed: () {
                              setState(() {
                                initialIndex--;
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
                                fontSize: 16,
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
                                initialIndex++;
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
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Poppins',
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
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
            );
          },
        );
      },
    );
  }
}
