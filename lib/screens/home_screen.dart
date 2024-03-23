import 'package:flutter/material.dart';
import 'package:notes_app/database/sql_database.dart';
import 'package:notes_app/screens/news_screen.dart';
import 'package:notes_app/screens/todo_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  SqlDb sqlDb = SqlDb();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: RichText(
            text: const TextSpan(
              text: 'ToDo',
              style: TextStyle(
                color: Color.fromARGB(255, 164, 102, 226),
                fontSize: 30,
              ),
              children: [
                TextSpan(text: ' Notes', style: TextStyle(color: Colors.amber))
              ],
            ),
          ),
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 22),
            tabs: [
              Tab(
                child: Text("Note"),
              ),
              Tab(
                child: Text("ToDo"),
              ),
            ],
          ),
        ),
        body: const TabBarView(children: [
          NewsSCreen(),
          ToDoScreen(),
        ]),
      ),
    );
  }
}
