import 'package:flutter/material.dart';
import 'package:notes_app/database/sql_database.dart';
import 'package:notes_app/database/sql_helper.dart';
import 'package:notes_app/screens/home_screen.dart';

class EditNote extends StatefulWidget {
  const EditNote(
      {super.key, required this.note, required this.title, required this.id});
  final note;
  final title;
  final id;

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController note = TextEditingController();
  TextEditingController title = TextEditingController();

  bool clicked = false;
  @override
  void initState() {
    super.initState();
    title.text = widget.title;
    note.text = widget.note;
  }

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
                  style: const TextStyle(fontSize: 20),
                  controller: title,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter title',
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
                        await sqlDb.updateNote(Note(
                            title: title.text,
                            content: note.text,
                            id: widget.id));

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) {
                          return const HomeScreen();
                        }), (route) => false);

                        // sqlDb.deleteDb();
                      },
                      child: const Text('Update'),
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
