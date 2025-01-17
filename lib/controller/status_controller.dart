import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart'as http;
import 'package:shared_preferences/shared_preferences.dart';
class StatusService{
  final baseurl='http://192.168.24.144:3001/api/trip/driver';

  Future<void> updateDriverOnlineStatus( List<double> currentLocation,) async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            final token=pref.getString('accesstoken');
            final id=pref.getString('login_token');
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token', 
  };
  final body = jsonEncode({
    'driverId': id,
    'currentLocation': currentLocation,
  });
    final url = Uri.parse("$baseurl/online"); 
  try {
    final response = await http.put(url, headers: headers, body: body);

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      if (kDebugMode) {
        print("Update successful: ${responseData['data']}");
      }
    } else {
      if (kDebugMode) {
        print("Failed to update: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("Error response: ${response.body}");
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print("Error occurred: $error");
    }
  }
}
}