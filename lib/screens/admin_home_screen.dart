import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_logic/models/leaveApplicationModel.dart';
import 'package:face_logic/models/userModel.dart';
import 'package:face_logic/screens/profile_screen.dart';
import 'package:face_logic/screens/team_members_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import 'admin_leave_application.dart';
import 'form_screen.dart';
import 'leave_applications_screen.dart';
import 'leave_details.dart';
import 'leave_history.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<String> teamMembers = [];
  List<UserModel> members = [];
  List<LeaveModel> leaveApplications = [];

  void getTeamMember() async {
    final Query query = FirebaseFirestore.instance
        .collection("users")
        .where("teamLead", isEqualTo: user!.uid.toString());

    final snapshot = await query.get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      teamMembers.add(snapshot.docs[i].id);
    }

    final Query query1 = FirebaseFirestore.instance
        .collection("leave_applications")
        .where("teamLead", isEqualTo: user!.uid.toString())
        .where("status", isEqualTo: "pending")
        .limit(3);
    leaveApplications = await query1.get().then((value) => value.docs
        .map<LeaveModel>(
          (e) => LeaveModel.fromDocumentSnapshot(e),
        )
        .toList());

    members = await query.limit(5).get().then((value) => value.docs
        .map<UserModel>(
          (e) => UserModel.fromDocumentSnapshot(e),
        )
        .toList());

    setState(() {});
  }

  @override
  void initState() {
    getTeamMember();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    // print(teamMembers);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Leave Applications"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Applications()));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text("view more"),
                  ),
                )
              ],
            ),
            Container(
              height: h * 0.3,
              child: ListView.builder(
                  cacheExtent: 0.5,
                  scrollDirection: Axis.vertical,
                  itemCount: leaveApplications.length,
                  itemBuilder: ((context, index) {
                    return Card(
                      color:  leaveApplications[index].status == "pending"
                          ? Colors.yellow
                          : leaveApplications[index].status == "approved"
                              ? Colors.green
                              : Colors.red,
                      margin:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      elevation: 5,
                      child: ListTile(
                        title: Text(leaveApplications[index].name),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LeaveDetails(
                                  application: leaveApplications[index])));
                        },
                        subtitle: leaveApplications[index].day == "Full Day"
                            ? Text(
                                "${leaveApplications[index].to.difference(leaveApplications[index].from).inDays} days")
                            : const Text('Half Day'),
                        trailing: Text(leaveApplications[index].status),
                      ),
                    );
                  })),
            ),
            const SizedBox(
              height: 20,
            ),
            _history(context),
            const SizedBox(
              height: 20,
            ),
            _leave(context),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("Team Members"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TeamMembersList()));
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text("view more"),
                  ),
                )
              ],
            ),
            Container(
              height: h * 0.3,
              child: ListView.builder(
                  cacheExtent: 0.5,
                  scrollDirection: Axis.vertical,
                  itemCount: members.length,
                  itemBuilder: ((context, index) {
                    return Card(
                      margin:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      elevation: 5,
                      child: ListTile(
                        title: Text(members[index].name),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProfilePage(
                                    uid: members[index].id,
                                    isAdmin: '',
                                  )));
                        },
                      ),
                    );
                  })),
            ),
          ],
        ),
      ),
      //
    );
  }
}

Widget _history(context) {
  // ignore: deprecated_member_use
  return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(40)),
        backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 18, horizontal: 100)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        )),
      ),
      child: Text(
        "History",
        style: GoogleFonts.montserrat(
            fontSize: 17,
            color: Colors.white,
            letterSpacing: 0.168,
            fontWeight: FontWeight.w600),
      ),
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => LeaveApplicationHistory()));
      });
}

Widget _leave(context) {
  // ignore: deprecated_member_use
  return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size.fromHeight(40)),
        backgroundColor: MaterialStateProperty.all(Colors.greenAccent),
        padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 18, horizontal: 100)),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        )),
      ),
      child: Text(
        "Apply for leave",
        style: GoogleFonts.montserrat(
            fontSize: 17,
            color: Colors.white,
            letterSpacing: 0.168,
            fontWeight: FontWeight.w600),
      ),
      onPressed: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AdminLeaveApplication()));
      });
}
