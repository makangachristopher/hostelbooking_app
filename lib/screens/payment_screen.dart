import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:hostel_booking/theme.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({Key? key}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  int _totalPrice = 200000; // Change this to your actual total price

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: const Center(
            child: Text(
              'Make payment',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 13.0),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: CountryCodePicker(
                    initialSelection: 'UG',
                    favorite: ['+256', 'UG'],
                    onChanged: (code) {},
                  ),
                ),
                SizedBox(width: 8.0),
                Expanded(
                  flex: 2,
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Text(
              'Total Amount',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'UGX $_totalPrice',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
            Spacer(),
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
                  "Pay now",
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
    );
  }
}
