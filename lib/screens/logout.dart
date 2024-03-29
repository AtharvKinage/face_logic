import 'package:face_logic/screens/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class Logout extends StatelessWidget {
  late final User user;
  // final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          child: Text('Logout'),
          onPressed: () {
            // auth.signOut();
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SignInScreen()));
          },
        ),
      ),
    );
  }
}
