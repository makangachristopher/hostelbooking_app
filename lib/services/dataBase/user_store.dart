import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_models.dart';

class UserStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

// Uploading images to cloud storage

  Future<String> uploadImage(File _imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final destination = 'user_images/$fileName';

    try {
      await _storage.ref(destination).putFile(_imageFile);
      final imageUrl = await _storage.ref(destination).getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image to firebase: $e');
      return '';
    }
  }

// A function to add a hostel to firestore

  Future<void> addUser(User user) async {
    await _firestore
        .collection('users')
        .add({
          'uid': user.uid,
          'name': user.name,
          'sex': user.sex,
          'email': user.email,
          'userType': user.userType,
          'imageUrl': user.imageUrl,
          'phoneNumber': user.phoneNumber,
          'otherphoneNumber': user.otherphoneNumber,
          'location': user.location,
          'workArea': user.workArea,
          'hostel of attachment': user.hostelID
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  // A function to fetch user from firestore
  Future<List<Map<String, dynamic>>> fetchUsers() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore.collection('users').get();

      List<Map<String, dynamic>> dataList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> userData = {};
        Map<String, dynamic>? docData = doc.data() as Map<String, dynamic>?;
        ; // Get the document's data

        if (docData != null) {
          if (docData.containsKey('name'))
            userData['name'] = docData['name'].toString();
          if (docData.containsKey('imageUrl'))
            userData['imageUrl'] = docData['imageUrl'];
          if (docData.containsKey('email'))
            userData['email'] = docData['email'];
          if (docData.containsKey('phoneNumber'))
            userData['phoneNumber'] = docData['phoneNumber'];
          if (docData.containsKey('otherPhoneNumber'))
            userData['otherPhoneNumber'] = docData['otherPhoneNumber'];
          if (docData.containsKey('location'))
            userData['location'] = docData['location'];
          if (docData.containsKey('userType'))
            userData['userType'] = docData['userType'];
          if (docData.containsKey('workArea'))
            userData['workArea'] = docData['workArea'];
          if (docData.containsKey('hostel of attachment'))
            userData['hostel of attachment'] = docData['hostel of attachment'];
        }

        return userData;
      }).toList();

      print('User data fetched');
      return dataList;

      // print(dataList);
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  // Updating user information

  Future<void> updateUser(User user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({
          'name': user.name,
          'email': user.email,
          'sex': user.sex,
          'userType': user.userType,
          'imageUrl': user.imageUrl,
          'phoneNumber': user.phoneNumber,
          'otherphoneNumber': user.otherphoneNumber,
          'location': user.location,
          'workArea': user.workArea,
          'hostel of attachment': user.hostelID
        })
        .then((value) => print("User updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  // Deleting a user.
  Future<void> deleteUser(User user) async {
    await _firestore.collection('hostels').doc(user.uid).delete();
  }
}
