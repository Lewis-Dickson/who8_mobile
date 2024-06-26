import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Who8/SharedPreferencesService.dart';
import '../constant.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _mobileNumber = '';

  bool _isServiceRunning = false; // State to track if the service is running

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> initMobileNumberState() async {
    // if (!await MobileNumber.hasPhonePermission) {
    //   await MobileNumber.requestPhonePermission;
    //   return;
    // }
    // // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   _mobileNumber = (await MobileNumber.mobileNumber)!;
    //   _simCard = (await MobileNumber.getSimCards)!;
    //   SharedPreferencesService.savePhoneNumber(_mobileNumber);
    // } on PlatformException catch (e) {
    //   debugPrint("Failed to get mobile number because of '${e.message}'");
    // }

    // // If the widget was removed from the tree while the asynchronous platform
    // // message was in flight, we want to discard the reply rather than calling
    // // setState to update our non-existent appearance.
    // if (!mounted) return;

    setState(() {});
  }

  Future<void> _loginAndStartService() async {
    if (_projectController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Please fill in all the fields'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
      return; // Stop the function if any field is empty
    }

    var phoneNumber = await SharedPreferencesService.getPhoneNumber();

    var url = Uri.parse('$baseURL/login_app');
    var response = await http.post(url, body: {
      'project': _projectController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'device_time': DateTime.now().toIso8601String(),
      'phone_number': phoneNumber ?? '',
      'version': Platform.isAndroid ? 'Android' : 'iOS'
    });
    try {
      if (response.statusCode == 200) {
        // Parse token from the response
        var responseData = json.decode(response.body);
        String token = responseData['token'];

        // Save credentials and token
        _saveCredentials(token);

        // Close login page after successful login
        Navigator.of(context).pop();

        // Redirect to meal selection page
        Navigator.pushNamed(context, '/mealSelect');
      } else {
        var responseData = json.decode(response.body);
        String msg = responseData['msg'];
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text(msg), // Removed the `const` here
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      }
    } on Exception catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to sign in. Please try again later.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _saveCredentials(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('project', _projectController.text);
    await prefs.setString('email', _emailController.text);
    await prefs.setString('password', _passwordController.text);
    await prefs.setString('token', token);
  }

  void _loadCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _projectController.text = prefs.getString('project') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF090a26), // A deep blue color
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset('assets/images/logo.jpg', height: 175.0),
                SizedBox(height: 48.0),
                TextField(
                  controller: _projectController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Project',
                    hintText: 'Enter your project name',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _emailController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your email',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                TextField(
                  controller: _passwordController,
                  style: TextStyle(color: Colors.white),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 2.0),
                    ),
                  ),
                ),
                SizedBox(height: 24.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF131432),
                  ),
                  onPressed: _loginAndStartService,
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            right: 16.0,
            child: Text(
              'Version 1.0.8',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
