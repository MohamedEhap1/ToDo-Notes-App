import 'package:flutter/material.dart';
import 'package:notes_app/database/sql_database.dart';
import 'package:notes_app/screens/home_screen.dart';
import 'package:notes_app/screens/local_notification_service.dart';
import 'package:notes_app/services/work_manger_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Future.wait([
    //excute in the same time
    LocalNotification.init(),
    WorkManagerService().init(),
  ]);
  // await LocalNotification.init();
  // await WorkManagerService().init();
  SqlDb().db; //initial  for database
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
