import 'package:flutter/material.dart';
import 'package:notes_app/database/sql_database.dart';
import 'package:notes_app/screens/add_note.dart';
import 'package:notes_app/screens/edit_note.dart';

class NewsSCreen extends StatefulWidget {
  const NewsSCreen({super.key});

  @override
  State<NewsSCreen> createState() => _NewsSCreenState();
}

class _NewsSCreenState extends State<NewsSCreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const AddNote()));
        },
      ),
      body: FutureBuilder(
        future: SqlDb().readDataNote(),
        builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Container(
              child: snapshot.data!.isEmpty
                  ? const Center(
                      child: Text(
                        'is Empty',
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 20,
                          mainAxisExtent: 320,
                        ),
                        itemCount: snapshot.data!.length,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            child: Card(
                                elevation: 6,
                                //height: 30,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10),
                                        color: Colors.white,
                                        child: Text(
                                          "${snapshot.data![i]['content']}",
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 10,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Spacer(),
                                        Text(
                                          "${snapshot.data![i]['title']}",
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Spacer(),
                                        PopupMenuButton(
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              onTap: () async {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return EditNote(
                                                        title: snapshot.data![i]
                                                            ['title'],
                                                        note: snapshot.data![i]
                                                            ['content'],
                                                        id: snapshot.data![i]
                                                            ['id'] as int,
                                                      );
                                                    },
                                                  ),
                                                );
                                              },
                                              child: const Row(
                                                children: [
                                                  Text('Edit      '),
                                                  Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: Colors.blue,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            PopupMenuItem(
                                              onTap: () async {
                                                await SqlDb().deleteNote(
                                                    snapshot.data![i]['id']);
                                                setState(() {});
                                              },
                                              child: const Row(
                                                children: [
                                                  Text('Delete  '),
                                                  Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                    color: Colors.red,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                          );
                        },
                      ),
                    ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
