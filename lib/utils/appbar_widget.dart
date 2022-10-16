import 'package:face_logic/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    title: Text("Profile"),
    // leading: BackButton(),
    backgroundColor: kPrimaryColor,
    elevation: 0,
  ); // AppBar
}
