import 'package:flutter/material.dart';
import 'package:flutter_sqflite/provider/todo_provider.dart';
import 'package:flutter_sqflite/screens/show_todo_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TodoProvider(),
        ),
      ],
      builder: (context, child) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ShowTodoScreen(),
      ),
    );
  }
}
