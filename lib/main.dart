import 'package:books_admin/screens/login_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  static const Color hooloovoo = Color(0xFF42DAFA);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Books - Admin',
      theme: ThemeData(
        primaryColor: hooloovoo,
        accentColor: hooloovoo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginScreen(),
    );
  }
}
