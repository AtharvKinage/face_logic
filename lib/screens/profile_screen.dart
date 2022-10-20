import 'package:face_logic/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/appbar_widget.dart';
import '../utils/profile_widget.dart';
import '../utils/textfield_widget.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final User? user = FirebaseAuth.instance.currentUser;
  DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  final nameController = TextEditingController();
  final empEmailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  String _selectedGender = 'male';
  DateTime selectedDate = DateTime.now();
  var empName = "",
      empEmail = "",
      empPhoneNumber = "",
      empdob = "",
      empgender = "";

  @override
  Widget build(BuildContext context) {
    read_data();
    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 32),
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            imagePath:
                "https://firebasestorage.googleapis.com/v0/b/facerecognition-d150a.appspot.com/o/profile.jpg?alt=media&token=0f92c782-019e-42ea-890f-06028a9ead23",
            isEdit: true,
            onClicked: () async {},
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Employee Name",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                controller: nameController..text = empName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 1,
              ),
            ],
          ),
          // const SizedBox(height: 24),
          // TextFieldWidget(
          //   controller: emailController,
          //   label: 'User Id',
          //   text: "S4829",
          //   onChanged: (userId) {},
          // ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Email Id",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                controller: empEmailController..text = empEmail,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 1,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Phone Number",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              TextFormField(
                readOnly: true,
                controller: phoneNumberController..text = empPhoneNumber,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 1,
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            "Date of Birth",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 8),
          TextField(
            readOnly: true,
            // onTap: () {
            //   _selectDate(context);
            // },
            decoration: InputDecoration(
              hintText: empdob,
              hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            "Gender",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          ListTile(
            leading: Radio<String>(
              value: 'male',
              groupValue: empgender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            title: const Text('Male'),
          ),
          ListTile(
            leading: Radio<String>(
              value: 'female',
              groupValue: empgender,
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
            title: const Text('Female'),
          ),
          const SizedBox(height: 20),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     primary: kPrimaryColor,
          //     minimumSize: const Size.fromHeight(50),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //   ),
          //   onPressed: () {},
          //   child: const Text(
          //     'Submit',
          //     style: TextStyle(fontSize: 24),
          //   ),
          // ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future<void> read_data() async {
    ref.onValue.listen((DatabaseEvent event) {
      final empname =
          event.snapshot.child(user!.uid.toString()).child("name").value;
      // final UserId = event.snapshot.child(user!.uid.toString()).child("photo").value;
      var email =
          event.snapshot.child(user!.uid.toString()).child("email").value;
      var phoneNumber =
          event.snapshot.child(user!.uid.toString()).child("phoneNumber").value;
      var gender =
          event.snapshot.child(user!.uid.toString()).child("gender").value;
      var dob = event.snapshot.child(user!.uid.toString()).child("dob").value;

      setState(() {
        empName = empname.toString();
        empEmail = email.toString();
        empPhoneNumber = phoneNumber.toString();
        empdob = dob.toString();
        empgender = gender.toString();
      });
    });
  }

  // @override
  // void dispose() {
  //   empEmailController.dispose();
  //   phoneNumberController.dispose();
  //   nameController.dispose();

  //   super.dispose();
  // }
}
