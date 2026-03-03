class DictionaryItem {
  final String id;
  final String term;
  final String category;
  final String? videoUrl;

  DictionaryItem({
    required this.id,
    required this.term,
    required this.category,
    this.videoUrl,
  });

  factory DictionaryItem.fromJson(Map<String, dynamic> json) {
    return DictionaryItem(
      id: json['_id'] ?? '',
      term: json['term'] ?? '',
      category: json['category'] ?? 'All',
      videoUrl: json['videoUrl'],
    );
  }
}