import 'package:face_logic/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'calendar_popup_view.dart';
import 'home_screen.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final User? user = auth.currentUser;
final uid = user?.uid;

class LeaveForm extends StatefulWidget {
  @override
  _LeaveFormState createState() => _LeaveFormState();
}

class _LeaveFormState extends State<LeaveForm> {
  final items = ['Full Day', 'Half Day'];
  String? selectedItem = 'Full Day';
  String datefrom = "Please Select";
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  DateTimeRange dateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  DatabaseReference ref = FirebaseDatabase.instance.ref("leave_applications");

  final _reason = TextEditingController();
  bool _validateReason = false;

  @override
  Widget build(BuildContext context) {
    String start =
        DateFormat("EEEEE, dd MMMM yyyy").format(startDate).toString();
    String end = DateFormat("EEEEE, dd MMMM yyyy").format(endDate).toString();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Leave Form'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              width: 380,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  iconSize: 36,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.black),
                  value: selectedItem,
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item,
                                style: TextStyle(
                                  fontSize: 24,
                                )),
                          ))
                      .toList(),
                  onChanged: (item) => setState(() => selectedItem = item),
                ),
              )),
          SizedBox(
            height: 20,
          ),
          if (selectedItem == "Full Day")
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ButtonStyle(),
                    child: Text(start),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      showDemoDialog(context: context);
                    },
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: ElevatedButton(
                    child: Text(end),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(FocusNode());

                      showDemoDialog(context: context);
                    },
                  ),
                ),
              ],
            ),
          Container(
              height: 150,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please provide reason';
                    }
                    return null;
                  },
                  controller: _reason,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: "Write a Reason",
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  style: TextStyle(fontSize: 20, color: Colors.black))),
          ElevatedButton(
            onPressed: () async {
              _reason.text.isEmpty
                  ? _validateReason = true
                  : _validateReason = false;

              if (_reason.text.isEmpty) {
                Fluttertoast.showToast(
                    msg: "Please provide reason",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.SNACKBAR,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                await ref
                    .child(uid.toString())
                    .child(DateFormat("dd MMMM yyyy").format(DateTime.now()))
                    .update({
                  "name": user!.email,
                  "type": selectedItem,
                  "from": start,
                  "to": end,
                  "reason": _reason.text
                }).then((_) {
                  Fluttertoast.showToast(
                      msg: "Leave Application sent sucessfully",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.SNACKBAR,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                });
              }
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              )),
              backgroundColor: MaterialStateProperty.all(kPrimaryColor),
            ),
            child: Text(
              "Submit",
              style: GoogleFonts.montserrat(
                  fontSize: 23,
                  color: Colors.white,
                  letterSpacing: 0.168,
                  fontWeight: FontWeight.w400),
            ),
          )
        ],
      ),
    );
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
