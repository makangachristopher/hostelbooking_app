import 'package:hostel_booking/theme.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

String _notificationId = '';

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
                        border: InputBorder.none, hintText: 'Contact'),
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Checkbox(
                    value: true,
                    onChanged: (_) {},
                  ),
                  Expanded(
                    child: Text(
                        'By checking the box below you confirm that all the details are yours and you approve payment of 200,000 shs for hostel booking. You will we redirected to the pesapal website to complete your payments.'),
                  )
                ],
              ),
              // Spacer(),
              Center(
                child: MaterialButton(
                  onPressed: () async {
                    final String url = await _SubmitOrder();
                    launchURL(url);
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

Future<String> _SubmitOrder() async {
  try {
    final token = await _getAccessToken();
    _notificationId =
        await _registerIPNUrl(token); // New line to register IPN URL
    final url = await _submitOrderRequest(token);

    // Redirect user to payment page
    print('Redirect user to Pesapal payment page : $url');
    return url;
  } catch (error) {
    print('Error: $error');
    return 'https://example.com';
  }
}

Future<String> _getAccessToken() async {
  final response = await http.post(
    Uri.parse('https://pay.pesapal.com/v3/api/Auth/RequestToken'),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'consumer_key': '57xpHS3XBdGt/P6lOljBTUyH/hcYuvli',
      'consumer_secret': 'BUDC0KnCqmWkuJinVqGXe3YqSBM=',
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    print(data);
    return data['token'];
  } else {
    throw Exception('Authentication failed');
  }
}

Future<String> _registerIPNUrl(String token) async {
  final response = await http.post(
    Uri.parse('https://pay.pesapal.com/v3/api/URLSetup/RegisterIPN'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'url': 'https://www.myapplication.com/ipn', // Replace with your IPN URL
      'ipn_notification_type': 'POST',
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    print(data);
    return data['ipn_id'];
  } else {
    throw Exception('IPN URL registration failed');
  }
}

Future<String> _submitOrderRequest(String token) async {
  final response = await http.post(
    Uri.parse('https://pay.pesapal.com/v3/api/Transactions/SubmitOrderRequest'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: json.encode({
      'id': 'UNIQUE_ORDER_ID', // Replace with a unique order ID
      'currency': 'UGX',
      'amount': 200000,
      'description': 'Payment description',
      'callback_url':
          'https://www.myapplication.com/response-page', // Replace with your callback URL
      'notification_id': _notificationId, // Attach the notification ID
      'billing_address': {
        'email_address': 'makangachristopher5@gmail.com',
        'phone_number': '',
        'country code': 'UG',
      },
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    print(data);
    return data['redirect_url'];
  } else {
    throw Exception('Submit Order Request failed');
  }
}

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw "Could not launch $url";
  }
}
