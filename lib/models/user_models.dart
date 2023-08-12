import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;
  final String name;
  String? sex;
  final String email;
  final String userType;
  String? imageUrl;
  final int phoneNumber;
  int? otherphoneNumber;
  String? location;
  String? workArea;
  String? hostelID;

  User(
      {this.imageUrl,
      this.sex,
      this.otherphoneNumber,
      this.location,
      this.hostelID,
      this.workArea,
      required this.uid,
      required this.name,
      required this.email,
      required this.userType,
      required this.phoneNumber});

  // converting objects from firestore to supported data types

  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return User(
      uid: data?['uid'],
      name: data?['name'],
      sex: data?['sex'],
      email: data?['email'],
      userType: data?['user Type'],
      phoneNumber: data?['phone Number'],
      imageUrl: data?['imageUrl'],
      otherphoneNumber: data?['other Phone Number'],
      location: data?['location'],
      workArea: data?['Work Area'],
      hostelID: data?['hostel id'],
    );
  }
}
