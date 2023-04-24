import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_logic/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/leaveApplicationModel.dart';
import 'leave_details.dart';

class MyLeave extends StatefulWidget {
  final String isAdmin;
  const MyLeave({Key? key, required this.isAdmin}) : super(key: key);

  @override
  State<MyLeave> createState() => _MyLeaveState();
}

class _MyLeaveState extends State<MyLeave> {
  List<LeaveModel> leaveApplications = [];
  final User user = FirebaseAuth.instance.currentUser!;
  bool isLoading = true;
  getleaveApplications() async {
    final query1;
    if (widget.isAdmin == "true") {
      query1 = FirebaseFirestore.instance
          .collection("leave_applications_admins")
          .where("uid", isEqualTo: user.uid);
    } else {
      query1 = FirebaseFirestore.instance
          .collection("leave_applications")
          .where("uid", isEqualTo: user.uid);
    }

    leaveApplications = await query1.get().then((value) => value.docs
        .map<LeaveModel>(
          (e) => LeaveModel.fromDocumentSnapshot(e),
        )
        .toList());

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
    return Scaffold(
      appBar: AppBar(
          elevation: 10,
          backgroundColor: kPrimaryColor,
          title: Text("My Leaves")
          // leading: IconButton(
          //   icon: SvgPicture.asset("assets/icons/menu.svg"),
          //   onPressed: () {},
          // ),
          ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
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
                            "${leaveApplications[index].to.difference(leaveApplications[index].from).inDays + 1} days")
                        : const Text('Half Day'),
                    trailing: Text(leaveApplications[index].status),
                  ),
                );
              })),
    );
  }
}
