import 'package:flutter/material.dart';

class mydue extends StatefulWidget {
  const mydue({Key? key}) : super(key: key);

  @override
  State<mydue> createState() => _mydueState();
}

class _mydueState extends State<mydue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(child: Text("Coming Soon !!!")),
    );
  }
}
