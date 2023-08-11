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
    final DocumentReference docRef = _firestore.collection('users').doc();

    await _firestore
        .collection('users')
        .add({
          'name': user.name,
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

    final String user_id = docRef.id;
    user.uid = user_id;
  }

  // A function to fetch hostels from firestore

  Future<List> getUsers() async {
    final QuerySnapshot snapshot = await _firestore.collection('users').get();
    return snapshot.docs
        .map((doc) =>
            User.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  // Updating hostel information

  Future<void> updateUser(User user) async {
    await _firestore
        .collection('users')
        .doc(user.uid)
        .update({
          'name': user.name,
          'email': user.email,
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

  // Deleting a hostel.
  Future<void> deleteUser(User user) async {
    await _firestore.collection('hostels').doc(user.uid).delete();
  }
}
