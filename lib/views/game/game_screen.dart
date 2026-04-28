import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  final String deckId;
  const GameScreen({super.key, required this.deckId});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int currentIndex = 0;
  bool isAnswered = false;
  bool isCorrect = false;
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> words = [
    {
      'word': 'substantial',
      'translation': 'существенный, значительный',
    },
    {
      'word': 'ambiguous',
      'translation': 'неоднозначный, двусмысленный',
    },
    {
      'word': 'perseverance',
      'translation': 'настойчивость, упорство',
    },
  ];

  int correctCount = 0;

  void _checkAnswer() {
    final userAnswer = _controller.text.trim().toLowerCase();
    final correctAnswer = words[currentIndex]['word']!.toLowerCase();
    setState(() {
      isAnswered = true;
      isCorrect = userAnswer == correctAnswer;
      if (isCorrect) correctCount++;
    });
  }

  void _next() {
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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
              Text(
                'correct words',
                style: const TextStyle(color: Colors.white54),
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
    final word = words[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFF1a1a2e),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a2e),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'English',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Прогресс
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Text(
                  '${currentIndex + 1} / ${words.length}',
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (currentIndex + 1) / words.length,
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF7C6FCD)),
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
                  'word',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 16),
                Text(
                  word['translation']!,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1a1a2e),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

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
                  'word',
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
                    'Answer: ${word['word']}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
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
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Do not know', style: TextStyle(fontSize: 15)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _checkAnswer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A6B3A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Done', style: TextStyle(fontSize: 15)),
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _next,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C6FCD),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Next', style: TextStyle(fontSize: 15)),
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
}