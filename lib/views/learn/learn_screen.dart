import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_castle/cubits/deck_cubit.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const _LearnBody();
  }
}

class _LearnBody extends StatelessWidget {
  const _LearnBody();

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
              'My Categories',
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
                          'No categories yet. Go to Words tab!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(20),
                        itemCount: decks.length,
                        itemBuilder: (context, index) {
                          final deck = decks[index];
                          final color = colors[index % colors.length];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      deck.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${deck.wordCount} words',
                                      style: const TextStyle(
                                          color: Colors.white70, fontSize: 13),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${deck.todayCount} words for today',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 13),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () => context.push(
                                        '/flashcards/${deck.id}',
                                        extra: {'name': deck.name},
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white24,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text('Flashcards'),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed: () => context.push(
                                        '/game/${deck.id}',
                                        extra: {'name': deck.name},
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white24,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text('Game'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}