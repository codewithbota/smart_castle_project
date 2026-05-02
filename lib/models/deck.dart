class Deck {
  final String id;
  final String name;
  final String emoji;
  final int wordCount;
  final int todayCount;

  Deck({
    required this.id,
    required this.name,
    required this.emoji,
    required this.wordCount,
    required this.todayCount,
  });

  factory Deck.fromJson(Map<String, dynamic> json) {
    return Deck(
      id: json['id'],
      name: json['name'],
      emoji: json['emoji'] ?? '📚',
      wordCount: json['word_count'] ?? 0,
      todayCount: json['today_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'emoji': emoji,
    };
  }
}