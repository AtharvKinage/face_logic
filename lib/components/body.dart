import 'dart:developer';

import 'package:face_logic/constants.dart';
import 'package:face_logic/screens/camera_screen.dart';
import 'package:face_logic/screens/form_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../screens/calendar_popup_view.dart';
import 'package:flutter/material.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final uid = user?.uid;
FirebaseDatabase database = FirebaseDatabase.instance;
DatabaseReference reference = FirebaseDatabase.instance.ref("users");

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

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
  bool isIntimeMarked = false;
  bool isOuttimeMarked = false;

  String databasejson = '';
  var name = "";
  var photo =
      "https://firebasestorage.googleapis.com/v0/b/facerecognition-d150a.appspot.com/o/profile.jpg?alt=media&token=0f92c782-019e-42ea-890f-06028a9ead23";

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    super.initState();
    database = FirebaseDatabase.instance;
    reference = FirebaseDatabase.instance.ref("users");
  }

  @override
  Widget build(BuildContext context) {
    read_data();
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Container(
      height: h * 0.8,
      child: Stack(
        children: <Widget>[
          Container(
            height: h * 0.2 - 27,
            decoration: BoxDecoration(
                color: kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                )),
          ),
          Positioned(
            bottom: h * 0.3,
            left: 0,
            right: 0,
            top: h * 0.06,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              height: h * 0.18,
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
                SizedBox(height: h * 0.15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      name.toString(),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: h / 80),
                      padding: EdgeInsets.all(5),
                      width: w / 2.4,
                      height: h / 8.5,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: (isIntimeMarked == false)
                            ? Colors.red
                            : Colors.green,
                        elevation: 5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 5)),
                            Text(
                              "In time:",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Please Mark",
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: h / 80),
                      padding: EdgeInsets.all(5),
                      width: w / 2.4,
                      height: h / 8.5,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: (isIntimeMarked == false)
                            ? Colors.red
                            : Colors.green,
                        elevation: 5,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Padding(padding: EdgeInsets.only(top: 5)),
                            Text(
                              "Out time:",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "Please Mark",
                              textAlign: TextAlign.justify,
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                // _timing(),
                Padding(padding: EdgeInsets.only(top: h * 0.01)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20)),
                    Text(
                      "Total Hour: ",
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w500),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(padding: EdgeInsets.only(left: 20)),
                    Text(
                      thrs + " Hr",
                      style: GoogleFonts.poppins(
                          fontSize: 25,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w800),
                    )
                  ],
                ),
              ]),
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            margin: EdgeInsets.symmetric(horizontal: w * 0.33),
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.width / 3,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white, width: h),
              shape: BoxShape.circle,
              color: Colors.white,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(photo),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: h * 0.55, right: 20),
            child: _markAttendence(context),
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, top: h * 0.68, right: 20),
            child: _leave(context),
          ),
          Container(
            padding: EdgeInsets.only(left: 180, top: h * 0.76, right: 20),
            child: Image.asset(
              'assets/images/cognizant.webp',
            ),
          ),
        ],
      ),
    );
  }

  // Widget _timing() {
  //   String inTime = "Please Mark";
  //   String outTime = "Please Mark";
  //   return Container(
  //     width: 300,
  //     margin: EdgeInsets.only(top: 20),
  //     decoration: BoxDecoration(
  //         color: Colors.grey,
  //         border: Border.all(width: 1, color: Colors.black),
  //         borderRadius: const BorderRadius.all(const Radius.circular(20))),
  //     child: Column(
  //       children: [
  //         Padding(padding: EdgeInsets.only()),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Padding(padding: EdgeInsets.only(left: 30)),
  //             Text(
  //               "In Time: " + inTime,
  //               style: GoogleFonts.poppins(
  //                 fontSize: 18,
  //                 color: Colors.greenAccent,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             )
  //           ],
  //         ),
  //         Padding(padding: EdgeInsets.only(top: 3)),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.start,
  //           children: [
  //             Padding(padding: EdgeInsets.only(left: 30)),
  //             Text(
  //               "Out Time: " + outTime,
  //               style: GoogleFonts.poppins(
  //                   fontSize: 18,
  //                   color: Colors.greenAccent,
  //                   fontWeight: FontWeight.w500),
  //             )
  //           ],
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _markAttendence(context) {
    // ignore: deprecated_member_use
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => CameraScreen()));
      },
      child: Text(
        "Mark Attendence",
        style: GoogleFonts.montserrat(
            fontSize: 17,
            color: Colors.white,
            letterSpacing: 0.168,
            fontWeight: FontWeight.w600),
      ),
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size.fromHeight(40)),
        backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 18, horizontal: 100)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        )),
      ),
    );
  }

  Widget _leave(context) {
    // ignore: deprecated_member_use
    return ElevatedButton(
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size.fromHeight(40)),
          backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
          padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 18, horizontal: 100)),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          )),
        ),
        child: Text(
          "Apply for Leave",
          style: GoogleFonts.montserrat(
              fontSize: 17,
              color: Colors.white,
              letterSpacing: 0.168,
              fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LeaveForm()));

          // FocusScope.of(context).requestFocus(FocusNode());

          // showDemoDialog(context: context);
        });
  }

  Future<void> read_data() async {
    reference.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.child(uid.toString()).child("name").value;
      // final img = event.snapshot.child(uid.toString()).child("photo").value;
      setState(() {
        name = data.toString();
        // photo = img.toString();
      });
    });
  }

  void showDemoDialog({BuildContext? context}) {
    showDialog<dynamic>(
      context: context!,
      builder: (BuildContext context) => CalendarPopupView(
        barrierDismissible: true,
        minimumDate: DateTime.now(),
        //  maximumDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 10),
        initialEndDate: endDate,
        initialStartDate: startDate,
        onApplyClick: (DateTime startData, DateTime endData) {
          setState(() {
            startDate = startData;
            endDate = endData;
          });
        },
        onCancelClick: () {},
      ),
    );
  }
}
