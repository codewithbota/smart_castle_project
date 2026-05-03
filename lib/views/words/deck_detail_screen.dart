import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_castle/cubits/word_cubit.dart';
import 'package:smart_castle/repositories/word_repository.dart';
import 'package:smart_castle/models/word.dart';

class DeckDetailScreen extends StatelessWidget {
  final String deckId;
  final Map<String, dynamic> deck;

  const DeckDetailScreen({
    super.key,
    required this.deckId,
    required this.deck,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WordCubit(WordRepository())..loadWords(deckId),
      child: _DeckDetailBody(deckId: deckId, deck: deck),
    );
  }
}

class _DeckDetailBody extends StatefulWidget {
  final String deckId;
  final Map<String, dynamic> deck;

  const _DeckDetailBody({required this.deckId, required this.deck});

  @override
  State<_DeckDetailBody> createState() => _DeckDetailBodyState();
}

class _DeckDetailBodyState extends State<_DeckDetailBody> {
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
          'Add word',
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
              _buildTextField(transcriptionController, 'Transcription (optional)'),
              const SizedBox(height: 10),
              _buildTextField(exampleController, 'Example sentence (optional)'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              if (wordController.text.isNotEmpty &&
                  translationController.text.isNotEmpty) {
                context.read<WordCubit>().addWord(
                  deckId: widget.deckId,
                  word: wordController.text,
                  translation: translationController.text,
                  transcription: transcriptionController.text.isEmpty
                      ? null
                      : transcriptionController.text,
                  example: exampleController.text.isEmpty
                      ? null
                      : exampleController.text,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C6FCD),
            ),
            child: const Text('Add', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditWordDialog(Word word) {
    final wordController = TextEditingController(text: word.word);
    final translationController = TextEditingController(text: word.translation);
    final transcriptionController = TextEditingController(text: word.transcription ?? '');
    final exampleController = TextEditingController(text: word.example ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a3e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Edit word',
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
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              if (wordController.text.isNotEmpty &&
                  translationController.text.isNotEmpty) {
                final updatedWord = Word(
                  id: word.id,
                  word: wordController.text,
                  translation: translationController.text,
                  transcription: transcriptionController.text.isEmpty
                      ? null
                      : transcriptionController.text,
                  example: exampleController.text.isEmpty
                      ? null
                      : exampleController.text,
                  deckId: word.deckId,
                  level: word.level,
                  nextReviewDate: word.nextReviewDate,
                );
                context.read<WordCubit>().updateWord(updatedWord);
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF7C6FCD),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _deleteWord(String wordId) {
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
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<WordCubit>().deleteWord(wordId, widget.deckId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
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
    final name = widget.deck['name'] as String;

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
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          BlocBuilder<WordCubit, WordState>(
            builder: (context, state) {
              if (state is WordLoading) {
                return const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF5B4DB0)),
                  ),
                );
              }
              if (state is WordError) {
                return Expanded(
                  child: Center(child: Text(state.message)),
                );
              }
              if (state is WordLoaded) {
                final words = state.words;
                return Expanded(
                  child: words.isEmpty
                      ? const Center(
                          child: Text(
                            'No words yet. Add your first word!',
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
                                  word.word,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  word.translation,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined,
                                          color: Color(0xFF7C6FCD)),
                                      onPressed: () => _showEditWordDialog(word),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.red),
                                      onPressed: () => _deleteWord(word.id),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                );
              }
              return const Expanded(child: SizedBox());
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddWordDialog,
        backgroundColor: color,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Add word', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}