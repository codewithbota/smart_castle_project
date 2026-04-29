import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


class WordsScreen extends StatefulWidget {
  const WordsScreen({super.key});


  @override
  State<WordsScreen> createState() => _WordsScreenState();
}


class _WordsScreenState extends State<WordsScreen> {
  final List<Map<String, dynamic>> decks = [
    {
      'id': '1',
      'name': 'English',
      'color': const Color(0xFF3D3A8C),
      'words': [
        {'word': 'substantial', 'translation': 'существенный'},
        {'word': 'ambiguous', 'translation': 'неоднозначный'},
      ],
    },
    {
      'id': '2',
      'name': 'Japanese',
      'color': const Color(0xFFD45C8A),
      'words': [
        {'word': '食べる', 'translation': 'есть, кушать'},
      ],
    },
    {
      'id': '3',
      'name': 'German',
      'color': const Color(0xFF2E7D5E),
      'words': [],
    },
  ];


  void _showAddDeckDialog() {
    final nameController = TextEditingController();


    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a3e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'New category',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Titile (English, Japanese...)',
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
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                setState(() {
                  decks.add({
                    'id': DateTime.now().toString(),
                    'name': nameController.text,
                    'color': const Color(0xFF7C6FCD),
                    'words': [],
                  });
                });
                Navigator.pop(context);
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


  void _deleteDeck(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2a2a3e),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Delete category?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'All words in "${decks[index]['name']}" will be deleted',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => decks.removeAt(index));
              Navigator.pop(context);
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
          Expanded(
            child: decks.isEmpty
                ? const Center(
                    child: Text(
                      'No categories. Create one!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: decks.length,
                    itemBuilder: (context, index) {
                      final deck = decks[index];
                      return GestureDetector(
                        onTap: () => context.push('/deck/${deck['id']}', extra: deck),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: deck['color'],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    deck['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${deck['words'].length} words',
                                    style: const TextStyle(color: Colors.white70),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.white70),
                                onPressed: () => _deleteDeck(index),
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
