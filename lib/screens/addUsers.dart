import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  late String name;
  late String? sex;
  late String email;
  late String userType;
  late String imageUrl;
  late int phoneNumber;
  late int otherphoneNumber;
  late String location;
  late String workArea;
  late String hostelID;
  late String uid;

  File? _profilePhoto;

  String _errorMessage = '';
  bool _isLoading = false;

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
        final ref = FirebaseStorage.instance.ref().child('users').child(userId);

        await ref.putFile(_profilePhoto!);
        final downloadUrl = await ref.getDownloadURL();

        await user.updatePhotoURL(downloadUrl);
      }

      await user.updateDisplayName('$name');

      // Store additional user data, such as phone number, in a Firestore database
      // or in the Firebase Realtime Database.

      Navigator.pushReplacementNamed(context, '/home');
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
                        name = value!;
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
                        Text(
                          'Selected Gender: ${sex ?? "Not selected"}',
                          style: TextStyle(fontSize: 16),
                        ),
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
                              if (_formKey.currentState!.validate()) {
                                _signup();
                              }
                            },
                            child: Text('SIGN UP'),
                          ),
                    SizedBox(height: 20.0),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/login');
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
