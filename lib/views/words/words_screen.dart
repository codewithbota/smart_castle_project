import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_castle/cubits/deck_cubit.dart';

class WordsScreen extends StatelessWidget {
  const WordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _WordsBody();
  }
}

class _WordsBody extends StatefulWidget {
  const _WordsBody();

  @override
  State<_WordsBody> createState() => _WordsBodyState();
}

class _WordsBodyState extends State<_WordsBody> {
  void _showAddDeckDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a3e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'New category',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Title (English, Japanese...)',
            hintStyle: const TextStyle(color: Colors.white38),
            filled: true,
            fillColor: Colors.white12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                Navigator.pop(dialogContext);
                context.read<DeckCubit>().createDeck(name, '📚');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C6FCD),
            ),
            child: const Text('Create', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteDeck(String deckId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a3e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete category?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<DeckCubit>().deleteDeck(deckId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: const BoxDecoration(
              color: Color(0xFF5B4DB0),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Text(
              'My Words',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          BlocBuilder<DeckCubit, DeckState>(
            builder: (context, state) {
              if (state is DeckLoading) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF5B4DB0)),
                  ),
                );
              }

              final decks = state is DeckLoaded
                  ? state.decks
                  : state is DeckError
                      ? state.previousDecks
                      : [];

              final colors = [
                const Color(0xFF3D3A8C),
                const Color(0xFFD45C8A),
                const Color(0xFF2E7D5E),
                const Color(0xFF7C6FCD),
              ];

              return Expanded(
                child: decks.isEmpty
                    ? const Center(
                        child: Text(
                          'No categories. Create first!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: decks.length,
                        itemBuilder: (context, index) {
                          final deck = decks[index];
                          final color = colors[index % colors.length];
                          return GestureDetector(
                            onTap: () => context.push(
                              '/deck/${deck.id}',
                              extra: {'name': deck.name, 'color': color},
                            ),
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: color,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        deck.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${deck.wordCount} words',
                                        style: const TextStyle(
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.white70,
                                    ),
                                    onPressed: () => _deleteDeck(deck.id),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDeckDialog,
        backgroundColor: const Color(0xFF5B4DB0),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'New category',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}