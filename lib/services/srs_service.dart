import 'package:smart_castle/models/word.dart';

class SrsService {
  static Word updateAfterReview(Word word, String result) {
    int newLevel;

    if (result == 'know') {
      newLevel = word.level + 1;
    } else if (result == 'hard') {
      newLevel = word.level;
    } else {
      newLevel = 1;
    }

    newLevel = newLevel.clamp(1, 5);

    // levels: 1=1кун, 2=3кун, 3=7кун, 4=2апта, 5=30кун
    final days = [1, 3, 7, 14, 30];
    final nextDate = DateTime.now().add(
      Duration(days: days[newLevel - 1]),
    );

    return word.copyWith(level: newLevel, nextReviewDate: nextDate);
  }

  static List<Word> getTodayWords(List<Word> words) {
    final now = DateTime.now();
    return words.where((w) => w.nextReviewDate.isBefore(now)).toList();
  }
}