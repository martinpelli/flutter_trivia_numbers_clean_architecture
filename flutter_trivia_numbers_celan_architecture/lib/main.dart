import 'package:flutter/material.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/presentation/pages/number_trivia_page.dart';
import 'package:flutter_trivia_numbers_celan_architecture/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Trivia',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple), useMaterial3: true),
      home: const NumberTriviaPage(),
    );
  }
}
