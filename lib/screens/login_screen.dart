import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'signup.dart';
import 'root_app.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String _errorMessage = '';

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store user's email and password in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userEmail', email);
      prefs.setString('userPassword', password);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => RootApp()),
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? 'An unknown error occurred';
      });
    }
  }

  void _navigateToSignup() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userEmail');
    prefs.remove('userPassword');

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignupScreen()),
    );
  }

  void _navigateToForgotPassword() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  void initState() {
    super.initState();
    _loadSavedLoginDetails();
  }

  void _loadSavedLoginDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('userEmail');
    final savedPassword = prefs.getString('userPassword');

    if (savedEmail != null) {
      _emailController.text = savedEmail;
    }
    if (savedPassword != null) {
      _passwordController.text = savedPassword;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/images/HostelHub.png',
                height: 150.0,
              ),
              SizedBox(height: 30.0),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email address',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email address is required';
                        } else if (!value.contains('@')) {
                          return 'Invalid email address';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Password is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _login();
                        }
                      },
                      child: Text('Sign in'),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      _errorMessage,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: _navigateToForgotPassword,
                          child: Text(
                            'Forgot password?',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                        GestureDetector(
                          onTap: _navigateToSignup,
                          child: Text(
                            'Sign up',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
