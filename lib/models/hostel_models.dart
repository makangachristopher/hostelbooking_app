// ignore_for_file: unnecessary_null_comparison
import 'package:cloud_firestore/cloud_firestore.dart';

class Hostel {
  String? hostelID;
  final String name;
  final String imageURL;
  final List relatedImages;
  final int price;
  final String university;
  final String district;
  final String town;
  final String description;
  final List amenities;
  final String manager;
  final String contact;
  final bool doubleRoomsAvailability;
  final bool singleRoomsAvailability;
  final bool tripleRoomsAvailability;

  Hostel(
      {this.hostelID,
      required this.name,
      required this.imageURL,
      required this.relatedImages,
      required this.price,
      required this.university,
      required this.district,
      required this.town,
      required this.description,
      required this.amenities,
      required this.manager,
      required this.contact,
      required this.doubleRoomsAvailability,
      required this.tripleRoomsAvailability,
      required this.singleRoomsAvailability});

  // converting objects from firestore to supported data types
  factory Hostel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    return Hostel(
      hostelID: data?['hostelID'],
      name: data?['name'],
      imageURL: data?['imageURL'],
      price: data?['price'],
      university: data?['university'],
      district: data?['district'],
      town: data?['town'],
      description: data?['description'],
      contact: data?['contact'],
      manager: data?['manager'],
      doubleRoomsAvailability: data?['doubleRoomsAvailability'],
      tripleRoomsAvailability: data?['tripleRoomsAvailability'],
      singleRoomsAvailability: data?['singleRoomsAvailability'],
      amenities: data?['amenities'] is Iterable
          ? (data?['amenities'] as Iterable).toList()
          : [data?['amenities']],
      relatedImages: data?['relatedImages'] is Iterable
          ? (data?['relatedImages'] as Iterable).toList()
          : [data?['relatedImages']],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageURL': imageURL,
      'relatedImages': relatedImages,
      'price': price,
      'district': district,
      'town': town,
      'description': description,
      'amenities': amenities,
      'contact': contact,
      'manager': manager,
      'university': university,
      'doubleRoomsAvailability': doubleRoomsAvailability,
      'tripleRoomsAvailability': tripleRoomsAvailability,
      'singleRoomsAvailability': singleRoomsAvailability,
    };
  }

  // converting these data types to a string

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (imageURL != null) "imageURL": imageURL,
      if (price != null) "price": price,
      if (university != null) "university": university,
      if (district != null) "district": district,
      if (town != null) "town": town,
      if (description != null) "description": description,
      if (contact != null) "contactDetails": contact,
      if (manager != null) "manager": manager,
      if (doubleRoomsAvailability != null)
        "doubleRoomsAvailability": doubleRoomsAvailability,
      if (tripleRoomsAvailability != null)
        "tripleRoomsAvailability": tripleRoomsAvailability,
      if (singleRoomsAvailability != null)
        "singleRoomsAvailability": singleRoomsAvailability,
      if (amenities != null) "amenities": amenities,
      if (relatedImages != null) "relatedImages": relatedImages,
    };
  }
}
