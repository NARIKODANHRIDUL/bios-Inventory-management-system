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
  final Stream<QuerySnapshot> hardwareStream =
      FirebaseFirestore.instance.collection('hardware').snapshots();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool admincheck = false;
  Color drwrclr = Colors.white;
  Color dtxtclr = Colors.black;
  String adreq = "Request";

  // late TextEditingController admincontroller;
  String code = "";

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      //this.loggedInUser = UserModel.fromMap(value.data());
      loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
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
    ///
    return StreamBuilder(
        stream: hardwareStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("SomethingWent Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.black,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text("Loading Database. Please wait...")
                    ]),
              ),
            );
          }
          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            print(storedocs);
          }).toList();

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
                  for (var i = 0; i < storedocs.length; i++) ...[
                    Item(
                      itemname: "Arduino",
                      n: 10,
                      adreq: adreq,
                      admincheck: admincheck,
                    ),
                    const Div(),
                  ],
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 150,
                            child: Image.asset("images/logo.png",
                                fit: BoxFit.contain),
                          ),
                          const Text(
                            "bi0s inventory",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                              "${loggedInUser.firstName} ${loggedInUser.secondName}",
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
        });
  }

  // the logout function

}

class Item extends StatelessWidget {
  Item({
    Key? key,
    required this.itemname,
    required this.n,
    required this.adreq,
    required this.admincheck,
  }) : super(key: key);

  final String itemname;
  final int n;
  final bool admincheck;
  String adreq;

  @override
  Widget build(BuildContext context) {
    if (admincheck == true) {
      adreq = "Add";
    } else {
      adreq = "Request";
    }
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
          child: Text(
            adreq,
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
    return Divider(
      color: Colors.grey,
      endIndent: 10,
      indent: 10,
      height: 5,
      thickness: 1,
    );
  }
}
