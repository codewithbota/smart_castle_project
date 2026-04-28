import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({super.key});

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
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _LearnDeckCard(
                  name: 'English',
                  wordCount: 142,
                  todayCount: 18,
                  color: const Color(0xFF3D3A8C),
                  deckId: '1',
                ),
                const SizedBox(height: 12),
                _LearnDeckCard(
                  name: 'Japanese',
                  wordCount: 87,
                  todayCount: 9,
                  color: const Color(0xFFD45C8A),
                  deckId: '2',
                ),
                const SizedBox(height: 12),
                _LearnDeckCard(
                  name: 'German',
                  wordCount: 35,
                  todayCount: 5,
                  color: const Color(0xFF2E7D5E),
                  deckId: '3',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LearnDeckCard extends StatelessWidget {
  final String name;
  final int wordCount;
  final int todayCount;
  final Color color;
  final String deckId;

  const _LearnDeckCard({
    required this.name,
    required this.wordCount,
    required this.todayCount,
    required this.color,
    required this.deckId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$wordCount words',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            '$todayCount words for today',
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () => context.push('/flashcards/$deckId'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Flashcards'),
              ),
              const SizedBox(width: 10),

              ElevatedButton(
                onPressed: () => context.push('/game/$deckId'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white24,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Game'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}