import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../theme.dart';
import 'package:url_launcher/url_launcher.dart';
import 'addHostel_screen.dart';
import 'addUsers.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
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

  List hostel = [];
  bool isLoading = true;
  Map<String, dynamic> selectedHostel = {};

  @override
  void initState() {
    super.initState();
    selectedHostel = widget.hostelData;
  }

  Widget build(BuildContext context) {
    //  fetchHostels();
    return Scaffold(
      backgroundColor: whiteColor,
      body: SafeArea(
        child: Stack(
          children: [
            // NOTE: thumbnail image
            Container(
              width: MediaQuery.of(context).size.width,
              height: 296,
              // child: Image.asset(
              //   "assets/images/banner1.png",
              //   height: 296,
              //   width: MediaQuery.of(context).size.width,
              //   fit: BoxFit.cover,
              // ),
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
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: selectedHostel['amenities'].length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  EdgeInsets.only(left: index == 0 ? 50 : 10),
                              child: FacilityCard(
                                title: selectedHostel['amenities'][index],
                              ),
                            );
                          },
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
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                        child: Text(
                          "Alternative Images",
                          style: sectionSecondaryTitle,
                        ),
                      ),
                      if (selectedHostel['relatedImagesUrls'] != null)
                        _buildAlternativeImages(),

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
                SizedBox(height: 10),
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

  Widget _buildAlternativeImages() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children:
            (selectedHostel['relatedImages'] as List<String>).map((imageUrl) {
          return GestureDetector(
            onTap: () {
              _showImageFullscreen(
                  imageUrl); // Implement your logic to expand and fill the screen here
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

// Future<void> fetchHostels() async {
//     try {
//       FirebaseFirestore firestore = FirebaseFirestore.instance;
//       QuerySnapshot querySnapshot = await firestore.collection('hostels').get();

//       List<Map<String, dynamic>> dataList = querySnapshot.docs.map((doc) {
//         Map<String, dynamic> hostelData = {};
//         Map<String, dynamic>? docData = doc.data() as Map<String, dynamic>?;
//         ; // Get the document's data

//         if (docData != null) {
//           if (docData.containsKey('name'))
//             hostelData['name'] = docData['name'].toString();
//           if (docData.containsKey('imageURL'))
//             hostelData['imageURL'] = docData['imageURL'];
//           if (docData.containsKey('relatedImagesUrls'))
//             hostelData['relatedImagesUrls'] = docData['relatedImagesUrls'];
//           if (docData.containsKey('price'))
//             hostelData['price'] = docData['price'];
//           if (docData.containsKey('district'))
//             hostelData['district'] = docData['district'];
//           if (docData.containsKey('town')) hostelData['town'] = docData['town'];
//           if (docData.containsKey('description'))
//             hostelData['description'] = docData['description'];
//           if (docData.containsKey('amenities'))
//             hostelData['amenities'] = docData['amenities'];
//           if (docData.containsKey('contact'))
//             hostelData['contact'] = docData['contact'];
//           if (docData.containsKey('manager'))
//             hostelData['manager'] = docData['manager'];
//           if (docData.containsKey('university'))
//             hostelData['university'] = docData['university'];
//           if (docData.containsKey('doubleRoomsAvailability'))
//             hostelData['doubleRoomsAvailability'] =
//                 docData['doubleRoomsAvailability'];
//           if (docData.containsKey('tripleRoomsAvailability'))
//             hostelData['tripleRoomsAvailability'] =
//                 docData['tripleRoomsAvailability'];
//           if (docData.containsKey('singleRoomsAvailability'))
//             hostelData['singleRoomsAvailability'] =
//                 docData['singleRoomsAvailability'];
//         }

//         return hostelData;
//       }).toList();
//       hostel = dataList;

//       selectedHostel = dataList.firstWhere(
//         (hostel) => hostel['hostelID'] == widget.hostelID,
//         orElse: () => {},
//       );
//       // print(dataList);
//       print('Data fetched successfully');
//       setState(() {
//         isLoading = false;
//       });
//     } catch (e) {
//       print('Error fetching data: $e');
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
