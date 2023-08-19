import 'package:flutter/material.dart';
import 'package:hostel_booking/screens/login_screen.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _navigateToNextPage(context);
    return Scaffold(
      backgroundColor: Color(0xFF1A1934),
      body: Center(
        child: Image.asset('assets/images/hostel_hub.png'),
      ),
    );
  }

  Future<void> _navigateToNextPage(BuildContext context) async {
    await Future.delayed(
        Duration(seconds: 3)); // Simulate splash screen duration
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
  }
}
