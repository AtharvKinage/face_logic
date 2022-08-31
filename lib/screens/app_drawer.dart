import 'package:face_logic/screens/form_screen.dart';
import 'package:face_logic/screens/home_screen.dart';
import 'package:face_logic/screens/profile_screen.dart';
import 'package:face_logic/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class AppDrawer extends StatelessWidget {
  // final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text("Face Logic"),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomeScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help),
            title: Text('Profile'),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfilePage()));
            },
          ),
          Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded),
            title: Text('Log Out'),
            onTap: () {
              // auth.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginOTPPage()));
            },
          ),
        ],
      ),
    );
  }
}
