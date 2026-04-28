import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_castle/views/home/home_screen.dart';
import 'package:smart_castle/views/learn/learn_screen.dart';
import 'package:smart_castle/views/words/words_screen.dart';
import 'package:smart_castle/views/profile/profile_screen.dart';
import 'package:smart_castle/router/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'LearnWithBota',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(
        //   seedColor:Color.fromARGB(255, 94, 3, 91),
        // ),
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}