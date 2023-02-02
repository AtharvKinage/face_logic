import 'package:face_logic/main.dart';
import 'package:face_logic/screens/otp_verify_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

class LoginOTPPage extends StatefulWidget {
  const LoginOTPPage({Key? key}) : super(key: key);

  static String verify = "";
  static String phoneNumber = "";

  @override
  State<LoginOTPPage> createState() => _LoginOTPPageState();
}

class _LoginOTPPageState extends State<LoginOTPPage> {
  String mobileNo = '';
  bool isAPICallProcess = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ProgressHUD(
          child: loginUI(),
          inAsyncCall: isAPICallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  loginUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network("https://i.imgur.com/bOCEVJg.png",
            height: 180, fit: BoxFit.contain),
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Center(
            child: Text(
              "Login with a Mobile number",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        const Center(
          child: Text(
            "Enter your mobile number we will send you OTP to verify",
            style: TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                  child: Container(
                height: 47,
                width: 50,
                margin: const EdgeInsets.fromLTRB(0, 10, 3, 30),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey)),
                child: const Center(
                  child: Text(
                    "+91",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
              )),
              Flexible(
                flex: 5,
                child: TextFormField(
                  onFieldSubmitted: (value) {
                    mobileNo = value;
                  },
                  maxLines: 1,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(6),
                    hintText: "Mobile Number",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 1),
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    )),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    )),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (String value) {
                    if (value.length > 9) {
                      mobileNo = value;
                    }
                  },
                ),
              )
            ],
          ),
        ),
        Center(
          child: FormHelper.submitButton("Continue", () async {
            await FirebaseAuth.instance.verifyPhoneNumber(
              phoneNumber: '+91 $mobileNo',
              verificationCompleted: (PhoneAuthCredential credential) {},
              verificationFailed: (FirebaseAuthException e) {},
              codeSent: (String verificationId, int? resendToken) {
                LoginOTPPage.verify = verificationId;
                LoginOTPPage.phoneNumber = '+91$mobileNo';
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const OtpVerifyPage()));
              },
              codeAutoRetrievalTimeout: (String verificationId) {},
            );
          },
              borderColor: HexColor("#78D0B1"),
              btnColor: HexColor("#78D0B1"),
              txtColor: HexColor("#000000"),
              borderRadius: 20),
        ),
        const SizedBox(
          height: 10,
        ),
        // Padding(
        //   padding: const EdgeInsets.only(top: 20),
        //   child: InkWell(
        //     onTap: () {
        //       Navigator.of(context).pushReplacement(
        //           MaterialPageRoute(builder: (context) => RegistrationPage()));
        //     },
        //     child: new Text(
        //       "Not Registered? Signup",
        //       style: TextStyle(fontSize: 14),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
