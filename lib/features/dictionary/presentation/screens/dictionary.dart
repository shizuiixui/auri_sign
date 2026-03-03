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
                    // Sign of the Day Card
                    MediaPlaceholderCard(
                      signOfTheDay: vm.signOfTheDay,
                      onPlayTap: () =>
                          _showVideoBottomSheet(context, vm.signOfTheDay!),
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
                                  onTap: () =>
                                      _showVideoBottomSheet(context, item),
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

  // Bottom Sheet for Video Player
  void _showVideoBottomSheet(BuildContext context, DictionaryItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.term,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.black87),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Video Player Area
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  // Fallback if videoUrl is null, otherwise show the player
                  child: item.videoUrl != null && item.videoUrl!.isNotEmpty
                      ? DictionaryVideoPlayer(videoUrl: item.videoUrl!)
                      : const Center(
                          child: Icon(
                            Icons.videocam_off_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
