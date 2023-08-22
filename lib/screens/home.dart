import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hostel_booking/models/hostel_models.dart';
// import 'package:hostel_booking/services/dataBase/user_store.dart';
import 'package:hostel_booking/theme/color.dart';
import 'package:hostel_booking/utils/data.dart';
import 'package:hostel_booking/widgets/city_item.dart';
import 'package:hostel_booking/widgets/feature_item.dart';
import 'package:hostel_booking/widgets/notification_box.dart';
import 'package:hostel_booking/widgets/recommend_item.dart';
// import 'package:hostel_booking/services/dataBase/hostel_store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:hostel_booking/widgets/drawer.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import 'notifications.dart'; // notifications screen
import 'brokers.dart'; //  brokers screen
import 'addHostel_screen.dart'; // add hostel screen
import 'addUsers.dart'; //  add user screen

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List hostel = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHostels();
  }

  Future<void> fetchHostels() async {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      QuerySnapshot querySnapshot = await firestore.collection('hostels').get();

      List<Map<String, dynamic>> dataList = querySnapshot.docs.map((doc) {
        Map<String, dynamic> hostelData = {};
        Map<String, dynamic>? docData = doc.data() as Map<String, dynamic>?;
        ; // Get the document's data

        if (docData != null) {
          if (docData.containsKey('name'))
            hostelData['name'] = docData['name'].toString();
          if (docData.containsKey('imageURL'))
            hostelData['imageURL'] = docData['imageURL'];
          if (docData.containsKey('relatedImagesUrls'))
            hostelData['relatedImagesUrls'] = docData['relatedImagesUrls'];
          if (docData.containsKey('price'))
            hostelData['price'] = docData['price'];
          if (docData.containsKey('district'))
            hostelData['district'] = docData['district'];
          if (docData.containsKey('town')) hostelData['town'] = docData['town'];
          if (docData.containsKey('description'))
            hostelData['description'] = docData['description'];
          if (docData.containsKey('amenities'))
            hostelData['amenities'] = docData['amenities'];
          if (docData.containsKey('contact'))
            hostelData['contact'] = docData['contact'];
          if (docData.containsKey('manager'))
            hostelData['manager'] = docData['manager'];
          if (docData.containsKey('university'))
            hostelData['university'] = docData['university'];
          if (docData.containsKey('doubleRoomsAvailability'))
            hostelData['doubleRoomsAvailability'] =
                docData['doubleRoomsAvailability'];
          if (docData.containsKey('tripleRoomsAvailability'))
            hostelData['tripleRoomsAvailability'] =
                docData['tripleRoomsAvailability'];
          if (docData.containsKey('singleRoomsAvailability'))
            hostelData['singleRoomsAvailability'] =
                docData['singleRoomsAvailability'];
        }

        return hostelData;
      }).toList();
      hostel = dataList;

      // print(dataList);
      print('Data fetched successfully');
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBgColor,
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator(), // Display circular progress indicator while loading
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: AppColor.appBarColor,
                  pinned: true,
                  snap: true,
                  floating: true,
                  title: _builAppBar(),
                ),
                SliverToBoxAdapter(
                  child: _buildBody(),
                ),
              ],
            ),
    );
  }

  Widget _builAppBar() {
    return Row(
      children: [
        Icon(
          Icons.place_outlined,
          color: AppColor.labelColor,
          size: 20,
        ),
        const SizedBox(
          width: 3,
        ),
        Text(
          "Kampala",
          style: TextStyle(
            color: AppColor.darker,
            fontSize: 13,
          ),
        ),
        const Spacer(),
        IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            _openDrawer(context);
          },
        ),
      ],
    );
  }

  void _openDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Drawer(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Notifications_Screen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Brokers'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Brokers_Screen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add Hostel'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddHostelScreen(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.add),
                title: Text('Add User'),
                onTap: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddUserScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 5, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 5),
            child: Text(
              "Find and Book",
              style: TextStyle(
                color: AppColor.labelColor,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Text(
              "The Best Hostel Rooms",
              style: TextStyle(
                color: AppColor.textColor,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ),
          _buildCities(),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Text(
              "Featured",
              style: TextStyle(
                color: AppColor.textColor,
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),
          ),
          _buildFeatured(),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommended",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textColor),
                ),
                Text(
                  "See all",
                  style: TextStyle(fontSize: 14, color: AppColor.darker),
                ),
              ],
            ),
          ),
          _getRecommend(),
        ],
      ),
    );
  }

  // void hostelList() async {
  //   HostelStore hostel = HostelStore();
  //   Future<List<dynamic>> hostelData = hostel.getHostels();
  //   List<dynamic> feature = await hostelData;
  //   print(feature);
  // }

  _buildFeatured() {
    return CarouselSlider(
      options: CarouselOptions(
        height: 300,
        enlargeCenterPage: true,
        disableCenter: true,
        viewportFraction: .75,
      ),
      items: List.generate(
        hostel.length,
        (index) => FeatureItem(
          data: hostel[index],
          onTapFavorite: () {
            // setState(() {
            //   hostel[index]["is_favorited"] = !hostel[index]["is_favorited"];
            // });
          },
        ),
      ),
    );
  }

  _getRecommend() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(15, 5, 0, 5),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          recommends.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 10),
            child: RecommendItem(
              data: recommends[index],
            ),
          ),
        ),
      ),
    );
  }

  _buildCities() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(15, 5, 0, 10),
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          cities.length,
          (index) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: CityItem(
              data: cities[index],
            ),
          ),
        ),
      ),
    );
  }
}
