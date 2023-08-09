import 'package:hotel_booking/theme.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking/screens/payment_screen.dart';

class ConfirmBookingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
            title: const Center(
              child: Text(
                'Confirm booking',
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
                Navigator.pop(context);
              },
            )),
        body: SizedBox(
          height: 900,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Full name'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'University'),
                ),
              ),
              Container(
                padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white,
                ),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none, hintText: 'Year of study'),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5), topRight: Radius.circular(5)),
                child: Container(
                  padding: EdgeInsets.only(left: 16.0, top: 4.0, bottom: 4.0),
                  decoration: BoxDecoration(
                    border:
                        Border(bottom: BorderSide(color: Colors.red, width: 1)),
                    color: Colors.white,
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                        border: InputBorder.none, hintText: 'Location'),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: true,
                    onChanged: (_) {},
                  ),
                  Text('Add this to address bookmark')
                ],
              ),
              // Spacer(),
              Center(
                child: MaterialButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CheckoutScreen()),
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
                    "Check out",
                    style: TextStyle(
                      color: whiteColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
