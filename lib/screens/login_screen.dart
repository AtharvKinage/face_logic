import 'dart:developer';
import 'package:face_logic/screens/logout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/config.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  bool _isProcessing = false;
  late String _email, _password;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 110, horizontal: 30),
              color: Colors.white,
              width: double.infinity,
              child: Column(
                children: [
                  Padding(padding: EdgeInsets.only()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "FaceLogic",
                        style: GoogleFonts.poppins(
                          fontSize: 40,
                          color: Color(0xff205072),
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 5),
                  Padding(padding: EdgeInsets.only(top: 50)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "Enter your login details to ",
                        style: GoogleFonts.poppins(
                            fontSize: 25,
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.w500),
                      )
                    ],
                  ),
                  SizedBox(height: SizeConfig.blockSizeVertical * 0.5),
                  Padding(padding: EdgeInsets.only()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "access your account ",
                        style: GoogleFonts.poppins(
                          fontSize: 25,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.blockSizeVertical * 10,
                  ),
                  _inputField1(),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  _inputField2(),
                  SizedBox(height: SizeConfig.blockSizeVertical * 3),
                  _loginbtn(context),
                  SizedBox(height: SizeConfig.blockSizeVertical * 10),
                  _passCode()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputField1() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(100),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 25,
            offset: Offset(0, 5),
            spreadRadius: -25,
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 20, top: 60),
      child: TextField(
        controller: _emailTextController,
        style: GoogleFonts.poppins(
            fontSize: 19,
            color: Colors.black,
            letterSpacing: 0.24,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: "Email address",
          hintStyle: TextStyle(
            color: Color(0xffA6B0BD),
          ),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FaIcon(
              FontAwesomeIcons.checkCircle,
              color: Colors.greenAccent,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(1),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(1),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _email = value.trim();
          });
        },
      ),
    );
  }

  Widget _inputField2() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 25,
            offset: Offset(0, 5),
            spreadRadius: -25,
          ),
        ],
      ),
      margin: EdgeInsets.only(bottom: 60),
      child: TextField(
        controller: _passwordTextController,
        style: GoogleFonts.poppins(
            fontSize: 19,
            color: Colors.black,
            letterSpacing: 0.24,
            fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          hintText: "Password",
          hintStyle: TextStyle(
            color: Color(0xffA6B0BD),
          ),
          fillColor: Colors.white,
          filled: true,
          suffixIcon: GestureDetector(
            onTap: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
            child: FaIcon(
              _obscureText ? FontAwesomeIcons.eyeSlash : FontAwesomeIcons.eye,
              color: Color(0xffCDE0C9).withOpacity(0.9),
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(1),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(1),
            ),
            borderSide: BorderSide(color: Colors.white),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _password = value.trim();
          });
        },
        obscureText: _obscureText,
      ),
    );
  }

  Widget _loginbtn(context) {
    // ignore: deprecated_member_use
    return FlatButton(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 120),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0),
        ),
        child: Text(
          "LOG IN",
          style: GoogleFonts.montserrat(
              fontSize: 23,
              color: Colors.white,
              letterSpacing: 0.168,
              fontWeight: FontWeight.w600),
        ),
        color: Colors.greenAccent,
        onPressed: () {
          try {
            auth
                .signInWithEmailAndPassword(email: _email, password: _password)
                .then((_) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            });
          } catch (error) {
            Fluttertoast.showToast(
                msg: "This is Center Short Toast",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
          }
        });
  }

  Widget _passCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(padding: EdgeInsets.only(top: 20.0)),
        Text(
          "",
          style: GoogleFonts.poppins(fontSize: 20, color: Colors.greenAccent),
        ),
        InkWell(
          child: Text(
            "",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {},
        )
      ],
    );
  }
}
