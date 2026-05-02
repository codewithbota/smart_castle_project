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

    return data.map((e) {
      final wordCount = (e['words'] as List).isNotEmpty
          ? (e['words'][0]['count'] as int)
          : 0;
      return Deck(
        id: e['id'],
        name: e['name'],
        emoji: e['emoji'] ?? '📚',
        wordCount: wordCount,
        todayCount: 0,
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