import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/widgets/task.dart';

List listItems(snapshot) {
  final items = snapshot.data.documents.map((DocumentSnapshot task) {
    return Task(task: task);
  }).toList();

  if (items.length > 0) {
    return items;
  } else {
    return [
      Text('No Tasks found, create one!'),
    ];
  }
}

class TaskList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('tasks').snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return new ListView(
              children: [...listItems(snapshot)],
              padding: EdgeInsets.all(10.0),
            );
        }
      },
    );
  }
}
