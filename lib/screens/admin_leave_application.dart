import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import '../constants.dart';
import 'home_screen.dart';

class AdminLeaveApplication extends StatefulWidget {
  const AdminLeaveApplication({Key? key}) : super(key: key);

  @override
  State<AdminLeaveApplication> createState() => _AdminLeaveApplicationState();
}

class _AdminLeaveApplicationState extends State<AdminLeaveApplication> {
  final User? user = FirebaseAuth.instance.currentUser;
  CollectionReference leave_form =
      FirebaseFirestore.instance.collection('leave_applications_admins');
  String userName = "";
  String teamLead = '';
  String teamLeadUID = '';
  final items = ['Full Day', 'Half Day'];
  String? selectedItem = 'Full Day';
  final leave_type = [
    'Casual Leave',
    'Compensatory off',
    'Leave without Pay',
    'On Duty',
    'Paternity Leave',
    'Privileage Leave',
    'Sick Leave',
    'Earn leave'
  ];
  String? selected_leave_type = 'Casual Leave';
  String datefrom = "Please Select";
  DateTime startDate = DateTime.now().add(const Duration(days: 5));
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  DateTimeRange dateRange =
      DateTimeRange(start: DateTime.now(), end: DateTime.now());

  final _reason = TextEditingController();
  bool _validateReason = false;

  void getUserData() async {
    final uid = user?.uid;
    final adminCollection = FirebaseFirestore.instance
        .collection("admins")
        .doc(user!.uid.toString());
    final snapshot = await adminCollection.get().then((value) async {
      userName = value.get('name');

      final snapshot1 = await FirebaseFirestore.instance
          .collection("director")
          .doc(value.get('director'))
          .get();
      setState(() {
        teamLead = snapshot1.get('name');
        teamLeadUID = value.get('director');
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    String start =
        DateFormat("EEEEE, dd MMMM yyyy").format(startDate).toString();
    String end = DateFormat("EEEEE, dd MMMM yyyy").format(endDate).toString();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Leave Form'),
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
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.black,
                            fontWeight: FontWeight.w300),
                        isExpanded: true,
                        iconSize: 36,
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.black),
                        value: selectedItem,
                        items: items
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item,
                                      style: const TextStyle(
                                        fontSize: 24,
                                      )),
                                ))
                            .toList(),
                        onChanged: (item) =>
                            setState(() => selectedItem = item),
                      ),
                    ))
              ],
            ),
            SizedBox(
              height: h * 0.02,
            ),
            (selectedItem == "Full Day")
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
                            GestureDetector(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now()
                                     ,
                                    firstDate: DateTime.now()
                                      ,
                                    lastDate: DateTime(2100));

                                if (pickedDate != null) {
                                  startDate = pickedDate;
                                  setState(() {});
                                } else {}
                              },
                              child: Container(
                                  width: w * 0.425,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: Text(start)),
                            ),
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
                            GestureDetector(
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now()
                                        ,
                                    firstDate: DateTime.now()
                                      ,
                                    lastDate: DateTime(2050));

                                if (pickedDate != null) {
                                  endDate = pickedDate;
                                  setState(() {});
                                } else {}
                              },
                              child: Container(
                                  width: w * 0.425,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: Colors.black, width: 1),
                                  ),
                                  child: Text(end)),
                            ),
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
                        GestureDetector(
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate:
                                    DateTime.now(),
                                firstDate:
                                    DateTime.now(),
                                lastDate: DateTime(2100));

                            if (pickedDate != null) {
                              startDate = pickedDate;
                              setState(() {});
                            } else {}
                          },
                          child: Container(
                              width: w * 0.9,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:
                                    Border.all(color: Colors.black, width: 1),
                              ),
                              child: Text(start,
                                  style: const TextStyle(
                                      fontSize: 25.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300))),
                        ),
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
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                    isExpanded: true,
                    iconSize: 36,
                    icon:
                        const Icon(Icons.arrow_drop_down, color: Colors.black),
                    value: selected_leave_type,
                    items: leave_type
                        .map((item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(item,
                                  style: const TextStyle(
                                    fontSize: 24,
                                  )),
                            ))
                        .toList(),
                    onChanged: (item) =>
                        setState(() => selected_leave_type = item),
                  ),
                ),
              )
            ]),
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
                  "PRINCIPAL:",
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
                  child: Text(
                    teamLead,
                    style: TextStyle(
                        fontSize: 25.0,
                        color: Colors.black,
                        fontWeight: FontWeight.w300),
                  ))
            ]),
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
                  child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide reason';
                        }
                        return null;
                      },
                      controller: _reason,
                      maxLines: 8,
                      decoration: const InputDecoration(
                        hintText: "Write a Reason",
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                      ),
                      style:
                          const TextStyle(fontSize: 20, color: Colors.black)))
            ]),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ElevatedButton(
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
                    await leave_form.add({
                      "name": userName,
                      "day": selectedItem,
                      "from": DateFormat("EEEEE, dd MMMM yyyy").parse(start),
                      "to": DateFormat("EEEEE, dd MMMM yyyy").parse(end),
                      "reason": _reason.text,
                      "leave_type": selected_leave_type,
                      "uid": user!.uid.toString(),
                      "status": "pending",
                      "director": teamLeadUID
                    }).then((_) {
                      Fluttertoast.showToast(
                          msg: "Leave Application sent sucessfully",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.SNACKBAR,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => HomeScreen()));
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
                child: const Text(
                  "Submit",
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 0.168,
                      fontWeight: FontWeight.w400),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
