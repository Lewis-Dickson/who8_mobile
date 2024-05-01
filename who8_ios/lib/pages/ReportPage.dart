import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_flutter/SharedPreferencesService.dart';

class ReportPage extends StatefulWidget {
  final String qrResult;
  final Function() onBack;

  const ReportPage({Key? key, required this.qrResult, required this.onBack})
      : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool isLoading = true;
  bool isSuccess = false;
  late String phoneNumber;
  late String loginInfo;

  @override
  void initState() {
    super.initState();
    _retrieveUserData();
    _callBackendAPI();
  }

  Future<void> _retrieveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    phoneNumber = prefs.getString('phoneNumber') ?? '';
    loginInfo = prefs.getString('loginInfo') ?? '';
  }

  Future<void> _callBackendAPI() async {
    try {
      // Retrieve token from SharedPreferences
      final token = await SharedPreferencesService.getToken();

      // Check if token is null
      if (token == null) {
        throw Exception('Token not found in SharedPreferences');
      }

      // Prepare the data to send to the backend
      final data = {
        'qr_result': widget.qrResult,
        'device_time': DateTime.now().toIso8601String(),
        'phone_number': await SharedPreferencesService.getPhoneNumber() ?? '',
        'login_info':
            json.encode(await SharedPreferencesService.getLoginInfo()),
        'token': token,
      };

      // Replace the URL with your actual backend API endpoint
      final url = 'https://your-backend-api.com/qrscan';

      // Make the HTTP POST request to the backend API
      final response = await http.post(
        Uri.parse(url),
        body: data,
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        setState(() {
          isSuccess = true;
          isLoading = false;
        });
      } else {
        throw Exception('Failed to call API: ${response.statusCode}');
      }
    } catch (error) {
      print('Error calling API: $error');
      // Handle error state here
      setState(() {
        isLoading = false;
        isSuccess = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: isLoading
                ? Colors.black
                : isSuccess
                    ? Colors.green
                    : Colors.red,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('QR Result: ${widget.qrResult}'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Show dialog with QR content
                    _showQRContentDialog(widget.qrResult);
                  },
                  child: Text('Show QR Content'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    widget
                        .onBack(); // Call the callback function to reset the flag
                    Navigator.pop(context);
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showQRContentDialog(String qrContent) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('QR Content'),
          content: Text(qrContent),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
