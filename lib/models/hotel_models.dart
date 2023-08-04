// ignore_for_file: unnecessary_null_comparison
import 'package:cloud_firestore/cloud_firestore.dart';

class Hostel {
  String? hostelID;
  final String name;
  final String imageUrl;
  final List relatedImagesUrls;
  final int price;
  final String university;
  final String location;
  final String description;
  final List amenities;
  final String contactDetails;
  final bool doubleRoomsAvailability;
  final bool singleRoomsAvailability;

  Hostel(
      {
      required this.name,
      required this.imageUrl,
      required this.relatedImagesUrls,
      required this.price,
      required this.university,
      required this.location,
      required this.description,
      required this.amenities,
      required this.contactDetails,
      required this.doubleRoomsAvailability,
      required this.singleRoomsAvailability});

  // converting objects from firestore to supported data types

  factory Hostel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot
  ) {
    final data = snapshot.data();
    return Hostel(
      name: data?['data'],
      imageUrl: data?['imageUrl'],
      price: data?['price'],
      university: data?['university'],
      location: data?['location'],
      description: data?['description'],
      contactDetails: data?['contactDetails'],
      doubleRoomsAvailability: data?['doubleRoomsAvailability'],
      singleRoomsAvailability: data?['singleRoomsAvailability'],
      amenities: (data?['amenities'] as Iterable?)?.toList() ?? [],
      relatedImagesUrls: (data?['relatedImageU'] as Iterable?)?.toList() ?? [],
    );
  }

  // converting these data types to a string

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (imageUrl != null) "imageUrl": imageUrl,
      if (price != null) "price": price,
      if (university != null) "university": university,
      if (location != null) "location": location,
      if (description != null) "description": description,
      if (contactDetails != null) "contactDetails": contactDetails,
      if (doubleRoomsAvailability != null)
        "doubleRoomsAvailability": doubleRoomsAvailability,
      if (singleRoomsAvailability != null)
        "singleRoomsAvailability": singleRoomsAvailability,
      if (amenities != null) "amenities": amenities,
      if (relatedImagesUrls != null) "relatedImagesUrls": relatedImagesUrls,
    };
  }
}
