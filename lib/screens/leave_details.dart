import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_logic/constants.dart';
import 'package:face_logic/models/leaveApplicationModel.dart';

import 'package:face_logic/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class LeaveDetails extends StatefulWidget {
  final LeaveModel application;
  final String? route;
  LeaveDetails({Key? key, required this.application, this.route})
      : super(key: key);

  @override
  State<LeaveDetails> createState() => _LeaveDetailsState();
}

class _LeaveDetailsState extends State<LeaveDetails> {
  TwilioFlutter twilioFlutter = TwilioFlutter(
      accountSid: dotenv.env['accountSid']!,
      authToken: dotenv.env['authToken']!,
      twilioNumber: dotenv.env['twilioNumber']!);
  bool isDirectorAprroved = false;

  @override
  Widget build(BuildContext context) {
    CollectionReference leave_form;
    CollectionReference user_ref;
    if (widget.route == "director") {
      leave_form =
          FirebaseFirestore.instance.collection('leave_applications_admins');
      user_ref = FirebaseFirestore.instance.collection('admins');
    } else {
      leave_form = FirebaseFirestore.instance.collection('leave_applications');
      user_ref = FirebaseFirestore.instance.collection('users');
    }

    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Leave Details'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    "Day:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: w * 0.05),
                  width: w * 0.9,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                  child: Text(widget.application.day,
                      style: const TextStyle(
                        fontSize: 18,
                      )),
                )
              ],
            ),
            SizedBox(
              height: h * 0.02,
            ),
            (widget.application.day == "Full Day")
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "From:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Container(
                                width: w * 0.425,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                                child: Text(DateFormat("EEEEE, dd MMMM yyyy")
                                    .format(widget.application.from))),
                          ],
                        ),
                        SizedBox(
                          width: w * 0.05,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            const Text(
                              "To:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Container(
                                width: w * 0.425,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.black, width: 1),
                                ),
                                child: Text(DateFormat("EEEEE, dd MMMM yyyy")
                                    .format(widget.application.to))),
                          ],
                        )
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: w * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Date:",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Container(
                            width: w * 0.9,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.black, width: 1),
                            ),
                            child: Text(
                                DateFormat("EEEEE, dd MMMM yyyy")
                                    .format(widget.application.from),
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400))),
                      ],
                    ),
                  ),
            SizedBox(
              height: h * 0.02,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Leave Type:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                margin: EdgeInsets.symmetric(horizontal: w * 0.05),
                width: w * 0.9,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Text(widget.application.leaveType,
                    style: const TextStyle(
                      fontSize: 18,
                    )),
              )
            ]),
            // SizedBox(
            //   height: h * 0.02,
            // ),
            // Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            //   const SizedBox(
            //     height: 10,
            //   ),
            //   const Padding(
            //     padding: EdgeInsets.only(left: 20),
            //     child: Text(
            //       "Approver:",
            //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            //     ),
            //   ),
            //   const SizedBox(height: 8),
            //   Container(
            //       margin: EdgeInsets.symmetric(horizontal: w * 0.05),
            //       width: w * 0.9,
            //       padding:
            //           const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            //       decoration: BoxDecoration(
            //         borderRadius: BorderRadius.circular(12),
            //         border: Border.all(color: Colors.black, width: 1),
            //       ),
            //       child: const Text(
            //         "Not assigned",
            //         style: TextStyle(
            //             fontSize: 25.0,
            //             color: Colors.black,
            //             fontWeight: FontWeight.w300),
            //       ))
            // ]),
            SizedBox(
              height: h * 0.02,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  "Reason:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                margin: EdgeInsets.symmetric(horizontal: w * 0.05),
                width: w * 0.9,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black, width: 1),
                ),
                child: Text(widget.application.reason,
                    style: const TextStyle(
                      fontSize: 18,
                    )),
              )
            ]),
            if (widget.route != "history")
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        String phoneNumber = '';
                        String hodPhoneNumber='';
                        
                        await user_ref
                            .doc(widget.application.uid)
                            .get()
                            .then((value) {
                          phoneNumber = value.get('phoneNumber');
                          String hodUID = value.get('teamLead');
                    
                          FirebaseFirestore.instance.collection('admins').doc(hodUID).get().then((value) {
                            hodPhoneNumber=value.get('phoneNumber');
            
                          });
                        });
                        String field = "approved_by_admin";
                        String value = "true";
                        print(widget.route);
                        if (widget.route == "directorApproval" ||
                            widget.route == "director") {
                          field = "status";
                          value = "approved";
                          isDirectorAprroved = true;
                        }
                        await leave_form
                            .doc(widget.application.id)
                            .update({field: value}).then((value) {
                          String dateRange = '';
                          if (widget.application.day == 'Full Day') {
                            dateRange = DateFormat("dd MMMM")
                                    .format(widget.application.from) +
                                " to " +
                                DateFormat("dd MMMM yyyy")
                                    .format(widget.application.to);
                          } else {
                            dateRange = DateFormat("dd MMMM yyyy")
                                .format(widget.application.from);
                          }
                          if (isDirectorAprroved){
                            twilioFlutter.sendSMS(
                                toNumber: phoneNumber,
                                messageBody:
                                    "Dear ${widget.application.name} your ${widget.application.leaveType} from ${dateRange} is approved");

                                     twilioFlutter.sendSMS(
                                toNumber: hodPhoneNumber,
                                messageBody:
                                    "Dear HOD, ${widget.application.leaveType} for ${widget.application.name} from ${dateRange} is approved");
                       
                       } });
                        Fluttertoast.showToast(
                            msg: "Leave Application approved",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.SNACKBAR,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryColor),
                      ),
                      child: const Text(
                        "Approve",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            letterSpacing: 0.168,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(width: w * 0.1),
                    ElevatedButton(
                      onPressed: () async {
                        String phoneNumber = '';
                        await user_ref
                            .doc(widget.application.uid)
                            .get()
                            .then((value) {
                          phoneNumber = value.get('phoneNumber');
                        });
                        await leave_form
                            .doc(widget.application.id)
                            .update({"status": "declined"}).then((value) {
                          String dateRange = '';
                          if (widget.application.day == 'Full Day') {
                            dateRange = DateFormat("dd MMMM")
                                    .format(widget.application.from) +
                                " to " +
                                DateFormat("dd MMMM yyyy")
                                    .format(widget.application.to);
                          } else {
                            dateRange = DateFormat("dd MMMM yyyy")
                                .format(widget.application.from);
                          }
                          if (widget.route == "directorApproval" ||
                              widget.route == "director") {
                            isDirectorAprroved = true;
                          }
                          if (isDirectorAprroved)
                            twilioFlutter.sendSMS(
                                toNumber: phoneNumber,
                                messageBody:
                                    "Dear ${widget.application.name}\nYour leave application for ${widget.application.leaveType} on ${dateRange} has been rejected.");
                        });
                        Fluttertoast.showToast(
                            msg: "Leave Application declined",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.SNACKBAR,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        if (widget.route == "director") {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        } else {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        }
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      child: const Text(
                        "Decline",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            letterSpacing: 0.168,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                  ],
                ),
              )
          ],
        ),
      ),
    );
  }
}
