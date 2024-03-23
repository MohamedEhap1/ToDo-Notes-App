import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/database/sql_database.dart';
import 'package:notes_app/database/sql_helper.dart';

class ToDoScreen extends StatefulWidget {
  const ToDoScreen({super.key});

  @override
  State<ToDoScreen> createState() => _ToDoScreenState();
}

class _ToDoScreenState extends State<ToDoScreen> {
  @override
  TextEditingController title = TextEditingController();
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: SqlDb().readDataToDo(),
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
                  : ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) {
                              SqlDb()
                                  .deleteToDo(snapshot.data![index]['id'])
                                  .whenComplete(() => setState(() {}));
                            },
                            background: Container(
                              color: Colors.red,
                              child: const Center(
                                child: Icon(
                                  Icons.delete_forever,
                                ),
                              ),
                            ),
                            secondaryBackground: Container(
                              color: Colors.red,
                              child: const Center(
                                child: Icon(
                                  Icons.delete_forever,
                                ),
                              ),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                SqlDb().updateToDo(snapshot.data![index]['id'],
                                    snapshot.data![index]['selected']);
                                setState(() {});
                              },
                              child: ListTile(
                                leading: snapshot.data![index]['selected'] == 1
                                    ? const Icon(Icons.check_box_outlined)
                                    : const Icon(Icons.check_box_outline_blank),
                                title: Text(
                                  "${snapshot.data![index]['title']}",
                                  style: TextStyle(
                                      decoration:
                                          snapshot.data![index]['selected'] == 1
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                                ),
                                titleTextStyle: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ));
                      },
                    ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showCupertinoDialog(
              context: context,
              builder: (_) {
                return Material(
                  color: Colors.white.withOpacity(0.3),
                  child: CupertinoAlertDialog(
                    title: const Text('Add New ToDO'),
                    content: TextField(
                      controller: title,
                    ),
                    actions: <CupertinoDialogAction>[
                      CupertinoDialogAction(
                        child: const Text('NO'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text('Yes'),
                        onPressed: () {
                          SqlDb()
                              .insertToDo(ToDO(title: title.text, selected: 0));
                          Navigator.pop(context);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
