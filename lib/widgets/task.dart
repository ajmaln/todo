import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/screens/new_task_screen.dart';
import 'package:todo/widgets/todo.dart';

class Task extends StatelessWidget {
  Task({this.task});

  final DocumentSnapshot task;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewTask(
                task: task,
              ),
            ),
          );
        },
        splashColor: Colors.grey[800].withAlpha(100),
        child: AbsorbPointer(
          absorbing: true,
                  child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Align(
                  child: Text(
                    task['title'],
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  alignment: Alignment(-0.9, 0),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: task.reference.collection('todos').snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return new Text('Loading...');
                        default:
                          return Expanded(
                            child: SizedBox(
                              child: ListView(
                                children: snapshot.data.documents
                                    .map((DocumentSnapshot todo) {
                                  return Todo(
                                    disableEditing: true,
                                    todo: todo,
                                  );
                                }).toList(),
                              ),
                              height: 200,
                            ),
                          );
                      }
                    }),
              ],
            ),
            padding: EdgeInsets.only(top: 10.0, left: 0.0, right: 10.0, bottom: 10.0),
            height: 200,
          ),
        ),
      ),
    );
  }
}
