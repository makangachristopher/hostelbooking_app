import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/hotel_models.dart';

class Hostel {
  final int id;
  final String name;
  final String location;
  final String university;
  final List<Room> rooms;

  Hostel({
    required this.id,
    required this.name,
    required this.location,
    required this.university,
    required this.rooms,
  });
}

class Room {
  final int id;
  final String type;
  final double price;
  final int capacity;
  final bool isAvailable;

  Room({
    required this.id,
    required this.type,
    required this.price,
    required this.capacity,
    required this.isAvailable,
  });
}

class Booking {
  final int id;
  final Hostel hostel;
  final Room room;
  final DateTime checkInDate;

  Booking({
    required this.id,
    required this.hostel,
    required this.room,
    required this.checkInDate,
  });
}
