import 'package:flutter/material.dart';


class DeckDetailScreen extends StatefulWidget {
  final String deckId;
  final Map<String, dynamic> deck;


  const DeckDetailScreen({super.key, required this.deckId, required this.deck});


  @override
  State<DeckDetailScreen> createState() => _DeckDetailScreenState();
}


class _DeckDetailScreenState extends State<DeckDetailScreen> {
  late List<Map<String, String>> words;


  @override
  void initState() {
    super.initState();
    words = List<Map<String, String>>.from(
      widget.deck['words'].map((w) => Map<String, String>.from(w)),
    );
  }


  void _showAddWordDialog() {
    final wordController = TextEditingController();
    final translationController = TextEditingController();
    final transcriptionController = TextEditingController();
    final exampleController = TextEditingController();


    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a3e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Add a word',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(wordController, 'Word'),
              const SizedBox(height: 10),
              _buildTextField(translationController, 'Translation'),
              const SizedBox(height: 10),
              _buildTextField(
                transcriptionController,
                'Transcription (optional)',
              ),
              const SizedBox(height: 10),
              _buildTextField(
                exampleController,
                'Example sentence (optional)',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (wordController.text.isNotEmpty &&
                  translationController.text.isNotEmpty) {
                setState(() {
                  words.add({
                    'word': wordController.text,
                    'translation': translationController.text,
                    'transcription': transcriptionController.text,
                    'example': exampleController.text,
                  });
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C6FCD),
            ),
            child: const Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }


  void _deleteWord(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a3e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete word?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => words.removeAt(index));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }


  void _editWord(int index) {
    final wordController = TextEditingController(text: words[index]['word']);
    final translationController = TextEditingController(
      text: words[index]['translation'],
    );
    final transcriptionController = TextEditingController(
      text: words[index]['transcription'],
    );
    final exampleController = TextEditingController(
      text: words[index]['example'],
    );


    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a3e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Modify word',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(wordController, 'Word'),
              const SizedBox(height: 10),
              _buildTextField(translationController, 'Translation'),
              const SizedBox(height: 10),
              _buildTextField(transcriptionController, 'Transcription'),
              const SizedBox(height: 10),
              _buildTextField(exampleController, 'Example sentence'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white54),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (wordController.text.isNotEmpty &&
                  translationController.text.isNotEmpty) {
                setState(() {
                  words[index] = {
                    'word': wordController.text,
                    'translation': translationController.text,
                    'transcription': transcriptionController.text,
                    'example': exampleController.text,
                  };
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C6FCD),
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white12,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final color = widget.deck['color'] as Color;


    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.deck['name'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${words.length} слов',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: words.isEmpty
                ? const Center(
                    child: Text(
                      'No words. Add the first one!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      final word = words[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          title: Text(
                            word['word']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            word['translation']!,
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit_outlined,
                                  color: Color(0xFF7C6FCD),
                                ),
                                onPressed: () => _editWord(index),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                onPressed: () => _deleteWord(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddWordDialog,
        backgroundColor: color,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add a word',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
