import 'package:flutter/material.dart';
import '../theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'addHostel_screen.dart';
import 'addUsers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hostel_booking/screens/confirm_booking.dart';
import 'reviews_screen.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({required this.hostelID});

  final String hostelID;

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  double _rating = 0;
  TextEditingController _reviewController = TextEditingController();
  bool _hasReviewed = false;
  void _launchPhone(String phoneNumber) async {
    if (await canLaunch(phoneNumber)) {
      await launch(phoneNumber);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text('Hostel Details'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ReviewsScreen(
                    hostelName: "Modern House"), // Pass the hostel name here
              ),
            );
          },
          icon: Icon(Icons.reviews),
        ),
      ],
    );
  }

  void _submitReview() {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide a review before submitting.")),
      );
      return;
    }

    Review newReview = Review(
      rating: _rating,
      reviewText: _reviewController.text,
    );
    _reviewController.clear();

    setState(() {
      _reviews.add(newReview);
      _hasReviewed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            // NOTE: thumbnail image
            Container(
              width: MediaQuery.of(context).size.width,
              height: 296,
              child: Image.asset(
                "assets/images/banner1.png",
                height: 296,
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.cover,
              ),
            ),
            // NOTE: content
            ListView(
              children: [
                SizedBox(
                  height: 266,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(30)),
                    color: whiteColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // NOTE: title
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 24,
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Modern House",
                                  style: secondaryTitle,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "KBP Bandung, Indonesia",
                                  style: infoSecondaryTitle,
                                ),
                              ],
                            ),
                            Spacer(),
                            /* Row(
                              children: [1, 2, 3, 4, 5].map((e) {
                                return Icon(
                                  Icons.star,
                                  size: 12,
                                  color: (e <= 5) ? orangeColor : greyColor,
                                );
                              }).toList(),
                            ) */
                          ],
                        ),
                      ),
                      // NOTE: agent
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Manager",
                          style: sectionSecondaryTitle,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/images/owner1.png",
                              width: 50,
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Mr Ahumuza",
                                  style: contentTitle,
                                ),
                                Text(
                                  "Hostel Manager",
                                  style: infoText,
                                ),
                              ],
                            ),
                            Spacer(),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () {},
                                  child: Image.asset(
                                    "assets/images/message_icon.png",
                                    width: 30,
                                  ),
                                ),
                                SizedBox(width: 10),
                                InkWell(
                                  onTap: () {
                                    _launchPhone("tel:0703103834");
                                  },
                                  child: Image.asset(
                                    "assets/images/call_icon.png",
                                    width: 30,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      // NOTE: facilities
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Hostel Facilities",
                          style: sectionSecondaryTitle,
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        height: 115,
                        padding: EdgeInsets.only(bottom: 5),
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            SizedBox(width: 30),
                            FacilityCard(
                              imageUrl: "assets/images/facilities1.png",
                              title: "Swimming Pool",
                            ),
                            SizedBox(width: 20),
                            FacilityCard(
                              imageUrl: "assets/images/facilities2.png",
                              title: "4 Bedroom",
                            ),
                            SizedBox(width: 20),
                            FacilityCard(
                              imageUrl: "assets/images/facilities3.png",
                              title: "Garage",
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      // NOTE: description
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Description",
                          style: sectionSecondaryTitle,
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "Luxury homes at affordable prices with Bandung's hilly atmosphere. Located in a strategic location, flood free.",
                          style: descText,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Only show the review form if the user hasn't reviewed yet
                      if (!_hasReviewed)
                        Column(
                          children: [
                            TextField(
                              controller: _reviewController,
                              decoration: InputDecoration(
                                hintText: 'Write a review',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 5,
                            ),
                            RatingBar.builder(
                              initialRating: _rating,
                              minRating: 0,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 36,
                              itemBuilder: (context, index) {
                                return Icon(
                                  Icons.star,
                                  color: index <= _rating
                                      ? Colors.amber
                                      : Colors.grey,
                                );
                              },
                              onRatingUpdate: (rating) {
                                setState(() {
                                  _rating = rating;
                                });
                              },
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _submitReview();
                              },
                              child: Text('Submit Review'),
                            ),
                          ],
                        ),

                      // Show the reviews
                      for (Review review in _reviews)
                        ListTile(
                          title: Row(
                            children: [
                              Text('Rating: '),
                              Row(
                                children: List.generate(5, (index) {
                                  return Icon(
                                    Icons.star,
                                    color: index < review.rating
                                        ? Colors.amber
                                        : Colors.grey,
                                  );
                                }),
                              ),
                            ],
                          ),
                          subtitle: Text(review.reviewText),
                        ),

                      SizedBox(height: 110),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                // NOTE: description
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Description",
                    style: sectionSecondaryTitle,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Luxury homes at affordable prices with Bandung's hilly atmosphere. Located in a strategic location, flood free.",
                    style: descText,
                  ),
                ),
                SizedBox(height: 10),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddHostelScreen()),
                            );
                          },
                          child: Text('Add Hostel'),
                        ),
                        SizedBox(width: 20), // Add space between buttons
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddUserScreen()),
                            );
                          },
                          child: Text('Add User'),
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 110),
              ],
            ),
            // NOTE: button back
            Positioned(
              top: 20,
              left: 20,
              child: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                minWidth: 30,
                height: 30,
                padding: EdgeInsets.all(5),
                color: whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Icon(
                  Icons.arrow_back_ios_outlined,
                  size: 14,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        height: 100,
        color: whiteColor,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Price",
                  style: priceTitle,
                ),
                Text(
                  "\$7,500",
                  style: priceText,
                ),
              ],
            ),
            Spacer(),
            MaterialButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ConfirmBookingPage()),
                );
              },
              color: purpleColor,
              minWidth: 196,
              height: 50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Text(
                "Book Now",
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Review {
  final double rating;
  final String reviewText;

  Review({required this.rating, required this.reviewText});
}

List<Review> _reviews = []; // List to store reviews

// Facilities Card
class FacilityCard extends StatelessWidget {
  final String imageUrl;
  final String title;

  FacilityCard({
    required this.imageUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shadowColor: shadowColor,
      borderRadius: BorderRadius.circular(12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 100,
          height: 110,
          color: whiteColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(imageUrl),
              SizedBox(height: 9),
              Center(
                child: Text(
                  title,
                  style: facilitiesTitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
