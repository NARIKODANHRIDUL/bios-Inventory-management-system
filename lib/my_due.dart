import 'package:flutter/material.dart';

class myDue extends StatefulWidget {
  const myDue({Key? key}) : super(key: key);

  @override
  State<myDue> createState() => _myDueState();
}

class _myDueState extends State<myDue> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: const Center(child: const Text("Coming Soon !!!")),
    );
  }
}
