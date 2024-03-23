import 'package:flutter/material.dart';
import 'package:notes_app/database/sql_database.dart';
import 'package:notes_app/database/sql_helper.dart';
import 'package:notes_app/screens/home_screen.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();
  bool clicked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            clicked = clicked ? false : true;
            setState(() {});
          },
          child: clicked
              ? TextFormField(
                  controller: title,
                  decoration: const InputDecoration(
                    hintText: 'Enter title',
                    border: InputBorder.none,
                  ),
                  onFieldSubmitted: (String text) {
                    clicked = clicked ? false : true;

                    setState(() {});
                  })
              : title.text.isEmpty
                  ? const Text('Enter Title')
                  : Text(title.text),
        ),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView(
            children: [
              Form(
                key: formState,
                child: Column(
                  children: [
                    TextFormField(
                      maxLines: 25,
                      controller: note,
                      decoration: const InputDecoration(hintText: 'Enter note'),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    MaterialButton(
                      color: const Color.fromARGB(255, 219, 201, 237),
                      onPressed: () async {
                        await sqlDb.insertNote(
                            Note(title: title.text, content: note.text));

                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                          return const HomeScreen();
                        }), (route) => false);

                        // sqlDb.deleteDb();
                      },
                      child: const Text('Add'),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
