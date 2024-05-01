import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static Future<void> savePhoneNumber(String number) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('phoneNumber', number);
  }

  static Future<String?> getPhoneNumber() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('phoneNumber');
  }

  static Future<void> saveSelectedMeal(String selectedMeal) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedMeal', selectedMeal);
  }

  static Future<String?> getSelectedMeal() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('selectedMeal');
  }

  static Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<Map<String, String>> getLoginInfo() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return {
      'user_name': prefs.getString('name') ?? '',
      'email': prefs.getString('email') ?? '',
      'project_name': prefs.getString('project') ?? '',
    };
  }

  static Future<void> clearAllCredentials() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This will clear all data stored in SharedPreferences
  }
}
