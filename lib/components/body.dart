import 'package:face_logic/constants.dart';
import 'package:face_logic/screens/camera_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final uid = user?.uid;
FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference reference = FirebaseDatabase.instance.ref("Users").child('PiLOoilOQYawB54EsABaOdbu3D93').child('Name');

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        children: <Widget>[
          Header(size: size),
        ],
      ),
    );
  }
}

class Header extends StatefulWidget {
  const Header({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<Header> createState() => _HeaderState();
}

class _HeaderState extends State<Header> {
  String date = DateFormat("EEEEE, dd MMMM yyyy").format(DateTime.now());
  String thrs = "0";
  late DatabaseReference reference = FirebaseDatabase.instance.ref("Users");
  String databasejson = '';
  var name;

  @override
  void initState() {
    super.initState();
    reference = FirebaseDatabase.instance.ref("Users");
    reference.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      print(uid.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height * 0.8,
      child: Stack(
        children: <Widget>[
          Container(
            height: widget.size.height * 0.2 - 27,
            decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                )),
          ),
          Positioned(
            bottom: 250,
            left: 0,
            right: 0,
            top: 50,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              height: 150,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 50,
                      color: kPrimaryColor.withOpacity(0.23),
                    )
                  ]),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
              child: Column(children: [
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(height: 120),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Atharv",
                      style: GoogleFonts.poppins(
                        fontSize: 35,
                        color: Color(0xff205072),
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
                Padding(padding: EdgeInsets.only()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      date,
                      style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                _timing(),
                Padding(padding: EdgeInsets.only(top: 50)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20)),
                    Text(
                      "Total Hour: " + thrs + " hr",
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
              ]),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.symmetric(horizontal: 125),
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: 5),
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/profile.jpg'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 420),
            child: _markAttendence(context),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 520),
            child: _leave(context),
          ),
        ],
      ),
    );
  }

  Widget _timing() {
    String inTime = "Please Mark";
    String outTime = "Please Mark";
    return Container(
      width: 300,
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          color: Colors.grey,
          border: Border.all(width: 1, color: Colors.black),
          borderRadius: const BorderRadius.all(const Radius.circular(20))),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.only()),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 30)),
              Text(
                "In Time: " + inTime,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 3)),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(padding: EdgeInsets.only(left: 30)),
              Text(
                "Out Time: " + outTime,
                style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.w500),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _markAttendence(context) {
    // ignore: deprecated_member_use
    return FlatButton(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 100),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0),
        ),
        child: Text(
          "Mark Attendence",
          style: GoogleFonts.montserrat(
              fontSize: 17,
              color: Colors.white,
              letterSpacing: 0.168,
              fontWeight: FontWeight.w600),
        ),
        color: Colors.greenAccent,
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => CameraScreen()));
        });
  }

  Widget _leave(context) {
    // ignore: deprecated_member_use
    return FlatButton(
        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 100),
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(20.0),
        ),
        child: Text(
          "Apply for Leave",
          style: GoogleFonts.montserrat(
              fontSize: 17,
              color: Colors.white,
              letterSpacing: 0.168,
              fontWeight: FontWeight.w600),
        ),
        color: Colors.greenAccent,
        onPressed: () async {
          reference.onValue.listen((DatabaseEvent event) {
            final data = event.snapshot.value;
            print('amey' + data.toString());
          });
        });
  }
}
