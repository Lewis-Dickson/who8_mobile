import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:Who8/pages/LoginPage.dart';
import 'package:Who8/pages/ReportPage.dart';
import 'package:Who8/SharedPreferencesService.dart';

class QrReader extends StatefulWidget {
  const QrReader({super.key});

  @override
  State<QrReader> createState() => _QrReaderState();
}

class _QrReaderState extends State<QrReader> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;
  bool isBreakfastSelected = false;
  bool redirectedToReportPage = false;

  @override
  void initState() {
    super.initState();
    _loadSelectedMeal();
  }

  Future<void> _loadSelectedMeal() async {
    bool selectedMealIsBreakfast =
        await SharedPreferencesService.getSelectedMeal() == "Lunch";
    setState(() {
      isBreakfastSelected = selectedMealIsBreakfast;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Stack(
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              cutOutSize: MediaQuery.of(context).size.width * 0.7,
              borderColor: Colors.white,
              borderWidth: 8,
              borderRadius: 10,
              borderLength: 30,
            ),
          ),
          Positioned(
            bottom: 20,
            child: Padding(
              padding: EdgeInsets.all(
                  8.0), // Add padding around the Positioned widget
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(8.0),
                child: Card(
                    color: Colors.transparent,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: _handleSignOut,
                            icon: Icon(Icons.logout, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                isBreakfastSelected ? 'Lunch' : 'Breakfast',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                              Switch(
                                value: isBreakfastSelected,
                                onChanged: (bool value) {
                                  setState(() {
                                    isBreakfastSelected = value;
                                  });
                                },
                                activeColor: Colors.white,
                                activeTrackColor: Colors.lightBlue,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            onPressed: _showDialog,
                            icon: Icon(Icons.add, color: Colors.white),
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _handleSignOut() async {
    bool confirm = await _showSignOutDialog();
    if (confirm) {
      await SharedPreferencesService.clearAllCredentials();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }
  }

  Future<bool> _showSignOutDialog() async {
    return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Sign Out"),
              content: Text("Are you sure you want to sign out?"),
              actions: <Widget>[
                TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Dismiss the dialog and returns false
                  },
                ),
                TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Dismiss the dialog and returns true
                  },
                ),
              ],
            );
          },
        ) ??
        false; // In case the dialog is dismissed by tapping outside of it
  }

  void _showDialog() {
    TextEditingController _textFieldController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter name to be verified'),
          content: TextField(
            controller: _textFieldController,
            decoration: InputDecoration(),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Verify'),
              onPressed: () {
                Navigator.pop(context);
                _navigateToReportPage(_textFieldController.text, "Manual");
              },
            ),
          ],
        );
      },
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (!redirectedToReportPage) {
        // Check if redirection already occurred
        _navigateToReportPage(scanData.code!, "QR");
      }
    });
  }

  void _navigateToReportPage(String qrCode, String method) async {
    setState(() {
      redirectedToReportPage = true; // Set the flag to true
    });
    var selectedMeal = isBreakfastSelected ? 'Lunch' : 'Breakfast';
    await SharedPreferencesService.saveSelectedMeal(selectedMeal);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportPage(
          qrResult: qrCode,
          onBack: () {
            setState(() {
              redirectedToReportPage = false;
            }); // Put any state reset or updates here as needed when returning from ReportPage
          },
          scanMethod: method,
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
