import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_castle/models/word.dart';

class WordRepository {
  final _client = Supabase.instance.client;

  Future<List<Word>> getWords(String deckId) async {
    final data = await _client
        .from('words')
        .select()
        .eq('deck_id', deckId)
        .order('created_at');

    return data.map((e) => Word.fromJson(e)).toList();
  }

  Future<void> addWord({
    required String deckId,
    required String word,
    required String translation,
    String? transcription,
    String? example,
  }) async {
    await _client.from('words').insert({
      'deck_id': deckId,
      'word': word,
      'translation': translation,
      'transcription': transcription,
      'example': example,
      'level': 1,
      'next_review_date': DateTime.now().toIso8601String(),
    });
  }

  Future<void> updateWord(Word word) async {
    await _client.from('words').update(word.toJson()).eq('id', word.id);
  }

  Future<void> deleteWord(String id) async {
    await _client.from('words').delete().eq('id', id);
  }

  Future<List<Word>> getTodayWords() async {
    final userId = _client.auth.currentUser!.id;
    final data = await _client
        .from('words')
        .select('*, decks!inner(user_id)')
        .eq('decks.user_id', userId)
        .lte('next_review_date', DateTime.now().toIso8601String());

    return data.map((e) => Word.fromJson(e)).toList();
  }
}