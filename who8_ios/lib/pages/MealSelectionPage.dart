import 'package:flutter/material.dart';

class MealSelectionPage extends StatefulWidget {
  @override
  _MealSelectorState createState() => _MealSelectorState();
}

class _MealSelectorState extends State<MealSelectionPage> {
  bool isBreakfastSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF090a26),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select Meal:',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            SwitchListTile(
              title: Text(isBreakfastSelected ? 'Lunch' : 'Breakfast',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              value: isBreakfastSelected,
              onChanged: (bool value) {
                setState(() {
                  isBreakfastSelected = value;
                });
              },
              activeColor: Colors.white,
              activeTrackColor: Colors.lightBlue,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 20),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/qrreader');
                },
                child: Text('Start'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
