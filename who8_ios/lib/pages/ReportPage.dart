import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Who8/SharedPreferencesService.dart';
import 'package:Who8/constant.dart';
import 'package:audioplayers/audioplayers.dart';

class ReportPage extends StatefulWidget {
  final String qrResult;
  final String scanMethod;
  final Function() onBack;

  const ReportPage(
      {Key? key,
      required this.qrResult,
      required this.onBack,
      required this.scanMethod})
      : super(key: key);

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool isLoading = true;
  bool isSuccess = false;
  String responseMessage = '';
  AudioPlayer audioPlayer = AudioPlayer();
  String position = '';

  @override
  void initState() {
    super.initState();
    _callBackendAPI();
  }

  Future<void> _callBackendAPI() async {
    try {
      final token = await SharedPreferencesService.getToken();
      final phoneNumber = await SharedPreferencesService.getPhoneNumber() ?? '';
      final loginInfo =
          json.encode(await SharedPreferencesService.getLoginInfo());
      final selectedMeal =
          await SharedPreferencesService.getSelectedMeal() ?? '';

      // Check if token is null
      if (token == null) {
        throw Exception('Token not found in SharedPreferences');
      }

      // Prepare the data to send to the backend
      final data = {
        'qr_result': widget.qrResult,
        'meal': selectedMeal,
        'device_time': DateTime.now().toIso8601String(),
        'method': widget.scanMethod,
        'uuid': await SharedPreferencesService.getPhoneNumber() ?? '',
        'login_info':
            json.encode(await SharedPreferencesService.getLoginInfo()),
        'token': token,
      };

      // Replace the URL with your actual backend API endpoint
      final url = '$baseURL/scanNewQR';

      final headers = {
        'authorization': 'Bearer $token',
        'Content-Type': 'application/json', // Add any other necessary headers
      };

      // Make the HTTP POST request to the backend API
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: json.encode(data),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        String status = jsonResponse['status'];
        String message = jsonResponse['message'];
        position = jsonResponse['position'];
        if (status == 'success') {
          audioPlayer.play(AssetSource('assets/audio/beep_approved.mp3'));
          setState(() {
            isLoading = false;
            responseMessage = message;
          });
        } else {
          _showErrorDialog(message);
          audioPlayer.play(AssetSource('assets/audio/beep_error.mp3'));
          setState(() => isLoading = false);
        }
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
      _showErrorDialog(error.toString());
      audioPlayer.play(AssetSource('assets/audio/beep_error.mp3'));
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
            child: isLoading
                ? CircularProgressIndicator()
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.qrResult}',
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                            if (position.isNotEmpty)
                              Text('Position: $position',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.white)),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget.onBack();
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

  void _showResponseDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('API Response'),
          content: Text(responseMessage),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onBack();
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
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

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                // Navigator.of(context).pop();
                // widget.onBack();
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
