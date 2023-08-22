import 'dart:io';
import 'package:hostel_booking/screens/root_app.dart';
import 'package:hostel_booking/utils/hostelList.dart';
import 'package:hostel_booking/models/hostel_models.dart';
import 'package:hostel_booking/services/dataBase/hostel_store.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddUserScreen extends StatefulWidget {
  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late String name = '';
  late String? sex = '';
  late String email = '';
  late String userType = 'Manager';
  late String imageUrl;
  late int phoneNumber = 0;
  late int otherphoneNumber = 0;
  late String location = '';
  late String workArea = '';
  late String hostelID = '';
  late String uid;
  List<String> userTypes = ['Administrator', 'Student', 'Broker', 'Manager'];
  late String selectedHostelID = ' c4c5ZA2UEBE0I2f2oxLq';
  List<Hostel> hostels = [];
  bool isLoading = true;

  File? _profilePhoto;

  String _errorMessage = '';
  bool _isLoading = false;
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> fetchHostels() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore.collection('hostels').get();

      hostels = querySnapshot.docs
          .map((doc) => Hostel.fromFirestore(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
      setState(() {
        isLoading = false;
      });
      // Print the names of the fetched hostels
      for (Hostel hostel in hostels) {
        print('Hostel Name: ${hostel.name} ${hostel.hostelID}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void _handleGenderChange(String? value) {
    setState(() {
      sex = value;
    });
  }

  Future<void> _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      final userId = user!.uid;

      if (_profilePhoto != null) {
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final destination = 'user_images/$fileName';

        try {
          await _storage.ref(destination).putFile(_profilePhoto!);
          imageUrl = await _storage.ref(destination).getDownloadURL();
        } catch (e) {
          print('Error uploading image to firebase: $e');
        }
        ;
      } else {
        imageUrl =
            'https://static.vecteezy.com/system/resources/thumbnails/002/002/403/small/man-with-beard-avatar-character-isolated-icon-free-vector.jpg';
      }

      // Add Firestore write to store user data
      try {
        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'email': email,
          'name': name,
          'uid': userId,
          'userType': userType,
          'hostelID': selectedHostelID,
          'imageUrl': imageUrl,
          'phoneNumber': phoneNumber,
          'otherPhoneNumber': otherphoneNumber,
          'sex': sex,
          'loaction': location,
          'workArea': workArea,
          // ... Add other user data fields here ...
        });
      } catch (e) {
        print(e);
      }

      await user.updateDisplayName('$name');

      // Store additional user data, such as phone number, in a Firestore database
      // or in the Firebase Realtime Database.
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An unknown error occurred';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickProfilePhoto() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profilePhoto = File(pickedFile.path);
      });
    }
  }

  void validateAndSave() {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      form.save();
      print('Form is valid. Name: $name, User Type: $userType');
      _signup();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RootApp()),
      );
    } else {
      print('Form is invalid');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchHostels();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: const Center(
              child: Text(
                'Add User',
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
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => RootApp()));
              },
            )),
        body: ListView(
          padding: EdgeInsets.all(10.0),
          children: [
            Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: _pickProfilePhoto,
                    child: Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                          width: 2.0,
                        ),
                      ),
                      child: _profilePhoto == null
                          ? Icon(
                              Icons.person,
                              size: 80.0,
                              color: Colors.grey,
                            )
                          : ClipOval(
                              child: Image.file(
                                _profilePhoto!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Full name',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter full name';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      name = value.toString();
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email is required';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Confirm password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RadioListTile(
                        title: Text('Male'),
                        value: 'male',
                        groupValue: sex,
                        onChanged: _handleGenderChange,
                      ),
                      RadioListTile(
                        title: Text('Female'),
                        value: 'female',
                        groupValue: sex,
                        onChanged: _handleGenderChange,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Phone number',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Phone number is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      phoneNumber = int.parse(value!);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Other phone number',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Other phone number is required';
                      }
                      if (value.length < 10) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      otherphoneNumber = int.parse(value!);
                    },
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'User Type', // Label for the field
                      // Add any other decoration properties you need
                    ),
                    value: userType, // The currently selected value
                    onChanged: (newValue) {
                      setState(() {
                        userType =
                            newValue.toString(); // Update the selected value
                      });
                    },
                    items:
                        userTypes.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  isLoading
                      ? CircularProgressIndicator() // Show CircularProgressIndicator while loading
                      : DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText:
                                'Hostel of attachment', // Label for the field
                            // Add any other decoration properties you need
                          ),
                          value: selectedHostelID,
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedHostelID = newValue!;
                            });
                          },
                          items: hostels
                              .map<DropdownMenuItem<String>>((Hostel hostel) {
                                return DropdownMenuItem<String>(
                                  value: hostel.hostelID,
                                  child: Text(hostel.name),
                                );
                              })
                              .toSet()
                              .toList(),
                        ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'location'),
                    maxLines: 3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a location';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      location = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Work Area'),
                    maxLines: 3,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a work area';
                      }

                      return null;
                    },
                    onSaved: (value) {
                      workArea = value!;
                    },
                  ),
                  SizedBox(height: 16.0),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () {
                            validateAndSave();
                          },
                          child: Text('Register user'),
                        ),
                  SizedBox(height: 20.0),
                  if (_errorMessage.isNotEmpty)
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ],
        ));
  }
}
