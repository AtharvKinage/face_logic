import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? id;
  String dob;
  String email;
  String gender;
  String name;
  String phoneNumber;
  String role;
  String teamLead;

  UserModel({
    required this.dob,
    required this.email,
    required this.gender,
    required this.name,
    required this.phoneNumber,
    required this.role,
    required this.teamLead,
  });

  UserModel.fromDocumentSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        email = (doc.data() as Map)['email'],
        dob = (doc.data() as Map)['dob'],
        gender = (doc.data() as Map)['gender'],
        name = (doc.data() as Map)['name'],
        phoneNumber = (doc.data() as Map)['phoneNumber'],
        role = (doc.data() as Map)['role'],
        teamLead = (doc.data() as Map)['teamLead'] ?? "";

  Map<String, dynamic> toMap() => {
        'email': email,
        'dob': dob,
        'gender': gender,
        'name': name,
        'phoneNumber': phoneNumber,
        'role': role,
        'teamLead': teamLead,
      };
}
