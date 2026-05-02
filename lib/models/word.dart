class Word {
  final String id;
  final String word;
  final String translation;
  final String? transcription;
  final String? example;
  final String deckId;
  final int level;
  final DateTime nextReviewDate;

  Word({
    required this.id,
    required this.word,
    required this.translation,
    this.transcription,
    this.example,
    required this.deckId,
    required this.level,
    required this.nextReviewDate,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      word: json['word'],
      translation: json['translation'],
      transcription: json['transcription'],
      example: json['example'],
      deckId: json['deck_id'],
      level: json['level'] ?? 1,
      nextReviewDate: DateTime.parse(json['next_review_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'translation': translation,
      'transcription': transcription,
      'example': example,
      'deck_id': deckId,
      'level': level,
      'next_review_date': nextReviewDate.toIso8601String(),
    };
  }

  Word copyWith({int? level, DateTime? nextReviewDate}) {
    return Word(
      id: id,
      word: word,
      translation: translation,
      transcription: transcription,
      example: example,
      deckId: deckId,
      level: level ?? this.level,
      nextReviewDate: nextReviewDate ?? this.nextReviewDate,
    );
  }
}