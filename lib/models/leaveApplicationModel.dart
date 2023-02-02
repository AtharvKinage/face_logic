import 'package:cloud_firestore/cloud_firestore.dart';

class LeaveModel {
  String? id;
  String name;
  DateTime from;
  DateTime to;
  String leaveType;
  String reason;
  String status;
  String day;
  String uid;

  LeaveModel({
    required this.name,
    required this.from,
    required this.to,
    required this.leaveType,
    required this.reason,
    required this.status,
    required this.day,
    required this.uid,
  });

  LeaveModel.fromJSON(Map<dynamic, dynamic> json)
      : name = json['name'],
        from = (json['from'] as Timestamp).toDate(),
        to = (json['to'] as Timestamp).toDate(),
        leaveType = json['leave_type'],
        reason = json['reason'],
        status = json['status'],
        day = json['day'],
        uid = json['uid'];

  LeaveModel.fromDocumentSnapshot(DocumentSnapshot doc)
      : id = doc.id,
        name = (doc.data() as Map)['name'],
        from = ((doc.data() as Map)['from'] as Timestamp).toDate(),
        to = ((doc.data() as Map)['to'] as Timestamp).toDate(),
        leaveType = (doc.data() as Map)['leave_type'],
        reason = (doc.data() as Map)['reason'],
        status = (doc.data() as Map)['status'],
        day = (doc.data() as Map)['day'],
        uid = (doc.data() as Map)['uid'];

  Map<String, dynamic> toMap() => {
        'name': name,
        'from': from,
        'to': to,
        'leave_type': leaveType,
        'reason': reason,
        'uid': uid,
        'status': status,
        'day': day,
      };
}
