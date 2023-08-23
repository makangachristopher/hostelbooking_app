import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hostel_booking/screens/broker_details_screen.dart';

class BrokerListingPage extends StatelessWidget {
  const BrokerListingPage({Key? key, required this.userData});

  final List<Map<String, dynamic>> userData;

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> data =
        userData.where((user) => user['userType'] == 'Broker').toList();
    return Container(
      color: Colors.grey.shade900,
      child: data.isNotEmpty
          ? Column(
              children: data.map((user) {
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: userComponent(context: context, user: user),
                  actions: <Widget>[
                    IconSlideAction(
                      caption: 'Archive',
                      color: Colors.transparent,
                      icon: Icons.archive,
                      onTap: () => print("archive"),
                    ),
                    IconSlideAction(
                      caption: 'Share',
                      color: Colors.transparent,
                      icon: Icons.share,
                      onTap: () => print('Share'),
                    ),
                  ],
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'More',
                      color: Colors.transparent,
                      icon: Icons.more_horiz,
                      onTap: () => print('More'),
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.transparent,
                      icon: Icons.delete,
                      onTap: () => print('Delete'),
                    ),
                  ],
                );
              }).toList(),
            )
          : Center(
              child: Text(
                "No users found",
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }

  userComponent(
      {required BuildContext context, required Map<String, dynamic> user}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
                width: 60,
                height: 60,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.network(user['imageUrl']),
                )),
            SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(user['name'],
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500)),
              SizedBox(
                height: 5,
              ),
              Text(user['location'], style: TextStyle(color: Colors.grey[500])),
            ])
          ]),
          GestureDetector(
            onTap: () {
              // setState(() {});
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BrokerDetailsPage(brokerData: user)),
              );
            },
            child: Container(
                height: 35,
                width: 110,
                decoration: BoxDecoration(
                    color: Color(0xffffff),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: Colors.grey.shade700,
                    )),
                child: Center(
                    child: Text('Details',
                        style: TextStyle(color: Colors.white)))),
          )
        ],
      ),
    );
  }
}
