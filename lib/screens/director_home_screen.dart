import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_logic/models/leaveApplicationModel.dart';
import 'package:face_logic/models/userModel.dart';
import 'package:face_logic/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

import 'form_screen.dart';
import 'leave_applications_screen.dart';
import 'leave_details.dart';
import 'leave_history.dart';

class DirectorHome extends StatefulWidget {
  const DirectorHome({Key? key}) : super(key: key);

  @override
  State<DirectorHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<DirectorHome> {
  final User? user = FirebaseAuth.instance.currentUser;
  List<String> teamMembers = [];
  List<UserModel> members = [];
  List<LeaveModel> leaveApplications = [];
  List<LeaveModel> allleaveApplications = [];

  void getTeamMember() async {
    final Query query = FirebaseFirestore.instance
        .collection("admins")
        .where("director", isEqualTo: user!.uid.toString());

    final snapshot = await query.get();
    for (int i = 0; i < snapshot.docs.length; i++) {
      teamMembers.add(snapshot.docs[i].id);
    }

    final Query query1 = FirebaseFirestore.instance
        .collection("leave_applications_admins")
        .where("director", isEqualTo: user!.uid.toString())
        .where("status", isEqualTo: "pending")
        .limit(3);
    leaveApplications = await query1.get().then((value) => value.docs
        .map<LeaveModel>(
          (e) => LeaveModel.fromDocumentSnapshot(e),
        )
        .toList());
    setState(() {});
    final Query query2 =
        FirebaseFirestore.instance.collection("leave_applications").limit(3);
    allleaveApplications =
        await query2.limit(3).get().then((value) => value.docs
            .map<LeaveModel>(
              (e) => LeaveModel.fromDocumentSnapshot(e),
            )
            .toList());
    setState(() {});
    members = await query.get().then((value) => value.docs
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
                        builder: (context) =>
                            const Applications(route: "director")));
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
                      color: Colors.yellow,
                      margin:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      elevation: 5,
                      child: ListTile(
                        title: Text(leaveApplications[index].name),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LeaveDetails(
                                    application: leaveApplications[index],
                                    route: "director",
                                  )));
                        },
                        subtitle: Text(leaveApplications[index]
                            .to
                            .difference(leaveApplications[index].from)
                            .inDays
                            .toString()),
                        trailing: Text(leaveApplications[index].status),
                      ),
                    );
                  })),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Text("All Applications"),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            const Applications(route: "all")));
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
                  itemCount: allleaveApplications.length,
                  itemBuilder: ((context, index) {
                    return Card(
                      color: allleaveApplications[index].status == "pending"
                          ? Colors.yellow
                          : allleaveApplications[index].status == "approved"
                              ? Colors.green
                              : Colors.red,
                      margin:
                          const EdgeInsets.only(top: 10, left: 10, right: 10),
                      elevation: 5,
                      child: ListTile(
                        title: Text(allleaveApplications[index].name),
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => LeaveDetails(
                                    application: allleaveApplications[index],
                                    route: "history",
                                  )));
                        },
                        subtitle: allleaveApplications[index].day == "Full Day"
                            ? Text(allleaveApplications[index]
                                    .to
                                    .difference(
                                        allleaveApplications[index].from)
                                    .inDays
                                    .toString() +
                                " day")
                            : const Text("Half Day"),
                        trailing: Text(allleaveApplications[index].status),
                      ),
                    );
                  })),
            ),
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
                  onTap: () {},
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
                                    isAdmin: 'true',
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
        "History",
        style: GoogleFonts.montserrat(
            fontSize: 17,
            color: Colors.white,
            letterSpacing: 0.168,
            fontWeight: FontWeight.w600),
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LeaveApplicationHistory(
                  route: "director",
                )));

        // FocusScope.of(context).requestFocus(FocusNode());

        // showDemoDialog(context: context);
      });
}
