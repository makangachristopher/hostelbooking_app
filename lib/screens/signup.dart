import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'login_screen.dart';
import 'root_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  late String imageUrl;

  File? _profilePhoto;

  String _errorMessage = '';
  bool _isLoading = false;

  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> _signup() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

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
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'userType': 'Student',
        'imageUrl': imageUrl,
        'uid': userId,
        // ... Add other user data fields here ...
      });

      await user.updateDisplayName('$firstName $lastName');

      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => RootApp()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              height: MediaQuery.of(context).size.height,
              child: Form(
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
                      controller: _firstNameController,
                      decoration: InputDecoration(
                        hintText: 'First name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Firstname is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        hintText: 'Last name',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Last name is required';
                        }
                        return null;
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
                    // SizedBox(height: 20.0),
                    // TextFormField(
                    //   controller: _phoneNumberController,
                    //   decoration: InputDecoration(
                    //     hintText: 'Phone number',
                    //   ),
                    //   keyboardType: TextInputType.phone,
                    //   validator: (value) {
                    //     if (value!.isEmpty) {
                    //       return 'Phone number is required';
                    //     }
                    //     if (value.length < 10) {
                    //       return 'Please enter a valid phone number';
                    //     }
                    //     return null;
                    //   },
                    // ),
                    SizedBox(height: 20.0),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _signup();
                              }
                            },
                            child: Text('SIGN UP'),
                          ),
                    SizedBox(height: 20.0),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => LoginScreen()));
                      },
                      child: Text('Already have an account? Log in here'),
                    ),
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
