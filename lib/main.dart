import 'package:flutter/material.dart';

import 'screens/characters_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rick & Morty',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        canvasColor: Colors.grey.shade800,
      ),
      darkTheme: ThemeData.dark(),
      home: CharactersScreen(),
    );
  }
}
