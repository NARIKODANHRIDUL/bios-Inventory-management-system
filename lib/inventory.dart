// ignore_for_file: prefer_const_constructors, curly_braces_in_flow_control_structures

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ims/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Inventory extends StatefulWidget {
  const Inventory({Key? key}) : super(key: key);

  @override
  _InventoryState createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  bool admincheck = false;
  Color drwrclr = Colors.white;
  Color dtxtclr = Colors.black;

  var toprighticon = Icons.logout;
  late TextEditingController admincontroller;
  String code = "";

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
    admincontroller = TextEditingController();
  }

  @override
  void dispose() {
    admincontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (admincheck == false)
      setState(() {
        toprighticon = Icons.logout;
      });
    else
      setState(() {
        toprighticon = Icons.add_circle_outline_rounded;
      });

    ///
    ///
    ///
    ///
    ///
    ///
    ///
    ///
    ///
    ///

    ///
    ///
    ///
    ///
    ///
    ///
    ///
    return Scaffold(
      //drawer: menu,

      ///
      ///
      ///
      ///
      ///
      ///
      ///
      ///
      ///

      body: SingleChildScrollView(
        child: Column(
          children: [
            Item(itemname: "Arduino", n: 10),
            const Div(),
            Item(itemname: "Esp32", n: 20),
            Div(),
            Item(itemname: "RubberDucky", n: 2),
            Div(),
            Item(itemname: "BashBunny", n: 3),
            Div(),
            Item(itemname: "Proxmark", n: 2),
            Div(),
            Item(itemname: "Wifi pineapple", n: 3),
            Div(),
            Item(itemname: "HackRF", n: 5),
            Div(),
            Item(itemname: "SDR", n: 6),
            Div(),
            Item(itemname: "USB TTL", n: 12),
            Div(),
            Item(itemname: "Rasberry Pi", n: 3),
            Div(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 150,
                      child:
                          Image.asset("images/logo.png", fit: BoxFit.contain),
                    ),
                    const Text(
                      "bi0s inventory",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        )),
                    Text("${loggedInUser.email}",
                        style: const TextStyle(
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // the logout function

}

class Item extends StatelessWidget {
  const Item({
    Key? key,
    required this.itemname,
    required this.n,
  }) : super(key: key);

  final String itemname;
  final int n;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      // tileColor: Colors.red,
      title: Text(
        itemname,
        style: TextStyle(fontSize: 20),
      ),
      subtitle: Text("Available : $n"),
      trailing: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.grey,
            primary: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          ),
          child: const Text(
            "Request",
            style: TextStyle(color: Colors.white),
          )),
    );
  }
}

class Div extends StatelessWidget {
  const Div({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Divider(
      color: Colors.black,
      endIndent: 10,
      indent: 10,
      height: 5,
      thickness: 1,
    );
  }
}
