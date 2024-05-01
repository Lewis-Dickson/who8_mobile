import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _projectController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isServiceRunning = false; // State to track if the service is running

  @override
  void initState() {
    super.initState();
    _loadCredentials();
  }

  Future<void> _loginAndStartService() async {
    Navigator.pushNamed(context, '/mealSelect');
    return;
    if (_projectController.text.isEmpty ||
        _nameController.text.isEmpty ||
        _emailController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all the fields'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
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
    var url = Uri.parse('$baseURL/login');
    var response = await http.post(url, body: {
      'user_name': _nameController.text,
      'email': _emailController.text,
      'project_name': _projectController.text,
      'latitude': '0',
      'longitude': '0',
      'device_time': DateTime.now().toIso8601String(),
      'phone_number': '',
      'version': 'iOS'
    });
    url = Uri.parse('$baseURL/start_service');
    response = await http.post(url, body: {
      'user_name': _nameController.text,
      'email': _emailController.text,
      'project_name': _projectController.text,
      'latitude': '0',
      'longitude': '0',
      'device_time': DateTime.now().toIso8601String(),
      'phone_number': '',
      'version': 'iOS'
    });
    _saveCredentials();
  }

  void _loadCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _projectController.text = prefs.getString('project') ?? '';
      _nameController.text = prefs.getString('name') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
    });
  }

  void _saveCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('project', _projectController.text);
    await prefs.setString('name', _nameController.text);
    await prefs.setString('email', _emailController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF090a26), // A deep blue color
      body: Padding(
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
                hintText: 'Project',
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
              controller: _nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Name',
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
                hintText: 'Email',
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
              onPressed:
                  _loginAndStartService, // Call the login method when pressed
              child: Text(
                'Sign In',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
