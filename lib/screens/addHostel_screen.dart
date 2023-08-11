import 'package:flutter/material.dart';
import '../models/hostel_models.dart';
import '../services/dataBase/hostel_store.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'root_app.dart';

class AddHostelScreen extends StatefulWidget {
  const AddHostelScreen({Key? key}) : super(key: key);

  @override
  State<AddHostelScreen> createState() => _AddHostelScreenState();
}

class _AddHostelScreenState extends State<AddHostelScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String name;
  late String imageUrl;
  late List relatedImagesUrls;
  late int price;
  late String university;
  late String district;
  late String town;
  late String description;
  late List amenities = [];
  late String contact;
  late String manager;
  late bool doubleRoomsAvailability = false;
  late bool singleRoomsAvailability = false;
  late bool tripleRoomsAvailability = false;
  File? _imageFile = null;
  late String _imageUrl =
      'https://i0.wp.com/www.artisthostel.ru/wp-content/uploads/2017/09/8704858-1.jpg';
  List<XFile> _pickedImages = [];

  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  final HostelStore hostelFirebaseService = HostelStore();

  final picker = ImagePicker();

  // A function to pick a single hostel image from the gallery
  Future getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  // A function to pick multiple images from the gallery
  Future<void> _pickImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    setState(() {
      _pickedImages = pickedImages;
    });
  }

  // A function to upload the picked images to cloud storage
  Future<List> _uploadImagesToCloudStorage() async {
    List imageUrls = [];

    for (XFile imageFile in _pickedImages) {
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final destination = 'hostel_images/related_images/$fileName';

      try {
        await _storage.ref(destination).putFile(imageFile as File);
        final imageUrl = await _storage.ref(destination).getDownloadURL();
        imageUrls.add(imageUrl);
        return imageUrls;
      } catch (e) {
        print('Error uploading image to firebase: $e');
        return [];
      }
    }

    return imageUrls;
  }

  // A function to create a new hostel object from the input form
  void _addHostel() async {
    if (_imageFile != null) {
      imageUrl = await hostelFirebaseService.uploadImage(_imageFile!);
    } else {
      print('Image can not be null');
    }
    relatedImagesUrls = await _uploadImagesToCloudStorage();

    if (name.isNotEmpty) {
      Hostel hostel = Hostel(
        name: name,
        imageUrl: '',
        relatedImagesUrls: [''],
        price: price,
        district: district,
        town: town,
        description: description,
        amenities: amenities,
        contact: contact,
        manager: manager,
        university: university,
        doubleRoomsAvailability: doubleRoomsAvailability,
        tripleRoomsAvailability: tripleRoomsAvailability,
        singleRoomsAvailability: singleRoomsAvailability,
      );

      hostelFirebaseService.addHostel(hostel);

      Navigator.pop(context);
    }
  }

  // A function to show the image picker for a single hostel image

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Container(
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(Icons.photo_library),
                      title: Text('Photo Library'),
                      onTap: () {
                        getImage(ImageSource.gallery);
                      }),
                  ListTile(
                    leading: Icon(Icons.photo_camera),
                    title: Text('Camera'),
                    onTap: () {
                      getImage(ImageSource.camera);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  // A function to validate and save the form

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid. Name: $name, Price: $price');
      _addHostel();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RootApp()),
      );
    } else {
      print('Form is invalid');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Center(
            child: Text(
              'Add hostel',
              style: TextStyle(color: Colors.black),
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Color(0xff4d01ca),
              size: 15.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: SizedBox(
              height: 1200, // Set a finite height
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ),
                    child: GestureDetector(
                      onTap: () => _showPicker(context),
                      child: _imageFile != null
                          ? (kIsWeb
                              ? Image.network(_imageUrl,
                                  fit: BoxFit
                                      .cover) // For web, use Image.network
                              : Image.file(_imageFile!,
                                  fit: BoxFit
                                      .cover)) // For mobile, use Image.file
                          : Center(
                              child: Text('Add Image'),
                            ),
                    ),
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
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
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a price';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      price = int.parse(value!);
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      description = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'District'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a District';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      district = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'City/Town/Village'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a city or town or village';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      town = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'University'),
                    maxLines: 3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a university';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      university = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Manager\'s name'),
                    maxLines: 3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the Manager\'s name';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      manager = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Contact Details'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter contact details';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      contact = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Amenities'),
                    maxLines: 3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter amenities';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      setState(() {
                        amenities.add(value!);
                      });
                    },
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Checkbox(
                        value: doubleRoomsAvailability,
                        onChanged: (newValue) {
                          setState(() {
                            doubleRoomsAvailability = newValue!;
                          });
                        },
                      ),
                      Text('Double rooms available?'),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Checkbox(
                        value: singleRoomsAvailability,
                        onChanged: (newValue) {
                          setState(() {
                            singleRoomsAvailability = newValue!;
                          });
                        },
                      ),
                      Text('Single rooms available'),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Checkbox(
                        value: tripleRoomsAvailability,
                        onChanged: (newValue) {
                          setState(() {
                            tripleRoomsAvailability = newValue!;
                          });
                        },
                      ),
                      Text('Triple rooms available'),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _pickImages,
                    child: Text('Pick Images'),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, // Number of items in each row
                      ),
                      itemCount: _pickedImages.length,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _pickedImages
                                  .removeAt(index); // Remove the selected image
                            });
                          },
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                ),
                                child: Image.file(
                                  File(_pickedImages[index].path),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    child: Text('Upload'),
                    onPressed: validateAndSave,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
