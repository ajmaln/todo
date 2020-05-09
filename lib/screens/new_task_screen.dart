import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo/widgets/todo.dart';

class NewTask extends StatefulWidget {
  NewTask({
    Key key,
    this.task,
  }) : super(key: key);

  final DocumentSnapshot task;

  @override
  _NewTaskState createState() => _NewTaskState();
}

GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

class _NewTaskState extends State<NewTask> {
  DocumentSnapshot task;
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    setState(() {
      task = widget.task;
    });
    _controller =
        new TextEditingController(text: task != null ? task['title'] : '');
  }

  void setDone(todoID, value) {
    task.reference
        .collection('todos')
        .document(todoID)
        .updateData({'isDone': value});
  }

  Future addTodo() async {
    if (task == null) {
      final DocumentReference doc = await Firestore.instance
          .collection('tasks')
          .add({'title': _controller.value.text});
      doc.get().then((value) => {
            setState(() {
              task = value;
            })
          });
      return await doc.collection('todos').add({'todo': '', 'isDone': false});
    } else {
      return await task.reference
          .collection('todos')
          .add({'todo': '', 'isDone': false});
    }
  }

  void _showSuccessToast(BuildContext context) {
    scaffoldState.currentState.showSnackBar(
      SnackBar(
        content: const Text('Added!'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: TextField(
          cursorColor: Colors.grey[800],
          controller: _controller,
          style: TextStyle(fontSize: 20.0),
          onSubmitted: (_v) async {
            if (task == null) {
              final DocumentReference doc = await Firestore.instance
                  .collection('tasks')
                  .add({'title': _controller.value.text});
              final DocumentSnapshot snapshot = await doc.get();
              setState(() {
                task = snapshot;
              });
              return null;
            }
            task.reference.updateData({'title': _controller.value.text});
          },
          // initialValue: task != null ? task['title'] : '',
          decoration: InputDecoration(
            hintText: 'Task Title',
            hintStyle: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                task.reference.delete();
                scaffoldState.currentState
                    .showSnackBar(SnackBar(content: Text('Deleted!')));
                Navigator.pop(context);
              })
        ],
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: task == null
          ? ModifyTask(
              data: null,
              addTodo: () async {
                final DocumentReference doc = await Firestore.instance
                    .collection('tasks')
                    .add({'title': _controller.value.text});
                doc.get().then((value) => {
                      setState(() {
                        task = value;
                      })
                    });
                await doc
                    .collection('todos')
                    .add({'todo': '', 'isDone': false});
              },
            )
          : StreamBuilder<QuerySnapshot>(
              stream: task.reference.collection('todos').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return ModifyTask(
                      data: snapshot.data.documents,
                      addTodo: addTodo,
                    );
                }
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // if (task == null) {
          //   await Firestore.instance
          //       .collection('tasks')
          //       .add({'title': _controller.value.text});
          // } else {
          //   task.reference.updateData({'title': _controller.value.text});
          // }
          await addTodo();
          _showSuccessToast(context);
        },
        tooltip: 'New Todo',
        child: Icon(Icons.add),
      ),
    );
  }
}

class ModifyTask extends StatelessWidget {
  ModifyTask({this.data, this.addTodo});

  final data;
  final addTodo;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...(data != null
            ? data.map((DocumentSnapshot todo) {
                return Todo(
                  disableEditing: false,
                  todo: todo,
                );
              }).toList()
            : []),
        RaisedButton(
          onPressed: () {
            addTodo();
          },
          child: Text('Add todo'),
        ),
      ],
      padding: EdgeInsets.all(10.0),
    );
  }
}
