import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'addHostel_screen.dart';
import 'addUsers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hostel_booking/screens/confirm_booking.dart';
import 'reviews_screen.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({required this.hostelData});

  final Map<String, dynamic> hostelData;

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

  Map<String, dynamic> selectedHostel = {};

  @override
  void initState() {
    super.initState();
    selectedHostel = widget.hostelData;
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
                    hostelName: selectedHostel['name'] ?? "No Name"),
              ),
            );
          },
          icon: Icon(Icons.reviews),
        ),
      ],
    );
  }

  Widget _buildAlternativeImages() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: selectedHostel['relatedImagesUrls'].map<Widget>((imageUrl) {
          return GestureDetector(
            onTap: () {
              _showImageFullscreen(imageUrl);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: _buildAppBar(context),
      body: SafeArea(
        child: Stack(
          children: [
            // NOTE: thumbnail image
            Container(
              width: MediaQuery.of(context).size.width,
              height: 296,
              child: CachedNetworkImage(
                imageUrl: selectedHostel['imageURL'],
                placeholder: (context, url) => BlankImageWidget(),
                errorWidget: (context, url, error) => BlankImageWidget(),
                imageBuilder: (context, imageProvider) => Container(
                  height: 296,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
                                  selectedHostel['name'] ?? "No Name",
                                  style: secondaryTitle,
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  selectedHostel['town'] ?? "Unknown Location",
                                  style: infoSecondaryTitle,
                                ),
                              ],
                            ),
                            Spacer(),
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
                                  selectedHostel['manager'],
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
                                    String phoneNumber =
                                        selectedHostel['contact'];
                                    _launchPhone("tel:$phoneNumber");
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
                        height: 30,
                        padding: EdgeInsets.only(bottom: 5),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              for (String amenity
                                  in selectedHostel['amenities']) //
                                FacilityCard(
                                  title: amenity,
                                ),
                            ],
                          ),
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
                          selectedHostel['description'],
                          style: descText,
                        ),
                      ),
                      SizedBox(height: 20),

                      // Display alternative images
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          "Alternative Images",
                          style: sectionSecondaryTitle,
                        ),
                      ),
                      _buildAlternativeImages(),

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
                    selectedHostel['description'],
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
                  '\UGX${selectedHostel['price'].toString()}',
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
