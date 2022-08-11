// ignore_for_file: file_names, prefer_const_constructors

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ims/inventory.dart';
import 'package:ims/log.dart';
import 'package:ims/my_due.dart';
import 'package:ims/pending_list.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ims/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKEy = GlobalKey<ScaffoldState>();
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  bool admincheck = false;
  bool derk = true;
  Color derkclr = const Color.fromRGBO(10, 10, 10, 1);
  double bottomsheetsize = 0.9;

  Color drwrclr = Colors.white;
  Color dtxtclr = Colors.black;
  var toprighticon = Icons.logout;
  String heading = "INVENTORY";
  var derkicon = Icons.brightness_3_outlined;
  late TextEditingController admincontroller;
  late TextEditingController itemcontroller;

  int pageIndex = 0;
  late PageController _pageController;

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
    itemcontroller = TextEditingController();
    _pageController = PageController(
      initialPage: 0,
    );
  }

  @override
  void dispose() {
    admincontroller.dispose();
    itemcontroller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final wid = MediaQuery.of(context).size.width;
    final hei = MediaQuery.of(context).size.height;
    final wids = (hei / 2) - 10;
    double wid1 = wids - 20;

    if (pageIndex == 0) {
      setState(() {
        heading = "INVENTORY";
      });
    } else if (pageIndex == 1) {
      setState(() {
        heading = "LOG";
      });
    } else if (pageIndex == 2) {
      setState(() {
        heading = "MY DUE";
      });
    } else if (pageIndex == 3) {
      setState(() {
        heading = "PENDING";
      });
    }

    Future<void> logout(BuildContext context) async {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }

    if (admincheck == false) {
      setState(() {
        toprighticon = Icons.logout;
      });
    } else {
      setState(() {
        toprighticon = Icons.add_circle_outline_rounded;
      });
    }

    Future exitDialog() => showDialog(
          context: context,
          builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // if (_isBannerAdReady == true)
                //   {

                //   }
                // else
                //   {
                //     Container(
                //       height: banner.size.height.toDouble(),
                //       width: banner.size.width.toDouble(),
                //     )
                //   },
                AlertDialog(
                    titlePadding: const EdgeInsets.only(
                        top: 0, bottom: 10, right: 0, left: 0),
                    contentPadding:
                        const EdgeInsets.only(bottom: 1, left: 10, right: 10),
                    actionsPadding: const EdgeInsets.only(top: 0, bottom: 1),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey.shade900, width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    backgroundColor:
                        drwrclr, // Color.fromRGBO(84, 102, 117, 1),
                    title: Center(
                      child: Column(
                        children: [
                          Container(
                            height: 150,
                            width: double.infinity,
                            padding: const EdgeInsets.all(0),
                            decoration: const BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(30),
                                    topRight: Radius.circular(30))),
                            child: Image.asset("images/logo.png"),
                          ),
                          Container(
                            width: wid1 * 0.8, //underline
                            padding: const EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                color: dtxtclr,
                                width: 0.5, // Underline thickness
                              )),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text('Logout Confirmation',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: dtxtclr.withOpacity(0.9),
                                  )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    insetPadding: const EdgeInsets.all(0),
                    content: Container(
                      padding: const EdgeInsets.all(0),
                      child: SizedBox(
                        width: wid * 0.7, //dialogue box width
                        // height: 100,
                        child: Text('Do you want to logout ?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                                color: dtxtclr)),
                      ),
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(children: [
                          Expanded(
                            flex: 8,
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    onPrimary: Colors.grey,
                                    elevation: 0,
                                    primary: drwrclr,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    side: const BorderSide(
                                        color: Colors.black, width: 2),
                                  ),
                                  onPressed: () {
                                    // if (heptic) player.play('pluck.mp3');
                                    // SystemNavigator.pop();

                                    logout(context);
                                  },
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'LOGOUT',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: dtxtclr,
                                            ),
                                          ),
                                          Icon(
                                            Icons.logout,
                                            color: dtxtclr,
                                            size: 25,
                                          )
                                        ]),
                                  )),
                            ),
                          ),
                          const Divider(
                            indent: 10,
                          ),
                          Expanded(
                            flex: 8,
                            child: SizedBox(
                              height: 50,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.black),
                                      foregroundColor:
                                          MaterialStateProperty.all<Color>(
                                              Colors.grey.shade800),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              // side: BorderSide(
                                              //     color: Colors.black, width: 0.5),
                                              borderRadius:
                                                  BorderRadius.circular(30)))),
                                  onPressed: () {
                                    // if (heptic) player.play('pluck.mp3');
                                    Navigator.pop(context, false);
                                  },
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'CANCEL',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: drwrclr,
                                            ),
                                          ),
                                          Icon(
                                            Icons.cancel_outlined,
                                            color: drwrclr,
                                            size: 25,
                                          )
                                        ]),
                                  )),
                            ),
                          ),
                        ]),
                      ),
                    ]),
              ]),
        );

    Future adminbox() => showDialog(
          context: context,
          builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // if (_isBannerAdReady == true)
                //   {

                //   }
                // else
                //   {
                //     Container(
                //       height: banner.size.height.toDouble(),
                //       width: banner.size.width.toDouble(),
                //     )
                //   },
                AlertDialog(
                  titlePadding: const EdgeInsets.only(
                      top: 0, bottom: 10, right: 0, left: 0),
                  contentPadding:
                      const EdgeInsets.only(bottom: 1, left: 10, right: 10),

                  actionsPadding: const EdgeInsets.only(top: 0, bottom: 1),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade900, width: 2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: drwrclr, // Color.fromRGBO(84, 102, 117, 1),
                  title: Center(
                    child: Column(
                      children: [
                        Container(
                          height: 150,
                          width: double.infinity,
                          padding: const EdgeInsets.all(0),
                          decoration: const BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          child: Image.asset("images/logo.png"),
                        ),
                        SizedBox(
                          width: wid1 * 0.9, //underline // WIDTH OF BOX

                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 5.0, bottom: 5, right: 5, top: 10),
                            child: Text('Admin check',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: dtxtclr.withOpacity(0.9),
                                )),
                          ),
                        ),
                      ],
                    ),
                  ),
                  insetPadding: const EdgeInsets.all(0),
                  content: Padding(
                    padding: const EdgeInsets.only(bottom: 0),
                    child: Container(
                      // height: 150,
                      padding: const EdgeInsets.all(0),
                      child: Column(children: [
                        ///
                        ///
                        ///
                        ///
                        ///
                        TextField(
                          style: TextStyle(
                            color: dtxtclr,
                            fontSize: 25,
                          ),
                          cursorColor: dtxtclr,
                          // keyboardType: TextInputType.number,
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.digitsOnly
                          // ],
                          textInputAction: TextInputAction.done,
                          controller: admincontroller,
                          autofocus: true,
                          // maxLength: 10,
                          decoration: InputDecoration(
                              counterText: '',
                              counterStyle:
                                  TextStyle(color: dtxtclr.withOpacity(0.5)),
                              //to hide "0/2" which came because of the 2 max length
                              label: const Text(
                                'Admin Code',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(color: dtxtclr),
                              // border: UnderlineInputBorder(borderSide: BorderSide(width: 2)),

                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: dtxtclr)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: dtxtclr)),
                              // fillColor: Colors.red,
                              hintText: "Admin code",
                              hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: dtxtclr.withOpacity(0.5))),
                        ),
                      ]),
                    ),
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Row(children: [
                        Expanded(
                          flex: 8,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  onPrimary: Colors.grey,
                                  primary: drwrclr,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                  side: BorderSide(color: dtxtclr, width: 1.5),
                                ),
                                onPressed: () {
                                  // if (heptic) player.play('pluck.mp3');
                                  Navigator.of(context).pop();

                                  if (admincontroller.text.isNotEmpty &&
                                      admincontroller.text == "123") {
                                    Fluttertoast.showToast(
                                        msg: "you are now an ADMIN");
                                    setState(() {
                                      admincheck = true;
                                    });
                                  } else {
                                    Fluttertoast.showToast(msg: "Wrong code");
                                    setState(() {
                                      admincheck = false;
                                    });
                                  }
                                  // if (boss != 0) boss = 5;

                                  // if (controllers.text.length == 1)
                                  //   sec = '0' + controllers.text;

                                  // mi = min;
                                  // se = sec;

                                  admincontroller.clear();
                                },
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'OKAY',
                                          style: TextStyle(
                                              fontSize: wid / 20,
                                              fontWeight: FontWeight.w600,
                                              color: dtxtclr),
                                        ),
                                        Icon(
                                          Icons.check_circle_outline_rounded,
                                          color: dtxtclr,
                                          size: wid / 15,
                                        )
                                      ]),
                                )),
                          ),
                        ),
                        const Divider(
                          indent: 10,
                        ),
                        Expanded(
                          flex: 9,
                          child: SizedBox(
                            height: 50,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary: dtxtclr,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50)),
                                ),
                                onPressed: () {
                                  admincontroller.clear();
                                  Navigator.of(context).pop();
                                },
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          'CANCEL',
                                          style: TextStyle(
                                            fontSize: wid / 20,
                                            fontWeight: FontWeight.w600,
                                            color: drwrclr,
                                          ),
                                        ),
                                        Icon(
                                          Icons.cancel_outlined,
                                          color: drwrclr,
                                          size: wid / 15,
                                        )
                                      ]),
                                )),
                          ),
                        ),
                      ]),
                    ),
                  ],
                ),
              ]),
        );

    ///

    // Future addbox() => showDialog(
    //       context: context,
    //       builder: (context) => Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             // if (_isBannerAdReady == true)
    //             //   {
    //             //   }
    //             // else
    //             //   {
    //             //     Container(
    //             //       height: banner.size.height.toDouble(),
    //             //       width: banner.size.width.toDouble(),
    //             //     )
    //             //   },
    //             AlertDialog(
    //               titlePadding: const EdgeInsets.only(
    //                   top: 0, bottom: 10, right: 0, left: 0),
    //               contentPadding:
    //                   const EdgeInsets.only(bottom: 1, left: 10, right: 10),
    //               actionsPadding: const EdgeInsets.only(top: 0, bottom: 1),
    //               shape: RoundedRectangleBorder(
    //                 side: BorderSide(color: Colors.grey.shade900, width: 2),
    //                 borderRadius: BorderRadius.circular(30),
    //               ),
    //               backgroundColor: drwrclr, // Color.fromRGBO(84, 102, 117, 1),
    //               title: Center(
    //                 child: Column(
    //                   children: [
    //                     Container(
    //                       height: 150,
    //                       width: double.infinity,
    //                       padding: const EdgeInsets.all(0),
    //                       decoration: const BoxDecoration(
    //                           color: Colors.black,
    //                           borderRadius: BorderRadius.only(
    //                               topLeft: Radius.circular(30),
    //                               topRight: Radius.circular(30))),
    //                       child: Image.asset("images/logo.png"),
    //                     ),
    //                     SizedBox(
    //                       width: wid1 * 0.9, //underline // WIDTH OF BOX
    //                       child: Padding(
    //                         padding: const EdgeInsets.only(
    //                             left: 5.0, bottom: 5, right: 5, top: 10),
    //                         child: Text('Add an item',
    //                             textAlign: TextAlign.center,
    //                             style: TextStyle(
    //                               fontSize: 25,
    //                               fontWeight: FontWeight.bold,
    //                               color: dtxtclr.withOpacity(0.9),
    //                             )),
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //               insetPadding: const EdgeInsets.all(0),
    //               content: Padding(
    //                 padding: const EdgeInsets.only(bottom: 0),
    //                 child: Container(
    //                   // height: 150,
    //                   padding: const EdgeInsets.all(0),
    //                   child: Column(children: [
    //                     ///
    //                     ///
    //                     ///
    //                     ///
    //                     ///
    //                     TextField(
    //                       style: TextStyle(
    //                         color: dtxtclr,
    //                         fontSize: 2,
    //                       ),
    //                       cursorColor: dtxtclr,
    //                       // keyboardType: TextInputType.number,
    //                       // inputFormatters: [
    //                       //   FilteringTextInputFormatter.digitsOnly
    //                       // ],
    //                       textInputAction: TextInputAction.done,
    //                       controller: itemcontroller,
    //                       autofocus: true,
    //                       // maxLength: 10,
    //                       decoration: InputDecoration(
    //                           counterText: '',
    //                           counterStyle:
    //                               TextStyle(color: dtxtclr.withOpacity(0.5)),
    //                           //to hide "0/2" which came because of the 2 max length
    //                           label: const Text(
    //                             'Add item',
    //                             style: TextStyle(
    //                               fontSize: 20,
    //                             ),
    //                           ),
    //                           floatingLabelBehavior:
    //                               FloatingLabelBehavior.always,
    //                           labelStyle: TextStyle(color: dtxtclr),
    //                           // border: UnderlineInputBorder(borderSide: BorderSide(width: 2)),
    //                           enabledBorder: OutlineInputBorder(
    //                               borderRadius: BorderRadius.circular(20),
    //                               borderSide: BorderSide(color: dtxtclr)),
    //                           focusedBorder: OutlineInputBorder(
    //                               borderRadius: BorderRadius.circular(20),
    //                               borderSide: BorderSide(color: dtxtclr)),
    //                           // fillColor: Colors.red,
    //                           hintText: "Type device name",
    //                           hintStyle: TextStyle(
    //                               fontSize: 20,
    //                               color: dtxtclr.withOpacity(0.5))),
    //                     ),
    //                     const SizedBox(
    //                       height: 10,
    //                     ),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                       children: [
    //                         SizedBox(
    //                           height: 65,
    //                           child: ElevatedButton(
    //                               style: ElevatedButton.styleFrom(
    //                                 elevation: 0,
    //                                 primary: dtxtclr,
    //                                 shape: RoundedRectangleBorder(
    //                                     borderRadius:
    //                                         BorderRadius.circular(300)),
    //                               ),
    //                               onPressed: () {
    //                                 Navigator.of(context).pop();
    //                               },
    //                               child: Icon(
    //                                 Icons.horizontal_rule,
    //                                 color: drwrclr,
    //                                 size: wid / 15,
    //                               )),
    //                         ),
    //                         SizedBox(
    //                           width: wid1 * 0.4,
    //                           child: TextField(
    //                             style: TextStyle(
    //                               color: dtxtclr,
    //                               fontSize: 25,
    //                             ),
    //                             cursorColor: dtxtclr,
    //                             // keyboardType: TextInputType.number,
    //                             // inputFormatters: [
    //                             //   FilteringTextInputFormatter.digitsOnly
    //                             // ],
    //                             textInputAction: TextInputAction.done,
    //                             controller: itemcontroller,
    //                             autofocus: true,
    //                             // maxLength: 10,
    //                             decoration: InputDecoration(
    //                                 counterText: '',
    //                                 counterStyle: TextStyle(
    //                                     color: dtxtclr.withOpacity(0.5)),
    //                                 //to hide "0/2" which came because of the 2 max length
    //                                 label: const Text(
    //                                   'Add item',
    //                                   style: TextStyle(
    //                                     fontSize: 20,
    //                                   ),
    //                                 ),
    //                                 floatingLabelBehavior:
    //                                     FloatingLabelBehavior.always,
    //                                 labelStyle: TextStyle(color: dtxtclr),
    //                                 // border: UnderlineInputBorder(borderSide: BorderSide(width: 2)),
    //                                 enabledBorder: OutlineInputBorder(
    //                                     borderRadius: BorderRadius.circular(20),
    //                                     borderSide: BorderSide(color: dtxtclr)),
    //                                 focusedBorder: OutlineInputBorder(
    //                                     borderRadius: BorderRadius.circular(20),
    //                                     borderSide: BorderSide(color: dtxtclr)),
    //                                 // fillColor: Colors.red,
    //                                 hintText: "Type device name",
    //                                 hintStyle: TextStyle(
    //                                     fontSize: 20,
    //                                     color: dtxtclr.withOpacity(0.5))),
    //                           ),
    //                         ),
    //                         SizedBox(
    //                           height: 65,
    //                           child: ElevatedButton(
    //                               style: ElevatedButton.styleFrom(
    //                                 elevation: 0,
    //                                 primary: dtxtclr,
    //                                 shape: RoundedRectangleBorder(
    //                                     borderRadius:
    //                                         BorderRadius.circular(300)),
    //                               ),
    //                               onPressed: () {
    //                                 Navigator.of(context).pop();
    //                               },
    //                               child: Icon(
    //                                 Icons.add,
    //                                 color: drwrclr,
    //                                 size: wid / 15,
    //                               )),
    //                         ),
    //                       ],
    //                     ),
    //                   ]),
    //                 ),
    //               ),
    //               actions: <Widget>[
    //                 Padding(
    //                   padding: const EdgeInsets.only(top: 0),
    //                   child: Row(children: [
    //                     Expanded(
    //                       flex: 8,
    //                       child: SizedBox(
    //                         height: 50,
    //                         child: ElevatedButton(
    //                             style: ElevatedButton.styleFrom(
    //                               elevation: 0,
    //                               onPrimary: Colors.grey,
    //                               primary: drwrclr,
    //                               shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(50)),
    //                               side: BorderSide(color: dtxtclr, width: 1.5),
    //                             ),
    //                             onPressed: () {
    //                               // if (heptic) player.play('pluck.mp3');
    //                               Navigator.of(context).pop();
    //                               if (itemcontroller.text.isNotEmpty &&
    //                                   itemcontroller.text == "123") {
    //                                 Fluttertoast.showToast(
    //                                     msg: "you are now an ADMIN");
    //                               } else {
    //                                 Fluttertoast.showToast(msg: "Wrong code");
    //                               }
    //                               // if (boss != 0) boss = 5;
    //                               // if (controllers.text.length == 1)
    //                               //   sec = '0' + controllers.text;
    //                               // mi = min;
    //                               // se = sec;
    //                               itemcontroller.clear();
    //                             },
    //                             child: FittedBox(
    //                               fit: BoxFit.scaleDown,
    //                               child: Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.spaceAround,
    //                                   children: [
    //                                     Text(
    //                                       'OKAY',
    //                                       style: TextStyle(
    //                                           fontSize: wid / 20,
    //                                           fontWeight: FontWeight.w600,
    //                                           color: dtxtclr),
    //                                     ),
    //                                     Icon(
    //                                       Icons.check_circle_outline_rounded,
    //                                       color: dtxtclr,
    //                                       size: wid / 15,
    //                                     )
    //                                   ]),
    //                             )),
    //                       ),
    //                     ),
    //                     const Divider(
    //                       indent: 10,
    //                     ),
    //                     Expanded(
    //                       flex: 9,
    //                       child: SizedBox(
    //                         height: 50,
    //                         child: ElevatedButton(
    //                             style: ElevatedButton.styleFrom(
    //                               elevation: 0,
    //                               primary: dtxtclr,
    //                               shape: RoundedRectangleBorder(
    //                                   borderRadius: BorderRadius.circular(50)),
    //                             ),
    //                             onPressed: () {
    //                               admincontroller.clear();
    //                               Navigator.of(context).pop();
    //                             },
    //                             child: FittedBox(
    //                               fit: BoxFit.scaleDown,
    //                               child: Row(
    //                                   mainAxisAlignment:
    //                                       MainAxisAlignment.spaceAround,
    //                                   children: [
    //                                     Text(
    //                                       'CANCEL',
    //                                       style: TextStyle(
    //                                         fontSize: wid / 20,
    //                                         fontWeight: FontWeight.w600,
    //                                         color: drwrclr,
    //                                       ),
    //                                     ),
    //                                     Icon(
    //                                       Icons.cancel_outlined,
    //                                       color: drwrclr,
    //                                       size: wid / 15,
    //                                     )
    //                                   ]),
    //                             )),
    //                       ),
    //                     ),
    //                   ]),
    //                 ),
    //               ],
    //             ),
    //           ]),
    //     );

    var menu = ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      child: SizedBox(
        width: 0.88 * wid,
        height: 0.98 * hei,
        child: Drawer(
          backgroundColor: drwrclr,
          child: Stack(children: [
            ListView(padding: EdgeInsets.zero, children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
                child: Container(
                    color: Colors.black,
                    height: 190,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(height: 45),
                          Row(children: [
                            const Image(
                              width: 110,
                              height: 110,
                              image: AssetImage(
                                "images/logo.png",
                              ),
                              fit: BoxFit.fitWidth,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 0),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("bi0s inventory",
                                        style: TextStyle(
                                            fontSize: 28,
                                            color: Colors.grey.shade300,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                        "${loggedInUser.firstName} ${loggedInUser.secondName}",
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500,
                                        )),
                                    Text("${loggedInUser.email}",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500,
                                        )),
                                  ]),
                            )
                          ]),
                        ])),
              ),
              // UserAccountsDrawerHeader(
              //   //currentAccountPictureSize:
              //   accountName: Text(
              //     'CHESS TIMER',
              //     style: TextStyle(fontSize: 0.032 * hei),
              //   ),
              //   accountEmail: Text('By NeriQuest'),
              //   currentAccountPicture: CircleAvatar(
              //     backgroundColor: Colors.blueGrey.shade900,
              //     child: ClipOval(
              //         child: Image(
              //       image: AssetImage(
              //           'android/app/src/main/res/mipmap-xxxhdpi/ic_launcher.png'),
              //       fit: BoxFit.cover,
              //     )),
              //   ),
              //   decoration: BoxDecoration(
              //       color: Colors.blueGrey.shade900,
              //       image: DecorationImage(
              //         image: AssetImage(
              //           "images/bg1.jpg",
              //         ),
              //         fit: BoxFit.cover,
              //       )),
              // ),
              //DrawerHeader(child: Container(color: Colors.red)),

              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: ListTile(
                  leading: Icon(
                    Icons.space_dashboard_rounded,
                    size: 30,
                    color: dtxtclr,
                  ),
                  title: const Text(
                    'Inventory',
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: const Text("This all we have"),
                  onTap: () {
                    _pageController.animateToPage(0,
                        duration: const Duration(microseconds: 1000),
                        curve: Curves.ease);
                    setState(() {
                      pageIndex = 0;
                    });
                    Navigator.pop(context);
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => HomeScreen()));
                    //
                    // function
                  },
                ),
              ),
//
              //
              //
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: ListTile(
                  leading: Icon(
                    Icons.receipt_long,
                    size: 30,
                    color: dtxtclr,
                  ),
                  title: const Text(
                    'Log',
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: const Text("See all the activities"),
                  onTap: () {
                    Navigator.pop(context);
                    _pageController.animateToPage(1,
                        duration: const Duration(microseconds: 1000),
                        curve: Curves.ease);
                    setState(() {
                      pageIndex = 1;
                    });

                    //
                    // function
                  },
                ),
              ),
//
              //
              //
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: ListTile(
                  leading: Icon(
                    Icons.pending_actions_rounded,
                    size: 30,
                    color: dtxtclr,
                  ),
                  title: const Text(
                    'My Due',
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: const Text("See what all dues you having"),
                  onTap: () {
                    _pageController.animateToPage(2,
                        duration: const Duration(microseconds: 1000),
                        curve: Curves.ease);
                    setState(() {
                      pageIndex = 2;
                    });
                    Navigator.pop(context);
                    // function
                  },
                ),
              ),
              //
              //
              //
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: ListTile(
                  leading: Icon(
                    Icons.list_alt_rounded,
                    size: 30,
                    color: dtxtclr,
                  ),
                  title: const Text(
                    'Pending list',
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: const Text("Who all have due"),
                  onTap: () {
                    _pageController.animateToPage(3,
                        duration: const Duration(microseconds: 1000),
                        curve: Curves.ease);
                    setState(() {
                      pageIndex = 3;
                    });
                    Navigator.pop(context);
                    // function
                  },
                ),
              ),

              const SizedBox(height: 20),
              const Div(),
              ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                child: ListTile(
                  leading: Icon(
                    Icons.logout,
                    size: 30,
                    color: dtxtclr,
                  ),
                  title: const Text(
                    'Logout',
                    style: TextStyle(fontSize: 22),
                  ),
                  subtitle: const Text("Take cares"),
                  onTap: () {
                    Navigator.pop(context);
                    exitDialog();
                    //
                    // function
                  },
                ),
              ),
              const Div(),
              const SizedBox(height: 10),
              //
              //
              //
              //
              Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: SizedBox(
                    height: 35, child: Image.asset("images/bioshardwareb.png")),
              ),

              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///
              ///

              const SizedBox(
                height: 65,
                child: ListTile(),
              )
            ]),
            Positioned(
              width: 0.88 * wid,
              right: 5,
              height: 45,
              bottom: 5,
              //  left: 0.01 * wid,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                    // bottomLeft: Radius.circular(25),
                    // topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25)),
                child: Container(
                  height: 20,
                  color: derkclr,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          derkicon,
                          size: 20,
                          color: Colors.white70,
                        ),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'DARK THEME',
                            style: TextStyle(
                              fontSize: (wid * 0.055),
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        Transform.scale(
                          scale: 1.5,
                          alignment: Alignment.center,
                          child: Switch.adaptive(
                              value: derk,
                              activeColor: Colors.grey.shade800,
                              activeTrackColor: Colors.grey.shade600,
                              inactiveTrackColor: Colors.grey.shade400,
                              inactiveThumbColor: Colors.grey.shade300,
                              // activeThumbImage: ,
                              onChanged: (bool derk) {
                                setState(() {
                                  this.derk = derk;
                                });
                              }),
                        ),
                      ]

                      //
                      //
                      // function
                      ),
                ),
              ),
            )
          ]),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        children: const [
          Inventory(),
          Log(),
          myDue(),
          pendingList(),
        ],
      ),
      key: _scaffoldKEy,
      drawer: menu,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade600,
        leading: Padding(
          padding: const EdgeInsets.all(3.0),
          child: ClipOval(
            child: ElevatedButton(
              onPressed: (() {
                _scaffoldKEy.currentState?.openDrawer();
              }),
              onLongPress: (() {
                adminbox();
              }),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(1), primary: Colors.grey),
              child: Image.asset("images/icon.png", fit: BoxFit.contain),
            ),
          ),
        ),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          verticalDirection: VerticalDirection.up,
          children: [
            Text(heading,
                style: GoogleFonts.luckiestGuy(
                  fontSize: 35,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                )),
            Text("${loggedInUser.firstName} ${loggedInUser.secondName}",
                style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 17)),
          ],
        ),

        // centerTitle: true
        actions: [
          if (admincheck == true)
            const Icon(Icons.admin_panel_settings_rounded, size: 35),
          IconButton(
              onPressed: () {
                if (admincheck == false) {
                  exitDialog();
                } else {
                  // addbox();
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(50))),
                    context: context,
                    builder: (context) => Builder(builder: (context) {
                      return addsheet(
                          bottomsheetsize: bottomsheetsize,
                          wid1: wid1,
                          dtxtclr: dtxtclr,
                          itemcontroller: itemcontroller,
                          drwrclr: drwrclr,
                          wid: wid,
                          admincontroller: admincontroller);
                    }),
                  );
                  Fluttertoast.showToast(msg: "add item");
                }
              },
              icon: Icon(
                toprighticon,
                size: 30,
              )),
          const SizedBox(
            width: 5,
          )
        ],
      ),
    );
  }
}

class addsheet extends StatelessWidget {
  const addsheet({
    Key? key,
    required this.bottomsheetsize,
    required this.wid1,
    required this.dtxtclr,
    required this.itemcontroller,
    required this.drwrclr,
    required this.wid,
    required this.admincontroller,
  }) : super(key: key);

  final double bottomsheetsize;
  final double wid1;
  final Color dtxtclr;
  final TextEditingController itemcontroller;
  final Color drwrclr;
  final double wid;
  final TextEditingController admincontroller;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: (() => Navigator.of(context).pop()),
      child: GestureDetector(
        onTap: () {},
        child: DraggableScrollableSheet(
          initialChildSize: bottomsheetsize,
          minChildSize: 0.2,
          builder: (_, controller) => Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30))),
            child: ListView(
              controller: controller,
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  padding: const EdgeInsets.all(0),
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30))),
                  child: Image.asset("images/logo.png"),
                ),
                SizedBox(
                  width: wid1 * 0.9, //underline // WIDTH OF BOX

                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 5.0, bottom: 5, right: 5, top: 10),
                    child: Text('Add an item',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.roboto(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: dtxtclr.withOpacity(0.9),
                        )),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    // height: 150,
                    padding: const EdgeInsets.all(0),
                    child: Column(children: [
                      ///
                      ///
                      ///
                      ///
                      ///
                      Container(
                        height: 55,
                        child: TextField(
                          cursorRadius: Radius.circular(50),
                          onTap: (() {}),
                          textAlignVertical: TextAlignVertical.bottom,
                          style: GoogleFonts.roboto(
                            color: dtxtclr,
                            fontSize: 20,
                          ),
                          cursorColor: dtxtclr,

                          // keyboardType: TextInputType.number,
                          // inputFormatters: [
                          //   FilteringTextInputFormatter.digitsOnly
                          // ],
                          textInputAction: TextInputAction.done,
                          controller: itemcontroller,
                          autofocus: true,
                          // maxLength: 10,
                          decoration: InputDecoration(
                              counterText: '',
                              counterStyle:
                                  TextStyle(color: dtxtclr.withOpacity(0.5)),
                              //to hide "0/2" which came because of the 2 max length
                              label: const Text(
                                'Add item',
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              labelStyle: TextStyle(color: dtxtclr),
                              // border: UnderlineInputBorder(borderSide: BorderSide(width: 2)),

                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: dtxtclr)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: dtxtclr)),
                              // fillColor: Colors.red,
                              hintText: "Type device name",
                              hintStyle: TextStyle(
                                  fontSize: 20,
                                  color: dtxtclr.withOpacity(0.5))),
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 65,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary: dtxtclr,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(300)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.horizontal_rule,
                                  color: drwrclr,
                                  size: wid / 15,
                                )),
                          ),
                          SizedBox(
                            width: wid1 * 0.57,
                            height: 55,
                            child: TextField(
                              cursorRadius: Radius.circular(50),
                              textAlignVertical: TextAlignVertical.bottom,
                              style: TextStyle(
                                color: dtxtclr,
                                fontSize: 20,
                              ),
                              cursorColor: dtxtclr,
                              // keyboardType: TextInputType.number,
                              // inputFormatters: [
                              //   FilteringTextInputFormatter.digitsOnly
                              // ],
                              textInputAction: TextInputAction.done,
                              controller: itemcontroller,
                              autofocus: true,
                              // maxLength: 10,
                              decoration: InputDecoration(
                                  counterText: '',
                                  counterStyle: TextStyle(
                                      color: dtxtclr.withOpacity(0.5)),
                                  //to hide "0/2" which came because of the 2 max length
                                  label: const Text(
                                    'Amount',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  labelStyle: TextStyle(color: dtxtclr),
                                  // border: UnderlineInputBorder(borderSide: BorderSide(width: 2)),

                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: dtxtclr)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(color: dtxtclr)),
                                  // fillColor: Colors.red,
                                  hintText: "No. of devices",
                                  hintStyle: TextStyle(
                                      fontSize: 20,
                                      color: dtxtclr.withOpacity(0.5))),
                            ),
                          ),
                          SizedBox(
                            height: 65,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  primary: dtxtclr,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(300)),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Icon(
                                  Icons.add,
                                  color: drwrclr,
                                  size: wid / 15,
                                )),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: wid * 0.4,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    onPrimary: Colors.grey,
                                    primary: drwrclr,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    side:
                                        BorderSide(color: dtxtclr, width: 1.5),
                                  ),
                                  onPressed: () {
                                    // if (heptic) player.play('pluck.mp3');
                                    Navigator.of(context).pop();

                                    if (itemcontroller.text.isNotEmpty &&
                                        itemcontroller.text == "123") {
                                      Fluttertoast.showToast(
                                          msg: "you are now an ADMIN");
                                    } else {
                                      Fluttertoast.showToast(msg: "Wrong code");
                                    }
                                    // if (boss != 0) boss = 5;

                                    // if (controllers.text.length == 1)
                                    //   sec = '0' + controllers.text;

                                    // mi = min;
                                    // se = sec;

                                    itemcontroller.clear();
                                  },
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'OKAY',
                                            style: TextStyle(
                                                fontSize: wid / 20,
                                                fontWeight: FontWeight.w600,
                                                color: dtxtclr),
                                          ),
                                          Icon(
                                            Icons.check_circle_outline_rounded,
                                            color: dtxtclr,
                                            size: wid / 15,
                                          )
                                        ]),
                                  )),
                            ),
                            const Divider(
                              indent: 30,
                            ),
                            SizedBox(
                              height: 50,
                              width: wid * 0.4,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    primary: dtxtclr,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                  ),
                                  onPressed: () {
                                    admincontroller.clear();
                                    Navigator.of(context).pop();
                                  },
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            'CANCEL',
                                            style: TextStyle(
                                              fontSize: wid / 20,
                                              fontWeight: FontWeight.w600,
                                              color: drwrclr,
                                            ),
                                          ),
                                          Icon(
                                            Icons.cancel_outlined,
                                            color: drwrclr,
                                            size: wid / 15,
                                          )
                                        ]),
                                  )),
                            ),
                          ])
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
