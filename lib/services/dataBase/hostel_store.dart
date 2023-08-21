import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/hostel_models.dart';

class HostelStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

// Uploading images to cloud storage

  Future<String> uploadImage(File _imageFile) async {
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final destination = 'hostel_images/$fileName';

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

  Future<void> addHostel(Hostel hostel) async {
    try {
      // Create a new document reference with an automatically generated ID
      final DocumentReference docRef = _firestore.collection('hostels').doc();

      // Get the auto-generated ID
      final String hostelId = docRef.id;

      // Update the hostel object with the generated ID
      hostel.hostelID = hostelId;

      // Create a map with the hostel data including the generated ID
      Map<String, dynamic> hostelData = {
        'name': hostel.name,
        'imageURL': hostel.imageURL,
        'relatedImages': hostel.relatedImages,
        'price': hostel.price,
        'university': hostel.university,
        'district': hostel.district,
        'town': hostel.town,
        'description': hostel.description,
        'amenities': hostel.amenities,
        'contact': hostel.contact,
        'manager': hostel.manager,
        'doubleRoomsAvailability': hostel.doubleRoomsAvailability,
        'singleRoomsAvailability': hostel.singleRoomsAvailability,
        'hostelID': hostelId, // Include the generated ID in the data
      };

      // Save the hostel data to Firestore using the document reference
      await docRef.set(hostelData);

      print('Hostel Added');
    } catch (e) {
      print('Failed to add Hostel: $e');
    }
  }

  // A function to fetch hostels from firestore

  Future<List> getHostels() async {
    final QuerySnapshot snapshot = await _firestore.collection('hostels').get();
    return snapshot.docs
        .map((doc) =>
            Hostel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  // Updating hostel information

  Future<void> updateHostel(Hostel hostel) async {
    await _firestore
        .collection('hostels')
        .doc(hostel.hostelID)
        .update({
          'name': hostel.name,
          'imageURL': hostel.imageURL,
          'relatedImages': hostel.relatedImages,
          'price': hostel.price,
          'university': hostel.university,
          'location': hostel.town,
          'description': hostel.description,
          'amenities': hostel.amenities,
          'contact': hostel.contact,
          'manager': hostel.manager,
          'doubleRoomsAvailability': hostel.doubleRoomsAvailability,
          'singleRoomsAvailability': hostel.singleRoomsAvailability,
        })
        .then((value) => print("Hostel updated"))
        .catchError((error) => print("Failed to update Hostel: $error"));
  }

  // Deleting a hostel.
  Future<void> deleteHostel(Hostel hostel) async {
    await _firestore.collection('hostels').doc(hostel.hostelID).delete();
  }
}
