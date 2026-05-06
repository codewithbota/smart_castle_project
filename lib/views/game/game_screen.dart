import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_castle/cubits/word_cubit.dart';
import 'package:smart_castle/models/word.dart';
import 'package:smart_castle/repositories/word_repository.dart';

class GameScreen extends StatelessWidget {
  final String deckId;
  const GameScreen({super.key, required this.deckId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WordCubit(WordRepository())..loadWords(deckId),
      child: const _GameBody(),
    );
  }
}

class _GameBody extends StatefulWidget {
  const _GameBody();

  @override
  State<_GameBody> createState() => _GameBodyState();
}

class _GameBodyState extends State<_GameBody> {
  int currentIndex = 0;
  bool isAnswered = false;
  bool isCorrect = false;
  int correctCount = 0;
  final TextEditingController _controller = TextEditingController();

  void _checkAnswer(List<Word> words) {
    final userAnswer = _controller.text.trim().toLowerCase();
    final correctAnswer = words[currentIndex].word.toLowerCase();
    setState(() {
      isAnswered = true;
      isCorrect = userAnswer == correctAnswer;
      if (isCorrect) correctCount++;
    });
  }

  void _next(BuildContext context, List<Word> words) {
    if (currentIndex < words.length - 1) {
      setState(() {
        currentIndex++;
        isAnswered = false;
        isCorrect = false;
        _controller.clear();
      });
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF2a2a3e),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Result',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$correctCount / ${words.length}',
                style: const TextStyle(
                  color: Color(0xFF7C6FCD),
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'correct words',
                style: TextStyle(color: Colors.white54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text(
                'Done',
                style: TextStyle(color: Color(0xFF7C6FCD)),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WordCubit, WordState>(
      builder: (context, state) {
        if (state is WordLoading) {
          return const Scaffold(
            backgroundColor: Color(0xFF1a1a2e),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFF7C6FCD)),
            ),
          );
        }

        if (state is WordError) {
          return Scaffold(
            backgroundColor: const Color(0xFF1a1a2e),
            body: Center(
              child: Text(state.message,
                  style: const TextStyle(color: Colors.white)),
            ),
          );
        }

        if (state is WordLoaded) {
          final words = state.words;

          if (words.isEmpty) {
            return Scaffold(
              backgroundColor: const Color(0xFF1a1a2e),
              appBar: AppBar(
                backgroundColor: const Color(0xFF1a1a2e),
                leading: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                title: const Text('Game',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
                centerTitle: true,
              ),
              body: const Center(
                child: Text(
                  'No words in this category yet.\nAdd some words first!',
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final safeIndex = currentIndex.clamp(0, words.length - 1);
          final word = words[safeIndex];

          return Scaffold(
            backgroundColor: const Color(0xFF1a1a2e),
            appBar: AppBar(
              backgroundColor: const Color(0xFF1a1a2e),
              leading: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                word.word.isNotEmpty ? 'Game' : 'Game',
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Text(
                        '${safeIndex + 1} / ${words.length}',
                        style:
                            const TextStyle(color: Colors.white54, fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: (safeIndex + 1) / words.length,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation(
                            Color(0xFF7C6FCD)),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'translation',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        word.translation,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1a1a2e),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      if (word.transcription != null &&
                          word.transcription!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          '[${word.transcription}]',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Input card
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: isAnswered
                        ? Border.all(
                            color: isCorrect ? Colors.green : Colors.red,
                            width: 2,
                          )
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'type the word',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _controller,
                        enabled: !isAnswered,
                        decoration: const InputDecoration(
                          hintText: 'Write a word...',
                          border: InputBorder.none,
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xFF1a1a2e),
                        ),
                      ),
                      if (isAnswered && !isCorrect)
                        Text(
                          'Answer: ${word.word}',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      if (isAnswered && isCorrect)
                        const Text(
                          '✓ Correct!',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),

                const Spacer(),

                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  child: Row(
                    children: [
                      if (!isAnswered) ...[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isAnswered = true;
                                isCorrect = false;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B1A1A),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Don\'t know',
                                style: TextStyle(fontSize: 15)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _checkAnswer(words),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1A6B3A),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text('Check',
                                style: TextStyle(fontSize: 15)),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _next(context, words),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF7C6FCD),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: Text(
                              safeIndex < words.length - 1 ? 'Next' : 'Finish',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const Scaffold(
          backgroundColor: Color(0xFF1a1a2e),
          body: SizedBox(),
        );
      },
    );
  }
}