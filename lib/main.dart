import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_castle/repositories/deck_repository.dart';
import 'package:smart_castle/repositories/word_repository.dart';
import 'package:smart_castle/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://znpxzxknkoempjqihqkd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpucHh6eGtua29lbXBqcWlocWtkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc3MTc4OTMsImV4cCI6MjA5MzI5Mzg5M30.1TYiPsF-oAdxVHfDwa7xn0lObqdVho-7ygQcCDP4yXo',
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DeckRepository>(
          create: (_) => DeckRepository(),
        ),
        RepositoryProvider<WordRepository>(
          create: (_) => WordRepository(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ByLittle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C6FCD),
        ),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}