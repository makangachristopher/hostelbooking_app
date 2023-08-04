import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_models.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  


  // User _userFromFirebase(FirebaseUser user){
  //   return user !=null ? UserModel(uid: user.uid);
  // }

// Login function

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    }
  }
