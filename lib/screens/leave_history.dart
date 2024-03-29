import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_logic/constants.dart';
import 'package:face_logic/screens/leave_details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/leaveApplicationModel.dart';

class LeaveApplicationHistory extends StatefulWidget {
  String? route;
  LeaveApplicationHistory({Key? key, this.route}) : super(key: key);

  @override
  State<LeaveApplicationHistory> createState() =>
      _LeaveApplicationHistoryState();
}

class _LeaveApplicationHistoryState extends State<LeaveApplicationHistory> {
  List<LeaveModel> leaveApplications = [];
  List<LeaveModel> empleaveApplications = [];
  final User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = true;
  getleaveApplications() async {
    final query1, query2;
    if (widget.route == "director") {
      query1 = FirebaseFirestore.instance
          .collection("leave_applications_admins")
          .where("status", isNotEqualTo: "pending");
      query2 = FirebaseFirestore.instance
          .collection("leave_applications")
          .where("status", isNotEqualTo: "pending");

      empleaveApplications = await query2.get().then((value) => value.docs
          .map<LeaveModel>(
            (e) => LeaveModel.fromDocumentSnapshot(e),
          )
          .toList());
    } else {
      query1 = FirebaseFirestore.instance
          .collection("leave_applications")
          .where("teamLead", isEqualTo: user!.uid.toString())
          .where("status", isNotEqualTo: "pending");
    }

    leaveApplications = await query1.get().then((value) => value.docs
        .map<LeaveModel>(
          (e) => LeaveModel.fromDocumentSnapshot(e),
        )
        .toList());
    leaveApplications.addAll(empleaveApplications);
    isLoading = false;
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
          title: Text("Applications history")
          // leading: IconButton(
          //   icon: SvgPicture.asset("assets/icons/menu.svg"),
          //   onPressed: () {},
          // ),
          ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              cacheExtent: 0.5,
              scrollDirection: Axis.vertical,
              itemCount: leaveApplications.length,
              itemBuilder: ((context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  color: leaveApplications[index].status == "approved"
                      ? Colors.green
                      : leaveApplications[index].status == "declined"
                          ? Colors.red
                          : Colors.yellow,
                  margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  elevation: 5,
                  child: ListTile(
                    title: Text(leaveApplications[index].name),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LeaveDetails(
                              application: leaveApplications[index],
                              route: "history")));
                    },
                    subtitle: leaveApplications[index].day == "Full Day"
                        ? Text(
                            "${leaveApplications[index].to.difference(leaveApplications[index].from).inDays+1} days")
                        : const Text('Half Day'),
                    trailing: Text(leaveApplications[index].status),
                  ),
                );
              })),
    );
  }
}
