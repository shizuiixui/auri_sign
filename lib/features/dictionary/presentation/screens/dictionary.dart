import 'package:flutter/material.dart';
import '../viewmodels/dictionary_viewmodel.dart';
import '../../domain/models/dictionary_item.dart';
import '../widgets/dictionary_helpers.dart';
import '../widgets/dictionary_video_dialog.dart';

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
        return DictionaryVideoDialog(
          items: list,
          initialIndex: initialIndex,
        );
      },
    );
  }
}
