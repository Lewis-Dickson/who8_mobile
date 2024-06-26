import 'package:flutter/material.dart';
import 'package:Who8/ApiService.dart';
import 'package:Who8/SharedPreferencesService.dart';

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
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: SwitchListTile(
                          title: Text(
                            isBreakfastSelected ? 'Lunch' : 'Breakfast',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          value: isBreakfastSelected,
                          onChanged: (bool value) {
                            setState(() {
                              isBreakfastSelected = value;
                            });
                          },
                          activeColor: Colors.white,
                          activeTrackColor: Colors.lightBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                // Wrap the button with SizedBox
                width: double.infinity, // Set width to fill the parent's width
                child: ElevatedButton(
                  onPressed: () async {
                    var selectedMeal =
                        isBreakfastSelected ? 'Lunch' : 'Breakfast';
                    await SharedPreferencesService.saveSelectedMeal(
                        selectedMeal);
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/qrreader');
                  },
                  child: Text(
                    'Next',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF131432),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
