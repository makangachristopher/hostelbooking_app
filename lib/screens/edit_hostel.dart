import 'package:flutter/material.dart';
import '../models/hostel_models.dart';
import '../services/dataBase/hostel_store.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EditHostelScreen extends StatefulWidget {
  final Map<String, dynamic> hostelData;

  EditHostelScreen({required this.hostelData});

  @override
  _EditHostelScreenState createState() => _EditHostelScreenState();
}

class _EditHostelScreenState extends State<EditHostelScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String name;
  late String imageUrl;
  late List relatedImages;
  late int price;
  late String university;
  late String district;
  late String town;
  late String description;
  late List amenities;
  late String contact;
  late String manager;
  late bool doubleRoomsAvailability;
  late bool singleRoomsAvailability;
  late bool tripleRoomsAvailability;

  final HostelStore hostelFirebaseService = HostelStore();
  final picker = ImagePicker();
  File? _imageFile;
  List<XFile> _pickedImages = [];

  void _prefillFormFields() {
    name = widget.hostelData['name'];
    imageUrl = widget.hostelData['imageURL'];
    relatedImages = widget.hostelData['relatedImages'];
    price = widget.hostelData['price'];
    university = widget.hostelData['university'];
    district = widget.hostelData['district'];
    town = widget.hostelData['town'];
    description = widget.hostelData['description'];
    amenities = widget.hostelData['amenities'];
    contact = widget.hostelData['contact'];
    manager = widget.hostelData['manager'];
    doubleRoomsAvailability = widget.hostelData['doubleRoomsAvailability'];
    singleRoomsAvailability = widget.hostelData['singleRoomsAvailability'];
    tripleRoomsAvailability = widget.hostelData['tripleRoomsAvailability'];
  }

  Future<void> _updateHostel() async {
    if (_formKey.currentState!.validate()) {
      // Update the hostel data based on form fields
      Map<String, dynamic> updatedHostelData = {
        'name': name,
        'imageURL': imageUrl,
        'relatedImages': relatedImages,
        'price': price,
        'university': university,
        'district': district,
        'town': town,
        'description': description,
        'amenities': amenities,
        'contact': contact,
        'manager': manager,
        'doubleRoomsAvailability': doubleRoomsAvailability,
        'singleRoomsAvailability': singleRoomsAvailability,
        'tripleRoomsAvailability': tripleRoomsAvailability,
        // ... Add other fields ...
      };

      // Update the data in Firestore
      await hostelFirebaseService.updateHostel(
        widget.hostelData['id'], // Use the hostel ID from the existing data
      );

      Navigator.pop(context); // Go back to previous screen
    }
  }

  // ... Add other functions ...

  @override
  void initState() {
    super.initState();
    _prefillFormFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Hostel'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              initialValue: name,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a name';
                }
                return null;
              },
              onSaved: (value) {
                name = value!;
              },
            ),
            // ... Other form fields ...
            ElevatedButton(
              onPressed: _updateHostel,
              child: Text('Update Hostel'),
            ),
          ],
        ),
      ),
    );
  }
}
