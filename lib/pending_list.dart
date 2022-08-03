import 'package:flutter/material.dart';

class pendingList extends StatefulWidget {
  const pendingList({Key? key}) : super(key: key);

  @override
  State<pendingList> createState() => _pendingListState();
}

class _pendingListState extends State<pendingList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(child: Text("Coming Soon !!!")),
    );
  }
}
