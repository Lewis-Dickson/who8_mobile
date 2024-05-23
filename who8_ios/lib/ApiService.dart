import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:Who8/SharedPreferencesService.dart';

class ApiService {
  static const String baseURL = 'your_base_url';

  static Future<Map<String, String>> getHeaders() async {
    final token = await SharedPreferencesService.getToken();
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    var url = Uri.parse('$baseURL/login');
    var response = await http.post(url, body: data);
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> startService(
      Map<String, dynamic> data) async {
    var url = Uri.parse('$baseURL/start_service');
    var response = await http.post(url, body: data);
    return json.decode(response.body);
  }

  static Future<Map<String, dynamic>> scanQRCode(
      String qrResult, String deviceTime) async {
    var url = Uri.parse('$baseURL/qrscan');
    var headers = await getHeaders();
    var loginInfo = await SharedPreferencesService.getLoginInfo();
    var body = {
      'qr_result': qrResult,
      'device_time': deviceTime,
      ...loginInfo,
    };
    var response = await http.post(url, headers: headers, body: body);
    return json.decode(response.body);
  }
}
