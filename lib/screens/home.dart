import 'package:flutter/material.dart';
import 'package:todo/screens/new_task_screen.dart';
import 'package:todo/widgets/task_list.dart';

class Home extends StatelessWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(fontSize: 25.0, color: Colors.grey[800]),),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: TaskList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => NewTask(task: null,)));
        },
        tooltip: 'New',
        child: Icon(Icons.add),
      ),
    );
  }
}