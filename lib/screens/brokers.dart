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
        title: Text("Brokers"),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Text("Empty Brokers Screen"),
        ),
      ),
    );
  }
}
