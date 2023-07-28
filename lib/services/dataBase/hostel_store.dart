import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/hotel_models.dart';

class HostelStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// A function to add a hostel to firestore

  Future<void> addHostel(Hostel hostel) async {
    await _firestore
        .collection('hostels')
        .add({
          'name': hostel.name,
          'imageURL': hostel.imageUrl,
          'relatedImages': hostel.relatedImagesUrls,
          'price': hostel.price,
          'university': hostel.university,
          'location': hostel.location,
          'description': hostel.description,
          'amenities': hostel.amenities,
          'contact': hostel.contactDetails,
          'doubleRoomsAvailability': hostel.doubleRoomsAvailability,
          'singleRoomsAvailability': hostel.singleRoomsAvailability,
        })
        .then((value) => print("Hostel Added"))
        .catchError((error) => print("Failed to add Hostel: $error"));
  }

  // A function to fetch hostels from firestore

  Future<List> getHostels() async {
    final QuerySnapshot snapshot = await _firestore.collection('hostels').get();
    return snapshot.docs.map((doc) => Hostel.fromFirestore(doc as DocumentSnapshot<Map<String, dynamic>>)).toList();
  }
  }
