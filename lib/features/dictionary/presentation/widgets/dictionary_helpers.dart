import 'package:flutter/material.dart';
import '../../domain/models/dictionary_item.dart';

class DictionarySearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;
  final bool showFilters;
  final VoidCallback onFilterToggle;

  const DictionarySearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.showFilters,
    required this.onFilterToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: "Search for a word",
                hintStyle: TextStyle(color: Colors.grey.shade500),
                // Search Button
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black87,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 15,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        // Filter Button
        IconButton(
          icon: Icon(
            showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
            color: showFilters ? const Color(0xFFFFB800) : Colors.black,
          ),
          onPressed: onFilterToggle,
        ),
      ],
    );
  }
}

class CategoryChipsList extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final Function(int) onCategorySelected;

  const CategoryChipsList({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onCategorySelected(index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFFFB800) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFFFFB800) : Colors.grey.shade300,
                  width: 1.5,
                ),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MediaPlaceholderCard extends StatelessWidget {
  final DictionaryItem? signOfTheDay;
  final VoidCallback? onPlayTap;

  const MediaPlaceholderCard({
    super.key, 
    this.signOfTheDay,
    this.onPlayTap,
  });

  @override
  Widget build(BuildContext context) {
    if (signOfTheDay == null) return const SizedBox.shrink(); 

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFB800),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign Language of the Day",
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  signOfTheDay!.term,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            right: 12,
            child: GestureDetector(
              onTap: onPlayTap,
              child: Container(
                height: 44,
                width: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFB800),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DictionaryListItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const DictionaryListItem({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              fontFamily: 'Poppins',
            ),
          ),
          trailing: const Icon(
            Icons.play_arrow_rounded,
            color: Color(0xFFFFB800),
            size: 28,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}