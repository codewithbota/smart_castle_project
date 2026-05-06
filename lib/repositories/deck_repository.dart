import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_castle/models/deck.dart';

class DeckRepository {
  final _client = Supabase.instance.client;

  Future<List<Deck>> getDecks() async {
    final userId = _client.auth.currentUser!.id;

    final data = await _client
        .from('decks')
        .select('*, words(count)')
        .eq('user_id', userId)
        .order('created_at');

    if (data.isEmpty) return [];

    final deckIds = data.map((e) => e['id'] as String).toList();

    final now = DateTime.now().toIso8601String();
    final todayWords = await _client
        .from('words')
        .select('deck_id')
        .inFilter('deck_id', deckIds)
        .lte('next_review_date', now);

    final Map<String, int> todayCountByDeck = {};
    for (final w in todayWords) {
      final deckId = w['deck_id'] as String;
      todayCountByDeck[deckId] = (todayCountByDeck[deckId] ?? 0) + 1;
    }

    return data.map((e) {
      final wordCount = (e['words'] as List).isNotEmpty
          ? (e['words'][0]['count'] as int)
          : 0;
      final deckId = e['id'] as String;
      return Deck(
        id: deckId,
        name: e['name'],
        emoji: e['emoji'] ?? '📚',
        wordCount: wordCount,
        todayCount: todayCountByDeck[deckId] ?? 0,
      );
    }).toList();
  }

  Future<void> createDeck(String name, String emoji) async {
    final userId = _client.auth.currentUser!.id;
    await _client.from('decks').insert({
      'name': name,
      'emoji': emoji,
      'user_id': userId,
    });
  }

  Future<void> deleteDeck(String id) async {
    await _client.from('decks').delete().eq('id', id);
  }
}