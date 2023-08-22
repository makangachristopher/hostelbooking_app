import 'package:flutter/material.dart';
import '../models/hostel_models.dart';
import '../services/dataBase/hostel_store.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'root_app.dart';

class Brokers_Screen extends StatelessWidget {
  const Brokers_Screen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Center(
            child: Text(
              'Brokers',
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
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => RootApp()));
            },
          )),
    );
  }
}
