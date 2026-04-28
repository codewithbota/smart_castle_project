import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_castle/views/home/home_screen.dart';
import 'package:smart_castle/views/learn/learn_screen.dart';
import 'package:smart_castle/views/words/words_screen.dart';
import 'package:smart_castle/views/profile/profile_screen.dart';
import 'package:smart_castle/views/flashcards/flashcards_screen.dart';
import 'package:smart_castle/views/game/game_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) {
        return ScaffoldWithNavBar(shell: shell);
      },
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/learn',
            builder: (context, state) => const LearnScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/words',
            builder: (context, state) => const WordsScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ]),
      ],
    ),

    GoRoute(
      path: '/flashcards/:deckId',
      builder: (context, state) {
        final deckId = state.pathParameters['deckId']!;
        return FlashcardsScreen(deckId: deckId);
      },
    ),
    GoRoute(
      path: '/game/:deckId',
      builder: (context, state) {
        final deckId = state.pathParameters['deckId']!;
        return GameScreen(deckId: deckId);
      },
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell shell;
  const ScaffoldWithNavBar({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: shell.currentIndex,
        onTap: (index) => shell.goBranch(index),
        selectedItemColor: Color(0xFF5B4DB0),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Learn'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Words'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}