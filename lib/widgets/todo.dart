import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Todo extends StatelessWidget {
  Todo({Key key, this.todo, this.disableEditing}) : super(key: key);

  final DocumentSnapshot todo;
  final bool disableEditing;

  void setDone() {
    todo.reference.updateData({'isDone': !todo['isDone']});
  }

  void delete() {
    todo.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController _controller =
        new TextEditingController(text: todo['todo']);

    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.all(0.0),
      title: Align(
        child: TextField(
          readOnly: disableEditing,
          cursorColor: Colors.grey[800],
          controller: _controller,
          style: TextStyle(fontSize: 18.0),
          onSubmitted: (_v) async {
            await todo.reference.updateData({'todo': _controller.value.text});
          },
          decoration: InputDecoration(
            hintText: 'Description',
          ),
        ),
        alignment: Alignment(-1.2, 0),
      ),
      leading: Checkbox(
        activeColor: Colors.grey[800],
        value: todo['isDone'],
        onChanged: (_v) {
          setDone();
        },
      ),
      trailing: IconButton(icon: Icon(Icons.close), onPressed: () { delete(); }),
    );
  }
}
