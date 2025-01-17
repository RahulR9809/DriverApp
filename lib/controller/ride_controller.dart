import 'dart:async';
import 'dart:convert';
import 'package:employerapp/controller/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> accessToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  final token = pref.getString('accesstoken');
  return token;
}

Future<void> storeSessionCookie(String cookie) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('cookie', cookie);
}

Future<String?> getSessionCookie() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('cookie');
}

 String baseUrl = 'http://$ipConfig:3001/api/trip/driver';

class RideController {
  Future<Map<String, dynamic>> acceptRide({
    required String tripId,
    required String driverId,
    required String status,
  }) async {
    try {
      // SharedPreferences pref = await SharedPreferences.getInstance();
      // final token = pref.getString('accesstoken');
      final accesstoken = await accessToken();

      final url = Uri.parse('$baseUrl/accept-ride');
      print('accesstoken:$accesstoken');
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accesstoken',
      };
      final body = jsonEncode({
        'tripId': tripId,
        'driverId': driverId,
        'status': status,
      });

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        final cookie = response.headers['set-cookie'];

        if (cookie != null) {
          await storeSessionCookie(cookie);
        }

        print('cookidfgdggdfgdfgdgdfgdgdfgdfgdfgdfe:$cookie');
        final responseData = jsonDecode(response.body);
        response.headers.forEach((key, value) {
          print('this is key:$key and this is value:$value');
        });

        if (kDebugMode) {
          print('this is from the webservice$responseData');
          print('cdfgdgddfgdfgdgggdg:$cookie');
        }
        return responseData;
      } else if (response.statusCode == 400) {
        throw Exception('Bad Request: No necessary data to process request');
      } else {
        throw Exception(
            'Failed to accept ride. Status code: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
      rethrow;
    }
  }

  Future<void> rejectRide({
    required String driverId,
    required String status,
    required String tripId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/reject-ride');

      final body = {
        'driverId': driverId,
        'status': status,
        'tripId': tripId,
      };

      // SharedPreferences pref = await SharedPreferences.getInstance();
      // final token = pref.getString('accesstoken');
      final accesstoken = await accessToken();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accesstoken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Ride Rejected Successfully: ${response.body}');
        }
      } else {
        if (kDebugMode) {
          print('Failed to reject ride: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
    }
  }

  Future<void> startRide({
    required String tripOtp,
    required String tripId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/start-ride');

      final body = {
        'tripOtp': tripOtp,
        'tripId': tripId,
      };
      final accesstoken = await accessToken();
      final cookie = await getSessionCookie();
      print('this is teh session cookie:$cookie');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accesstoken',
          'Cookie': cookie!,
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print('Ride Started Successfully:$responseData');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
    }
  }

  Future<void> completeRide({
    required String tripId,
    required String userId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/complete-ride');

      final body = {
        'tripId': tripId,
        'userId': userId,
      };
      final accesstoken = await accessToken();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accesstoken',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (kDebugMode) {
          print('Ride Completed Successfully: ${response.body}');
        }
      } else {
        if (kDebugMode) {
          print('Failed to complete ride: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error occurred: $e');
      }
    }
  }
}
