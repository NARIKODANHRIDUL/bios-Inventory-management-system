// ignore_for_file: camel_case_types

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
      body: const Center(child: Text("Coming Soon !!!")),
    );
  }
}
