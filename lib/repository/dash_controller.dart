



import 'dart:convert'; // For parsing JSON
import 'package:employerapp/repository/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> _getDriverId() async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('login_id');
  } catch (e) {
    if (kDebugMode) {
      print('Error retrieving Driver ID: $e');
    }
    return null;
  }
}

Future<String?> accessToken() async {
  try {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getString('accesstoken');
  } catch (e) {
    if (kDebugMode) {
      print('Error retrieving access token: $e');
    }
    return null;
  }
}

String baseUrl = 'http://$ipConfig:3001/api/trip/driver';

class DashController {
  Future<Map<String, dynamic>?> tripsData() async {
    try {
      final id=await _getDriverId();
      final accesstoken = await accessToken();
      final url = Uri.parse('$baseUrl/trips?driverId=$id');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accesstoken',
        },
      );

      if (response.statusCode == 201) {
        final data=json.decode(response.body);
        if (kDebugMode) {
          print('tripsData:===$data');
        }
        
        return data;
      } else {
        if (kDebugMode) {
          print('Failed to fetch trip count. Status: ${response.statusCode}, Body: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in tripCount: $e');
      }
      return null;
    }
  }



  Future<Map<String, dynamic>?> dashData() async {
    try {
      final id=await _getDriverId();
      final accesstoken = await accessToken();
      final url = Uri.parse('$baseUrl/tripdetails/$id');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accesstoken',
        },
      );

      if (response.statusCode == 200) {
        final data=json.decode(response.body);
        if (kDebugMode) {
          print('tripsData:===$data');
        }
        
        return data;
      } else {
        if (kDebugMode) {
          print('Failed to fetch  Status: ${response.statusCode}, Body: ${response.body}');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error in tripCount: $e');
      }
      return null;
    }
  }

}
