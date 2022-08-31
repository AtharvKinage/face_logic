import 'package:face_logic/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:snippet_coder_utils/FormHelper.dart';
import 'package:snippet_coder_utils/ProgressHUD.dart';

import '../main.dart';

class OtpVerifyPage extends StatefulWidget {
  final String? mobileNo;
  final String? otp;
  const OtpVerifyPage({this.mobileNo, this.otp});

  @override
  State<OtpVerifyPage> createState() => _OtpVerifyPageState();
}

class _OtpVerifyPageState extends State<OtpVerifyPage> {
  String _otpCode = "";
  final int _otpCodeLength = 4;
  bool isAPICallProcess = false;
  late FocusNode myFocusNode;
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();

    SmsAutoFill().listenForCode.call();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ProgressHUD(
          child: verifyOtpUI(),
          inAsyncCall: isAPICallProcess,
          opacity: 0.3,
          key: UniqueKey(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    SmsAutoFill().unregisterListener();
    myFocusNode.dispose();
    super.dispose();
  }

  verifyOtpUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.network(
          "http://i.imgur.com/6aiRpKT.png",
          height: 180,
          fit: BoxFit.contain,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            "OTP Verification",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Center(
          child: Text(
            "Enter  OTP code sent to your mobile \n +91-${widget.mobileNo}",
            maxLines: 2,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
          child: PinFieldAutoFill(
            decoration: UnderlineDecoration(
                textStyle: TextStyle(fontSize: 20, color: Colors.black),
                colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3))),
            currentCode: _otpCode,
            codeLength: _otpCodeLength,
            onCodeChanged: (code) {
              if (code!.length == _otpCodeLength) {
                _otpCode = code;
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Center(
          child: FormHelper.submitButton("Verify", () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => HomeScreen()));
          },
              borderColor: HexColor("#78D0B1"),
              btnColor: HexColor("#78D0B1"),
              txtColor: HexColor("#000000"),
              borderRadius: 20),
        )
      ],
    );
  }
}
