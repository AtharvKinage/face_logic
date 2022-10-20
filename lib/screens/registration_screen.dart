import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:face_logic/constants.dart';
import 'package:face_logic/screens/home_screen.dart';
import 'package:face_logic/screens/login_screen.dart';
import 'package:face_logic/utils/fire_auth.dart';
import 'package:face_logic/utils/uitls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/appbar_widget.dart';
import '../utils/profile_widget.dart';
import '../utils/textfield_widget.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  DatabaseReference ref = FirebaseDatabase.instance.ref("users");
  // CollectionReference users = FirebaseFirestore.instance.collection('users');
  // String empName = "";
  // String email = "";
  // String mobileNumber = "";
  final formKey = GlobalKey<FormState>();
  final empNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final passwordController = TextEditingController();
  String _selectedGender = 'male';
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    mobileNumberController.dispose();
    empNameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Form(
        key: formKey,
        child: ListView(
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
            TextFieldWidget(
              controller: empNameController,
              label: 'Employee Name',
              text: "",
              onChanged: (name) {
                // empName = name;
              },
            ),
            // const SizedBox(height: 24),
            // TextFieldWidget(
            //   label: 'User Id',
            //   text: "",
            //   onChanged: (userId) {},
            // ),

            const SizedBox(height: 24),
            
            const SizedBox(height: 24),
            Text(
              "Date of Birth",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextField(
              onTap: () {
                _selectDate(context);
              },
              decoration: InputDecoration(
                hintText:
                    "${selectedDate.day}-${selectedDate.month}-${selectedDate.year}",
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
                groupValue: _selectedGender,
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
                groupValue: _selectedGender,
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value!;
                  });
                },
              ),
              title: const Text('Female'),
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 1,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Enter a valid email'
                          : null,
                ),
              ],
            ),
            const SizedBox(height: 24),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 1,
                  obscureText: true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 8
                      ? 'Enter min. 8 charachters'
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: kPrimaryColor,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                if (empNameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty) {
                  signUp();
                }
                // await users
                //     .add({
                //       'emp_name': empName,
                //       'email': email,
                //       'phoneNumber': LoginOTPPage.phoneNumber,
                //       'dob': DateFormat('dd-MM-yyyy')
                //           .format(selectedDate)
                //           .toString(),
                //       'email': _selectedGender,
                //     })
                //     .then((value) => Navigator.of(context).pushReplacement(
                //         MaterialPageRoute(builder: (context) => HomeScreen())))
                //     .catchError((error) => print("Failed to add user: $error"));
              },
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 24),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate, // Refer step 1
      firstDate: DateTime(1950),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  Future signUp() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
            Center(child: CircularProgressIndicator.adaptive()));
    try {
      final newUser = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());
      if (newUser != null) {
        await ref.child(newUser.user!.uid).update({
          "name": empNameController.text,
          "email": emailController.text,
          "phoneNumber": LoginOTPPage.phoneNumber,
          "dob": DateFormat('dd-MM-yyyy').format(selectedDate).toString(),
          "gender": _selectedGender,
        }).then((_) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen()));
        });
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      showSnackBar(context, "something went wrong");
    }
  }
}
