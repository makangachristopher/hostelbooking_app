import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hostel_booking/screens/confirm_booking.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BrokerDetailsPage extends StatefulWidget {
  const BrokerDetailsPage({required this.brokerData});

  final Map<String, dynamic> brokerData;

  @override
  _BrokerDetailsPageState createState() => _BrokerDetailsPageState();
}

class _BrokerDetailsPageState extends State<BrokerDetailsPage> {
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

  void _showImageFullscreen(String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: CachedNetworkImage(
            imageUrl: imageUrl,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        );
      },
    );
  }

  void _submitReview() async {
    if (_reviewController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please provide a review before submitting.")),
      );
      return;
    }

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Review newReview = Review(
        rating: _rating,
        reviewText: _reviewController.text,
      );

      // Store the review data in Firestore
      await FirebaseFirestore.instance.collection('reviews').add({
        'hostelName': selectedBroker['name'],
        'userName': user.displayName ?? user.email,
        'reviewText': newReview.reviewText,
        'rating': newReview.rating,
        'date': Timestamp.now(),
        'hostelImage': selectedBroker['imageUrl'],
        'userID': selectedBroker['uid']
      });

      _reviewController.clear();

      setState(() {
        _reviews.add(newReview);
        _hasReviewed = true;
      });
    }
  }

  Map<String, dynamic> selectedBroker = {};

  @override
  void initState() {
    super.initState();
    selectedBroker = widget.brokerData;
  }

  Widget build(BuildContext context) {
    //  fetchHostels();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Center(),
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
      backgroundColor: whiteColor,
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: whiteColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Broker",
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
                        Image.network(
                          selectedBroker['imageUrl'],
                          width: 50,
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedBroker['name'],
                              style: contentTitle,
                            ),
                            Text(
                              selectedBroker['location'],
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
                                String phoneNumber =
                                    selectedBroker['phoneNumber'].toString();
                                _launchPhone("tel:+256$phoneNumber");
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
                  SizedBox(height: 10),
                  SizedBox(height: 24),
                  // NOTE: description
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      "Work Area",
                      style: sectionSecondaryTitle,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      selectedBroker['workArea'],
                      style: descText,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Text(
                      "Alternative Images",
                      style: sectionSecondaryTitle,
                    ),
                  ),

                  // Only show the review form if the user hasn't reviewed yet
                  if (!_hasReviewed)
                    Column(
                      children: [
                        Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width *
                                0.8, // Adjust the width as needed
                            child: TextField(
                              controller: _reviewController,
                              decoration: InputDecoration(
                                hintText: 'Write a review',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 5,
                            ),
                          ),
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
                              color:
                                  index <= _rating ? Colors.amber : Colors.grey,
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
            SizedBox(height: 10),
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
                  "Cost",
                  style: priceTitle,
                ),
                Text(
                  '\UGX 25,000',
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
              minWidth: 120,
              height: 50,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              child: Text(
                "Hire Now",
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
  final String title;

  FacilityCard({
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

class BlankImageWidget extends StatefulWidget {
  const BlankImageWidget({Key? key}) : super(key: key);

  @override
  _BlankImageWidgetState createState() => _BlankImageWidgetState();
}

class _BlankImageWidgetState extends State<BlankImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      elevation: 0.0,
    );
  }
}
