import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_logic/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/leaveApplicationModel.dart';
import 'leave_details.dart';

class Applications extends StatefulWidget {
  final String? route;
  const Applications({Key? key, this.route}) : super(key: key);

  @override
  State<Applications> createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  List<LeaveModel> leaveApplications = [];
  final User? user = FirebaseAuth.instance.currentUser;
  getleaveApplications() async {
    final query1;
    if (widget.route == "director") {
      query1 = FirebaseFirestore.instance
          .collection("leave_applications_admins")
          .where("status", isEqualTo: "pending");
    } else if (widget.route == "all") {
      query1 = FirebaseFirestore.instance
          .collection("leave_applications")
          .where("status", isEqualTo: "pending");
      ;
    } else {
      query1 = FirebaseFirestore.instance
          .collection("leave_applications")
          .where("teamLead", isEqualTo: user!.uid.toString())
          .where("status", isEqualTo: "pending");
    }

    leaveApplications = await query1.get().then((value) => value.docs
        .map<LeaveModel>(
          (e) => LeaveModel.fromDocumentSnapshot(e),
        )
        .toList());

    setState(() {});
  }

  @override
  void initState() {
    getleaveApplications();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          elevation: 10,
          backgroundColor: kPrimaryColor,
          title: Text("Leave Applications")
          // leading: IconButton(
          //   icon: SvgPicture.asset("assets/icons/menu.svg"),
          //   onPressed: () {},
          // ),
          ),
      body: ListView.builder(
          cacheExtent: 0.5,
          scrollDirection: Axis.vertical,
          itemCount: leaveApplications.length,
          itemBuilder: ((context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              color: leaveApplications[index].status == "pending"
                  ? Colors.yellow
                  : leaveApplications[index].status == "approved"
                      ? Colors.green
                      : Colors.red,
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
              elevation: 5,
              child: ListTile(
                title: Text(leaveApplications[index].name),
                onTap: () {
                  if (widget.route == "director") {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LeaveDetails(
                              application: leaveApplications[index],
                              route: "director",
                            )));
                  } else if (widget.route == "all") {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LeaveDetails(
                              application: leaveApplications[index],
                              route: "history",
                            )));
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => LeaveDetails(
                            application: leaveApplications[index])));
                  }
                },
                subtitle: leaveApplications[index].day == "Full Day"
                    ? Text(
                        "${leaveApplications[index].to.difference(leaveApplications[index].from).inDays + 1} days")
                    : const Text('Half Day'),
                trailing: Text(leaveApplications[index].status),
              ),
            );
          })),
    );
  }
}
