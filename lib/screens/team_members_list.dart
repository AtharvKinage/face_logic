import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:face_logic/constants.dart';
import 'package:face_logic/screens/profile_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../models/userModel.dart';

class TeamMembersList extends StatefulWidget {
  const TeamMembersList({Key? key}) : super(key: key);

  @override
  State<TeamMembersList> createState() => _TeamMembersListState();
}

class _TeamMembersListState extends State<TeamMembersList> {
  List<UserModel> members = [];
  final User? user = FirebaseAuth.instance.currentUser;
  void getTeamMember() async {
    final query = FirebaseFirestore.instance
        .collection("users")
        .where("teamLead", isEqualTo: user!.uid.toString());

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Members'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
      ),
      body: ListView.builder(
          cacheExtent: 0.5,
          scrollDirection: Axis.vertical,
          itemCount: members.length,
          itemBuilder: ((context, index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
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
    );
  }
}
