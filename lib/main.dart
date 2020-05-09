import 'package:flutter/material.dart';
import 'package:todo/screens/home.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do It!',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.grey[800],
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.grey[800]),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: Colors.grey[800]),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Home(title: 'Do It!'),
    );
  }
}
