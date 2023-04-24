import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_logic/components/body.dart';
import 'package:face_logic/constants.dart';
import 'package:face_logic/screens/app_drawer.dart';
import 'package:face_logic/screens/director_home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'admin_home_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  String isAdmin = "";
  String isDirector = '';

  void checkifAdmin() async {
    final userCollection = FirebaseFirestore.instance
        .collection("admins")
        .doc(user!.uid.toString());

    final snapshot = await userCollection.get();
    if (snapshot.exists) {
      isAdmin = "true";
    } else {
      isAdmin = "false";
    }
  }

  void checkifDirector() async {
    if (mounted) {
      final userCollection = FirebaseFirestore.instance
          .collection("director")
          .doc(user!.uid.toString());

      final snapshot = await userCollection.get();
      if (snapshot.exists) {
        isDirector = "true";
        setState(() {});
      } else {
        isDirector = "false";
        setState(() {});
      }
    }
  }

  @override
  void initState() {
    checkifAdmin();
    checkifDirector();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkifAdmin();
    checkifDirector();
    return isAdmin == ""
        ? Scaffold(
            body: Container(),
          )
        : WillPopScope(
            onWillPop: _exit,
            child: Scaffold(
              appBar: buildAppBar(isAdmin),
              drawer: isDirector == "true"
                  ? AppDrawer("Director")
                  : AppDrawer(isAdmin),
              body: isAdmin == "true"
                  ? AdminHome()
                  : isDirector == "true"
                      ? DirectorHome()
                      : Header(),
            ),
          );
  }

  AppBar buildAppBar(isAdmin) {
    return AppBar(
      elevation: 10,
      backgroundColor: kPrimaryColor,
      title: isAdmin == "true"
          ? Text("Admin Dashboard")
          : isDirector == "true"
              ? Text("Director Dashboard")
              : Text("Employee Dashboard"),
      // leading: IconButton(
      //   icon: SvgPicture.asset("assets/icons/menu.svg"),
      //   onPressed: () {},
      // ),
    );
  }

  Future<bool> _exit() async {
    Navigator.of(context).pop(true);
    exit(0);
    return await true;
  }
}
