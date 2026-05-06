import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_castle/cubits/word_cubit.dart';
import 'package:smart_castle/repositories/word_repository.dart';


class FlashcardsScreen extends StatelessWidget {
  final String deckId;
  final Map<String, dynamic>? extra;
  const FlashcardsScreen({super.key,required this.deckId,required this.extra});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WordCubit(WordRepository())..loadWords(deckId),
      child: _FlashcardsBody(deckName: extra?['name'] ?? 'Flashcards'),
    );
  }
}


class _FlashcardsBody extends StatefulWidget {
  final String deckName;
  const _FlashcardsBody({required this.deckName});

  @override
  State<_FlashcardsBody> createState() => _FlashcardsBodyState();
}

class _FlashcardsBodyState extends State<_FlashcardsBody> {
  int currentIndex = 0;
  bool isFlipped = false;

  void _onAnswer(BuildContext context, String result) {
    final state = context.read<WordCubit>().state;
    if (state is WordLoaded) {
      final word = state.words[currentIndex];
      context.read<WordCubit>().updateWordAfterReview(word, result);
      setState(() {
        isFlipped = false;
        if (currentIndex < state.words.length - 1) {
          currentIndex++;
        } else {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              backgroundColor: const Color(0xFF2a2a3e),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text(
                'Done! 🎉',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: const Text(
                'You finished all cards!',
                style: TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7C6FCD),
                  ),
                  child: const Text('Back', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a2e),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.deckName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<WordCubit, WordState>(
        builder: (context, state) {
          if (state is WordLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF7C6FCD)),
            );
          }
          if (state is WordError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.white)));
          }
          if (state is WordLoaded) {
            if (state.words.isEmpty) {
              return const Center(
                child: Text(
                  'No words in this category yet!',
                  style: TextStyle(color: Colors.white70),
                ),
              );
            }
            final word = state.words[currentIndex];
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        '${currentIndex + 1} / ${state.words.length}',
                        style: const TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (currentIndex + 1) / state.words.length,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation(Color(0xFF7C6FCD)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => setState(() => isFlipped = !isFlipped),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const Text('word', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        const SizedBox(height: 16),
                        Text(
                          word.word,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1a1a2e),
                          ),
                        ),
                        if (word.transcription != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            word.transcription!,
                            style: const TextStyle(color: Colors.grey, fontSize: 14),
                          ),
                        ],
                        if (isFlipped) ...[
                          const Divider(height: 30),
                          Text(
                            word.translation,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Color(0xFF7C6FCD),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          if (word.example != null) ...[
                            const SizedBox(height: 10),
                            Text(
                              word.example!,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ] else ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Tap to see translation',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _onAnswer(context, 'dont_know'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B1A1A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Don\'t know', style: TextStyle(fontSize: 15)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _onAnswer(context, 'hard'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B7A2A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Hard', style: TextStyle(fontSize: 15)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _onAnswer(context, 'know'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1A6B3A),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('Know', style: TextStyle(fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}