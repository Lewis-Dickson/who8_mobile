import 'package:flutter/material.dart';

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  String barcode = "";

  Future scan() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR Scan')),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text(barcode), // Placeholder for scanned content
            ),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign out'),
            onTap: () {
              // TODO: Handle sign out
            },
          ),
          ListTile(
            leading: Icon(Icons.camera_alt),
            title: Text('Scan'),
            onTap: scan,
          ),
        ],
      ),
    );
  }
}
