import 'package:email_validator/email_validator.dart';
import 'package:face_logic/main.dart';
import 'package:face_logic/screens/home_screen.dart';
import 'package:face_logic/screens/login_screen.dart';
import 'package:face_logic/utils/uitls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData _mediaQueryData = MediaQuery.of(context);
    double screenWidth = _mediaQueryData.size.width;
    double screenHeight = _mediaQueryData.size.height;
    double blockSizeHorizontal = screenWidth / 100;
    double blockSizeVertical = screenHeight / 100;
    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 110, horizontal: 30),
              color: Colors.white,
              width: double.infinity,
              child: Center(
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
                    SizedBox(height: blockSizeVertical * 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "Enter your login details to ",
                          style: GoogleFonts.montserrat(
                            fontSize: 25,
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: blockSizeVertical * 0.5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Text(
                          "access your account ",
                          style: GoogleFonts.montserrat(
                            fontSize: 25,
                            color: Colors.greenAccent,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: blockSizeVertical * 10),
                    _inputField1(),
                    SizedBox(height: blockSizeVertical * 3),
                    _inputField2(),
                    SizedBox(height: blockSizeVertical * 3),
                    _loginbtn(context),
                    SizedBox(height: blockSizeVertical * 10),
                    _passCode()
                  ],
                ),
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
      margin: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: emailController,
        style: GoogleFonts.poppins(
            fontSize: 20,
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
          // suffixIcon: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: FaIcon(
          //     FontAwesomeIcons.checkCircle,
          //     color: Colors.greenAccent,
          //   ),
          // ),
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (email) => email != null && !EmailValidator.validate(email)
            ? 'Enter a valid email'
            : null,
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
      margin: EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: passwordController,
        style: GoogleFonts.poppins(
            fontSize: 20,
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
          // suffixIcon: Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: FaIcon(
          //     FontAwesomeIcons.eye,
          //     color: Color(0xffCDE0C9).withOpacity(0.9),
          //   ),
          // ),
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
        obscureText: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value != null && value.length < 8
            ? 'Enter min. 8 charachters'
            : null,
      ),
    );
  }

  Widget _loginbtn(context) {
    // ignore: deprecated_member_use
    return SizedBox(
      height: 60,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: signIn,
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
            shape: MaterialStateProperty.all(
              new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0),
              ),
            )),
        child: Text(
          "LOG IN",
          style: GoogleFonts.montserrat(
              fontSize: 23,
              color: Colors.white,
              letterSpacing: 0.168,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Widget _passCode() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => LoginOTPPage()));
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Dont't have account?",
            style:
                GoogleFonts.montserrat(fontSize: 20, color: Colors.greenAccent),
          ),
          InkWell(
            child: Text(
              " Signup",
              style: GoogleFonts.montserrat(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginOTPPage()));
            },
          )
        ],
      ),
    );
  }

  Future signIn() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) => Center(child: CircularProgressIndicator())));
    try {
      final user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      if (user != null) {
        // final prefs = await SharedPreferences.getInstance();
        // prefs.setString('email', emailController.text.trim());
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      showSnackBar(context, "Email and password don't match");
      Navigator.of(context).pop();
    }
  }
}
