import 'package:flutter/material.dart';

class FlashcardsScreen extends StatefulWidget {
  final String deckId;
  const FlashcardsScreen({super.key, required this.deckId});

  @override
  State<FlashcardsScreen> createState() => _FlashcardsScreenState();
}

class _FlashcardsScreenState extends State<FlashcardsScreen> {
  int currentIndex = 0;
  bool isFlipped = false;

  final List<Map<String, String>> words = [
    {
      'word': 'substantial',
      'transcription': 'сабстеншл',
      'translation': 'существенный, значительный',
      'example': '"She inherited a substantial fortune from her grandmother"',
    },
    {
      'word': 'ambiguous',
      'transcription': 'эмбигьюэс',
      'translation': 'неоднозначный, двусмысленный',
      'example': '"The instructions were ambiguous"',
    },
    {
      'word': 'perseverance',
      'transcription': 'персивиэренс',
      'translation': 'настойчивость, упорство',
      'example': '"Success requires perseverance"',
    },
  ];

  void _onAnswer(String result) {
    setState(() {
      isFlipped = false;
      if (currentIndex < words.length - 1) {
        currentIndex++;
      }
    });
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
        title: Text(
          'English',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
                  const Text(
                    'word',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    word['word']!,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1a1a2e),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    word['transcription']!,
                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                  if (isFlipped) ...[
                    const Divider(height: 30),
                    Text(
                      word['translation']!,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF7C6FCD),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      word['example']!,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ] else ...[
                    const SizedBox(height: 16),
                    const Text(
                      'Click to see the translation',
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
                    onPressed: () => _onAnswer('dont_know'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8B1A1A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text('Do not know', style:TextStyle(fontSize: 15)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _onAnswer('hard'),
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
                    onPressed: () => _onAnswer('know'),
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
      ),
    );
  }
}